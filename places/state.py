import json

from asyncpg import Pool, create_pool

import places.conf as conf
from places.repository.content import ContentRepository


class AppState:
    def __init__(self) -> None:
        self._db = None
        self._content_repo = None

    async def init_connection(self, conn):
        await conn.set_type_codec(
            "jsonb",
            encoder=json.dumps,
            decoder=json.loads,
            schema="pg_catalog",
        )

    async def startup(self) -> None:
        self._db = await create_pool(
            dsn=conf.DATABASE_DSN,
            init=self.init_connection,
            server_settings={"jit": "off"},
        )
        self._content_repo = ContentRepository(db=self.db)

    async def shutdown(self) -> None:
        if self._db:
            await self._db.close()

    @property
    def db(self) -> Pool:
        assert self._db
        return self._db

    @property
    def content_repo(self) -> ContentRepository:
        assert self._content_repo
        return self._content_repo


app_state = AppState()
