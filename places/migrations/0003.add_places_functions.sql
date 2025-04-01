
-- Рекурсивная фукнция чтобы получить места категории и вложеных категорий
-- Тоже самое что и простая функция ниже, но сначала рекурсивно собираем вложенные категории

CREATE OR REPLACE FUNCTION get_category_places_recursive(
    _category_id INTEGER,
    _locale VARCHAR(2),
    _limit INTEGER,
    _offset INTEGER
)
RETURNS TABLE (
    id INTEGER,
    type SMALLINT,
    priority INTEGER,
    name VARCHAR(256),
    preview_photo_url TEXT,
    category_id INTEGER,
    category_name VARCHAR(256),
    content TEXT,
    locale VARCHAR(2)
) AS $$

-- Первое отличие от простой функции: рекурсивно собираем вложенные категории начиная с указанного id
WITH RECURSIVE category_tree AS (
    SELECT _category_id AS node_id
    UNION ALL
    SELECT cr.child AS node_id
    FROM content_relations cr
    INNER JOIN category_tree ct ON cr.parent = ct.node_id
    WHERE cr.child IN (SELECT id FROM content_entity WHERE type < 20)
)

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
AND tcd.locale = _locale
AND tct.locale = _locale
AND cr.parent in category_tree -- Второе отличие от простой функции, проверяем есть ли parent в рекурсивно-собранных категориях
ORDER BY ce.priority DESC
LIMIT _limit
OFFSET _offset
$$ LANGUAGE SQL STABLE;

-- Простая функция чтобы получить все места
-- Тоже самое что и функция выше но без рекурсивной части

CREATE OR REPLACE FUNCTION get_all_places(
    _locale VARCHAR(2),
    _limit INT DEFAULT NULL,
    _offset INT DEFAULT 0)
RETURNS TABLE (
    id INTEGER,
    type SMALLINT,
    priority INTEGER,
    name VARCHAR(256),
    preview_photo_url TEXT,
    category_id INTEGER,
    category_name VARCHAR(256),
    content TEXT,
    locale VARCHAR(2)
) AS $$
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
AND tcd.locale = _locale
AND tct.locale = _locale

ORDER BY ce.priority DESC
LIMIT _limit
OFFSET _offset
$$ LANGUAGE SQL STABLE;
