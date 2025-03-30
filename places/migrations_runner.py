from yoyo import get_backend, read_migrations

import places.conf as conf

MIGRATIONS_PATH = "/app/places/migrations"


def apply():
    backend = get_backend(conf.DATABASE_DSN)
    migrations = read_migrations(MIGRATIONS_PATH)

    with backend.lock():
        backend.apply_migrations(backend.to_apply(migrations))
