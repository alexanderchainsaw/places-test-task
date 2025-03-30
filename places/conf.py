import os

AUTO_RELOAD = bool(os.environ.get("AUTO_RELOAD"))

PROMETHEUS_NAME_PREFIX = os.environ.get("PROMETHEUS_NAME_PREFIX")
PROMETHEUS_PORT = int(os.environ.get("PROMETHEUS_PORT", 9100))

SENTRY_DSN = os.environ["SENTRY_DSN"]
ENVIRONMENT = os.environ.get("ENVIRONMENT", "unknown")

DATABASE_DSN = os.environ.get("DATABASE_DSN")
