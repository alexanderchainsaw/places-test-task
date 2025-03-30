import logging

import sentry_sdk
import uvicorn
from fastapi import FastAPI
from fastapi.exception_handlers import request_validation_exception_handler
from fastapi.exceptions import RequestValidationError
from sentry_sdk.integrations.fastapi import FastApiIntegration

import places.conf as conf
import places.log as log
import places.metrics as metrics
import places.middlewares as middlewares
import places.migrations_runner as migrations_runner
from places.state import app_state
from places.views.content.views import router as content_router

log.setup_logging()
logger = logging.getLogger(__name__)

sentry_sdk.init(
    dsn=conf.SENTRY_DSN,
    integrations=[FastApiIntegration()],
    environment=conf.ENVIRONMENT,
)

app = FastAPI()
app.middleware("http")(middlewares.access_log_middleware)
app.middleware("http")(middlewares.request_time_middleware)
app.middleware("http")(middlewares.request_status_middleware)
app.middleware("http")(middlewares.request_id_middleware)

app.include_router(content_router)


@app.on_event("startup")
async def setup():
    # Ожидаем запуск бд (заменено на healthcheck)
    # if conf.ENVIRONMENT == "dev":
    #     await asyncio.sleep(5)

    migrations_runner.apply()
    metrics.expose_prometheus()
    await app_state.startup()


@app.on_event("shutdown")
async def shutdown():
    await app_state.shutdown()


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request, exc):
    logger.info("Validation error=%s", {"url": request.url, "err": exc})
    return await request_validation_exception_handler(request, exc)


if __name__ == "__main__":
    uvicorn.run(
        app="places.app:app",
        host="0.0.0.0",
        port=8080,
        reload=conf.AUTO_RELOAD,
        access_log=False,
    )
