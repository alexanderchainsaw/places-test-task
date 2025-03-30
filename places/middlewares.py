import logging
import time
from contextvars import ContextVar
from uuid import uuid4

from fastapi import Request, Response
from starlette.routing import Match

import places.metrics as metrics

logger = logging.getLogger(__name__)
request_id_contextvar = ContextVar("request_id_contextvar")


def _get_url_name(request: Request) -> str:
    for route in request.app.routes:
        match, _ = route.matches(request.scope)
        if match == Match.FULL:
            return route.path

    return "not_matched"


async def request_id_middleware(request: Request, call_next):
    """
    Добавляет request_id в контекст.
    """
    request_id = request.headers.get("X-Request-Id")
    if not request_id:
        request_id = str(uuid4())

    token = request_id_contextvar.set(request_id)
    try:
        return await call_next(request)
    finally:
        request_id_contextvar.reset(token)


async def access_log_middleware(request: Request, call_next):
    status = None
    time_start = time.monotonic()
    try:
        response: Response = await call_next(request)
        status = response.status_code
        return response
    except Exception:
        status = 500
        raise
    finally:
        time_elapsed = time.monotonic() - time_start
        logger.info(
            "%s %.3f %s %s", status, time_elapsed, request.method, request.url
        )


async def request_time_middleware(request: Request, call_next):
    time_start = time.monotonic()
    try:
        return await call_next(request)
    finally:
        time_elapsed = time.monotonic() - time_start
        metrics.request_time.labels(name=_get_url_name(request)).observe(
            time_elapsed
        )


async def request_status_middleware(request: Request, call_next):
    status = None
    try:
        response: Response = await call_next(request)
        status = response.status_code
        return response
    except Exception:
        status = 500
        raise
    finally:
        metrics.request_status_count.labels(
            name=_get_url_name(request), status=status
        ).inc()
