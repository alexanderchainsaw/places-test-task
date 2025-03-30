-- Корневые категории
insert into "content_entity" (type, priority) VALUES (0, 5); -- ID 1
insert into "content_entity" (type, priority) VALUES (0, 10); -- ID 2
insert into "translation_category" (content_entity_id, name, preview_photo_url) VALUES (1, 'Еда', 'https://link.com/123link.com/123');
insert into "translation_category" (content_entity_id, name, preview_photo_url) VALUES (2, 'Мероприятия', 'https://link.com/123');

-- Категории 2 уровня
insert into "content_entity" (type, priority) VALUES (1, 5);  -- ID 3
insert into "content_entity" (type, priority) VALUES (1, 7); -- ID 4
insert into "content_entity" (type, priority) VALUES (1, 11); -- ID 5
insert into "content_entity" (type, priority) VALUES (1, -1); -- ID 6
insert into "content_entity" (type, priority) VALUES (1, 0); -- ID 7
insert into "translation_category" (content_entity_id, name, preview_photo_url) VALUES (3, 'Рестораны', 'https://link.com/123');
insert into "translation_category" (content_entity_id, name, preview_photo_url) VALUES (4, 'Кофейни', 'https://link.com/123');
insert into "translation_category" (content_entity_id, name, preview_photo_url) VALUES (5, 'Стритфуд', 'https://link.com/123');
insert into "translation_category" (content_entity_id, name, preview_photo_url) VALUES (6, 'Стэндапы', 'https://link.com/123');
insert into "translation_category" (content_entity_id, name, preview_photo_url) VALUES (7, 'Концерты', 'https://link.com/123');
insert into "content_relations" (parent, child) VALUES (1, 3);
insert into "content_relations" (parent, child) VALUES (1, 4);
insert into "content_relations" (parent, child) VALUES (1, 5);
insert into "content_relations" (parent, child) VALUES (2, 6);
insert into "content_relations" (parent, child) VALUES (2, 7);

-- Категории 3 уровня
insert into "content_entity" (type, priority) VALUES (2, 10); -- ID 8
insert into "content_entity" (type, priority) VALUES (2, 10); -- ID 9
insert into "content_entity" (type, priority) VALUES (2, -99); -- ID 10
insert into "content_entity" (type, priority) VALUES (2, 1); -- ID 11
insert into "content_entity" (type, priority) VALUES (2, 0); -- ID 12
insert into "content_entity" (type, priority) VALUES (2, 0); -- ID 13
insert into "translation_category" (content_entity_id, name, preview_photo_url) VALUES (8, 'Азия', 'https://link.com/123');
insert into "translation_category" (content_entity_id, name, preview_photo_url) VALUES (9, 'Италия', 'https://link.com/123');
insert into "translation_category" (content_entity_id, name, preview_photo_url) VALUES (10, 'На вынос', 'https://link.com/123');
insert into "translation_category" (content_entity_id, name, preview_photo_url) VALUES (11, 'Бюджетные', 'https://link.com/123');
insert into "translation_category" (content_entity_id, name, preview_photo_url) VALUES (12, 'Бургеры', 'https://link.com/123');
insert into "translation_category" (content_entity_id, name, preview_photo_url) VALUES (13, 'Шаверма', 'https://link.com/123');

insert into "content_relations" (parent, child) VALUES (3, 8);
insert into "content_relations" (parent, child) VALUES (3, 9);
insert into "content_relations" (parent, child) VALUES (4, 10);
insert into "content_relations" (parent, child) VALUES (4, 11);
insert into "content_relations" (parent, child) VALUES (5, 12);
insert into "content_relations" (parent, child) VALUES (5, 13);


-- Заведения
insert into "content_entity" (type, priority) VALUES (20, 0); -- ID 14
insert into "translation_card" (content_entity_id, name, preview_photo_url) VALUES (14, 'Ресторан 1', 'https://link.com/123');
insert into "content_relations" (parent, child) VALUES (3, 14);

insert into "content_entity" (type, priority) VALUES (20, 0); -- ID 15
insert into "translation_card" (content_entity_id, name, preview_photo_url) VALUES (15, 'Азиатский ресторан', 'https://link.com/123');
insert into "content_relations" (parent, child) VALUES (8, 15);

insert into "content_entity" (type, priority) VALUES (20, 0); -- ID 16
insert into "translation_card" (content_entity_id, name, preview_photo_url) VALUES (16, 'Итальянский ресторан', 'https://link.com/123');
insert into "content_relations" (parent, child) VALUES (9, 16);

insert into "content_entity" (type, priority) VALUES (20, 0); -- ID 17
insert into "translation_card" (content_entity_id, name, preview_photo_url) VALUES (17, 'Кофе с собой', 'https://link.com/123');
insert into "content_relations" (parent, child) VALUES (10, 17);

insert into "content_entity" (type, priority) VALUES (20, 0); -- ID 18
insert into "translation_card" (content_entity_id, name, preview_photo_url) VALUES (18, 'Кофе по 5р.', 'https://link.com/123');
insert into "content_relations" (parent, child) VALUES (11, 18);

insert into "content_entity" (type, priority) VALUES (20, 10); -- ID 19
insert into "translation_card" (content_entity_id, name, preview_photo_url) VALUES (19, 'Бургеры 1', 'https://link.com/123');
insert into "content_relations" (parent, child) VALUES (12, 19);

insert into "content_entity" (type, priority) VALUES (20, -50); -- ID 20
insert into "translation_card" (content_entity_id, name, preview_photo_url) VALUES (20, 'Шаверма 1', 'https://link.com/123');
insert into "content_relations" (parent, child) VALUES (13, 20);

insert into "content_entity" (type, priority) VALUES (20, 0); -- ID 21
insert into "translation_card" (content_entity_id, name, preview_photo_url) VALUES (21, 'Стендап 1', 'https://link.com/123');
insert into "content_relations" (parent, child) VALUES (6, 21);

insert into "content_entity" (type, priority) VALUES (20, 0); -- ID 22
insert into "translation_card" (content_entity_id, name, preview_photo_url) VALUES (22, 'Стендап 2', 'https://link.com/123');
insert into "content_relations" (parent, child) VALUES (6, 22);

insert into "content_entity" (type, priority) VALUES (20, 100); -- ID 23
insert into "translation_card" (content_entity_id, name, preview_photo_url) VALUES (23, 'Концерт 1', 'https://link.com/123');
insert into "content_relations" (parent, child) VALUES (7, 23);

insert into "content_entity" (type, priority) VALUES (20, 7); -- ID 24
insert into "translation_card" (content_entity_id, name, preview_photo_url) VALUES (24, 'Концерт 2', 'https://link.com/123');
insert into "content_relations" (parent, child) VALUES (7, 24);
