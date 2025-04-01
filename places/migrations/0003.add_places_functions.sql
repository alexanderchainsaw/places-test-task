
-- Рекурсивная фукнция чтобы получить места категории и вложеных категорий

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
    tc.name,
    tc.preview_photo_url,
    cr.parent AS category_id,
    (
        SELECT name
        FROM translation_category
        WHERE content_entity_id = cr.parent AND locale = _locale
        LIMIT 1
    ) AS category_name,
    tc.content,
    tc.locale
FROM content_entity ce
INNER JOIN content_relations cr ON ce.id = cr.child
INNER JOIN translation_card tc ON ce.id = tc.content_entity_id
WHERE ce.is_deleted = false
    AND ce.is_published = true
    AND ce.type >= 20
    AND tc.locale = _locale
    AND cr.parent IN (SELECT node_id FROM category_tree)
ORDER BY ce.priority DESC
LIMIT _limit
OFFSET _offset
$$ LANGUAGE SQL STABLE;

-- Простая функция чтобы получить все места

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
AND tcd.locale = $1
AND tct.locale = $1

ORDER BY ce.priority DESC
LIMIT _limit
OFFSET _offset
$$ LANGUAGE SQL STABLE;