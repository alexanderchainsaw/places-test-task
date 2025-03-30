create table "content_entity" (
    "id" serial primary key,
    "type" smallint not null, -- Тип контента 0-19 категории соответственного уровня, >20 заведения разных типов
    "is_published" bool not null default(true),
    "is_deleted" bool not null default(false),
    "priority" int default (0),
    "created_timestamp" timestamp not null default (now() at time zone 'utc')
);
create table "content_relations" (
    "id" serial primary key,
    "parent" int not null,
    "child" int,
    "created_timestamp" timestamp not null default (now() at time zone 'utc')
);
create unique index "content_relations__parent__child__unique_idx" on "content_relations" ("parent","child");
create table "translation_category" (
    "id" serial primary key,
    "content_entity_id" int not null,
    "name" varchar(256),
    "preview_photo_url" text,
    "locale" varchar(2) not null default('ru'),
    "created_timestamp" timestamp not null default (now() at time zone 'utc')
);
create unique index "translation_category__content_entity_id__locale__unique_idx" on "translation_category" ("content_entity_id","locale");
create table "translation_card" (
    "id" serial primary key,
    "content_entity_id" int not null,
    "name" varchar(256),
    "preview_photo_url" text,
    "content" text not null default (''),
    "locale" varchar(2) not null default('ru'),
    "created_timestamp" timestamp not null default (now() at time zone 'utc')
);
create unique index "translation_card__content_entity_id__locale__unique_idx" on "translation_card" ("content_entity_id","locale");
