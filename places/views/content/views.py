import logging
from typing import Optional

from fastapi import APIRouter, Query

from places.state import app_state
from places.views.content.models import PlacesResponse

logger = logging.getLogger(__name__)
router = APIRouter()


@router.get("/places", response_model=PlacesResponse)
async def get_places(
    category_id: Optional[int] = Query(
        None,
        description="Если ID предоставлено, возвращаем все места данной категории и всех вложенных категорий."
        "Если нет, возвращаем все места",
    ),
    limit: Optional[int] = Query(
        None, description="Ограничить количество возвращаемых мест"
    ),
    offset: Optional[int] = Query(
        0, description="Пропустить n количество вовращаемых мест"
    ),
    locale: str = Query("ru", description="Язык локализации ('ru', 'en', ...)"),
):
    """
    Получить места по ID категории. Если category_id == None, возвращаем все места. Если ID предоставлено,
    возвращаем все места данной категории и всех вложенных категорий.
    В обоих случаях возвращаем только места в которых is_deleted=False и is_published=true,
    отсортированные по priority
    """
    places = await app_state.content_repo.get_places_by_category(
        category_id=category_id, limit=limit, offset=offset, locale=locale
    )
    return PlacesResponse(places=places)
