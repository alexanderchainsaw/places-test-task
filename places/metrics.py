from prometheus_client import start_http_server
from prometheus_client.metrics import Counter, Histogram

import places.conf as conf


def _prepare_prefix(prefix: str | None) -> str:
    if not prefix:
        return ""

    return prefix.strip("_") + "_"


prefix = _prepare_prefix(conf.PROMETHEUS_NAME_PREFIX)

handler_events = Counter(
    name=f"{prefix}handler_events",
    documentation="Events by handler.",
    labelnames=["name", "type"],
)

request_status_count = Counter(
    name=f"{prefix}request_status_count",
    documentation="Request count by status.",
    labelnames=["status", "name"],
)

request_time = Histogram(
    name=f"{prefix}request_time",
    documentation="Request time.",
    labelnames=["name"],
)


def expose_prometheus() -> None:
    """
    Запускает сервер с метриками для prometheus.
    """
    start_http_server(port=conf.PROMETHEUS_PORT)
