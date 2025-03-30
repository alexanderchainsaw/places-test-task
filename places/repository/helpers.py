from pydantic import BaseModel


class ModelSQL(BaseModel):
    placeholders: str
    field_names: str
    values: list


def build_model_sql(model: BaseModel, skip_none: bool = False) -> ModelSQL:
    placeholders = []
    field_names = []
    values = []
    i = 1
    for idx, name in enumerate(model.__fields__, 1):
        if skip_none and getattr(model, name) is None:
            continue
        placeholders.append(f"${i}")
        field_names.append(name)
        values.append(getattr(model, name))
        i += 1

    return ModelSQL(
        placeholders=",".join(placeholders),
        field_names=",".join(field_names),
        values=values,
    )


def build_model_cls_sql(model: BaseModel) -> ModelSQL:
    placeholders = []
    field_names = []
    values = []
    for idx, name in enumerate(model.__fields__, 1):
        placeholders.append(f"${idx}")
        field_names.append(name)

    return ModelSQL(
        placeholders=",".join(placeholders),
        field_names=",".join(field_names),
        values=values,
    )
