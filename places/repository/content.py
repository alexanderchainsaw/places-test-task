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
        limit: Optional[int] = None,
        offset: int = 0,
        locale: str = "ru",
    ) -> list[Place]:
        """
        Получить места по ID категории. Если category_id == None, возвращаем все места. Если ID предоставлено,
        возвращаем все места данной категории и всех вложенных категорий.
        В обоих случаях возвращаем только места в которых is_deleted=False и is_published=true,
        отсортированные по priority
        :param int category_id: ID категории (content_entity)
        :param int limit: Ограничить количество возвращаемых мест
        :param int offset: Пропустить n количество вовращаемых мест
        :param str locale: Язык локализации возвращаемых мест: "ru", "en", ...
        :return: Список мест (моделей Place)
        """
        if category_id is None:
            # Собираем все данные о местах
            query = """
                SELECT
                    ce.id,
                    ce.type,
                    ce.priority,
                    tcd.name,
                    tcd.preview_photo_url,
                    cr.parent AS category_id,
                    tct.name AS category_name,
                    tcd.content,
                    tcd.locale
                FROM content_entity ce
                
                INNER JOIN translation_card tcd 
                ON ce.id = tcd.content_entity_id 
                    
                INNER JOIN content_relations cr 
                ON ce.id = cr.child
                    
                INNER JOIN translation_category tct 
                ON cr.parent = tct.content_entity_id 
                    
                WHERE ce.type >= 20  
                AND ce.is_deleted = false
                AND ce.is_published = true
                AND tcd.locale = $1
                AND tct.locale = $1
                    
                ORDER BY ce.priority DESC
            """

            if limit is not None:
                query += " LIMIT $2 OFFSET $3"
                rows = await self._db.fetch(query, locale, limit, offset)
            else:
                query += " OFFSET $2"
                rows = await self._db.fetch(query, locale, offset)
        else:
            # Рекурсивный запрос, собираем места относящиеся к категории и ко всем вложенным категориям
            query = """
                WITH RECURSIVE category_tree AS (
                    SELECT $1::INTEGER AS node_id
                    UNION ALL
                    SELECT cr.child AS node_id
                    FROM content_relations cr
                    INNER JOIN category_tree ct ON cr.parent = ct.node_id
                    WHERE cr.child IN (
                        SELECT id FROM content_entity 
                        WHERE type < 20
                    )
                )
                SELECT
                    ce.id,
                    ce.type,
                    ce.priority,
                    tc.name,
                    tc.preview_photo_url,
                    cr.parent AS category_id,
                    (
                        SELECT name 
                        FROM translation_category 
                        WHERE 
                            content_entity_id = cr.parent 
                            AND locale = $2
                        LIMIT 1
                    ) AS 
                    category_name,
                    tc.content,
                    tc.locale
                FROM content_entity ce
                INNER JOIN content_relations cr ON ce.id = cr.child
                INNER JOIN translation_card tc ON ce.id = tc.content_entity_id
                WHERE
                    ce.is_deleted = false
                    AND ce.is_published = true
                    AND ce.type = 20
                    AND tc.locale = $2
                    AND cr.parent IN (SELECT node_id FROM category_tree)
                ORDER BY ce.priority DESC
            """
            if limit is not None:
                query += " LIMIT $3 OFFSET $4"
                rows = await self._db.fetch(
                    query, category_id, locale, limit, offset
                )
            else:
                query += " OFFSET $3"
                rows = await self._db.fetch(query, category_id, locale, offset)

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
