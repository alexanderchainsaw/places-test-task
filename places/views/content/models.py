from pydantic import BaseModel


class Place(BaseModel):
    id: int
    type: int
    priority: int
    name: str
    preview_photo_url: str
    category_id: int
    category_name: str
    content: str
    locale: str


class PlacesResponse(BaseModel):
    places: list[Place]
