import logging
from typing import Optional

from asyncpg import Pool

from places.views.content.models import Place

logger = logging.getLogger(__name__)


class ContentRepository:
    def __init__(self, db: Pool):
        self._db = db

    async def get_places_by_category(
        self,
        category_id: Optional[int] = None,
        locale: str = "ru",
        limit: Optional[int] = None,
        offset: int = 0,
    ) -> list[Place]:
        """
        Получить места по ID категории. Если category_id == None, возвращаем все места. Если ID предоставлено,
        возвращаем все места данной категории и всех вложенных категорий.
        В обоих случаях возвращаем только места в которых is_deleted=False и is_published=true,
        отсортированные по priority
        :param int category_id: ID категории (content_entity)
        :param str locale: Язык локализации возвращаемых мест: "ru", "en", ...
        :param int limit: Ограничить количество возвращаемых мест
        :param int offset: Пропустить n количество вовращаемых мест

        :return: Список мест (моделей Place)
        """

        # Используем заранее созданые SQL функции ./places/migrations/0003.add_places_functions.sql

        if category_id is None:
            rows = await self._db.fetch(
                "SELECT * FROM get_all_places($1, $2, $3);",
                locale,
                limit,
                offset,
            )
        else:
            rows = await self._db.fetch(
                "SELECT * FROM get_category_places_recursive($1, $2, $3, $4);",
                category_id,
                locale,
                limit,
                offset,
            )

        return [
            Place(
                id=row["id"],
                type=row["type"],
                priority=row["priority"],
                name=row["name"],
                preview_photo_url=row["preview_photo_url"],
                category_id=row["category_id"],
                category_name=row["category_name"],
                content=row["content"],
                locale=row["locale"],
            )
            for row in rows
        ]
