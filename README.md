# Тестовое задание

## О репозитории
Вам представлено веб-приложение "Places", главная функция которого - предоставлять пользователям карточки заведений и мест, в которые можно сходить.

## Структура данных
Полный список полей и таблиц можно посмотреть в миграциях `/places/migrations`.

В целом контент приложения представляет собой категории, карточки заведений и их связи.
- `content_entity` - Таблица которая представляет "сущность" контента - категорию и/или карточку заведения.
- `content_relation` - Таблица для связей категорий и карточек. У каждой категории может быть один родитель (категория уровнем выше) или не быть родителя если это корневая категория и множество потомков - других категорий и заведений. У заведения может быть множество родителей (всегда категории) и не бывает потомков. Вложенность реализуется только посредством категорий.
- `translation_category` - Перевод информации о категории, по умолчанию всегда русский язык (`locale = 'ru'`).
- `translation_card` - Перевод информации о заведении, по умолчанию всегда русский язык (`locale = 'ru'`).

В дальнейшем подразумевается, что приложение будет переведено на более чем 1 язык, для этого контент хранится в таблицах `translation_..`. На данном этапе у категории и заведения всегда есть только 1 перевод - `'ru'`

## Задача
Необходимо добавить в приложение HTTP GET метод, который на вход будет получать ID категории (может быть null).
В ответ отправлять пользователю JSON массив с списком заведений, которые прикреплены к выбранной категории и ко всем вложенным.
Формат данных такой:
```json
{
    "places": [
        {
            "id": "<int>",
            "type": "<int>",
            "priority": "<int>",
            "name": "<str>",
            "preview_photo_url": "<str>",
            "category_id": "<int>",
            "category_name": "<str>",
            "content": "<str>",
            "locale": "<str>"
        }
    ]
}
```

Например, если у нас есть следующая иерархия:
- Еда
    - Рестораны
        - Азия
        - Италия
    - Кофейни
        - На вынос
        - Бюджетные
    - Стритфуд 
        - Бургеры
        - Шаверма
- Мероприятия
    - Стэндап
    - Концерты

Получив на вход ID категории "Еда", мы должны будем вернуть все заведения, которые расположены напрямую в категории "Еда", а также во всех вложенных категориях (Рестораны, Азия, Кофейни и т.д.).
Если на вход получен null, тогда нужно вернуть все заведения.

Обязательно нужно проверять заведения на удаление (`is_deleted`) и публикацию (`is_published`), а также сортировать по приоритету.

> Метод описать в файле `/places/views/content/views.py`

> Добавлять миграции разрешается, но без серьезных изменений в структуру таблиц (добавить вспомогательные поля, поменять тип поля или добавить индекс если нужно - ОК, перераспределять данные между таблиами - НЕ ОК)

> Для работы с Postgres использовать библиотеку asyncpg
> Использование всопомгательных библиотек разрешается

Далее описаны дополнительные задания, выполнение которых необязательно, но поощрается.

### Дополнительное задание 1
Добавить в метод пагинацию (`limit` и `offset`).

### Дополнительное задание 2
Добавить в приложение возможность получать заведения не только на русском, но и на других языках (например добавить локаль 'en').


## Инструкция по запуску
1. Установить ПО
    - Python
    - Docker
    - утилиту Make
2. Создать окружение
```
make venv
```
3. Создать в корне проекта директорию pgdata - в неё будут сохраняться данные из контейнера Postgres
4. Собрать контейнеры приложения
```
make dev-build
```
5. Запустить
```
make dev-start
``` 

### Дополнительная информация
1. Перед отправкой кода на GitLab проверяйте его форматтером (`make pretty` или `make pretty-win`), в противном случае коммиты будут помечены как некачественные.
2. При первом запуске приложение может завершиться с ошибкой, поскольку на инициализацию базы данных нужно некоторое время, после получения сообщения `database system is ready to accept connections` можно перезапускать контейнеры и работать.
3. Для доступа к базе данных (через терминал и утилиту psql внутри контейнера postgres)
```
docker exec -it postgres bash
psql -U postgres
```

## Отправка решения
Решение можно опубликовать на любом хранилище Git репозиториев, либо создать форк в нашем GitLab.

## Решение
- Добавил необходимый метод в /places/views/content/views.py (с лимитом, оффсетом и локализацией), а необходимый запрос в базу данных в /places/repository/content.py
- Исправил иерархию категорий в мок данных (0002.add_mock_data.sql), а также поменял дефолтное значение при создании контента на is_published=True (чтобы легче было тестировать)
- Добавил healthcheck базе данных в docker-compose файл, чтобы всё запускалось и с первого раза (до создания volume)
- Добавил uv чтобы легче работать с зависимостями, версиями python, линтерами, и тд

## Рефакторинг
 - Перенёс SQL запросы в отдельные SQL функции (places/migrations/0003.add_places_functions.sql), теперь places/repository/content.py намного чище, а также запрос выполняется быстрее.
 - Добавил валидацию параметров в view (поля offset и limit)
