import datetime
import os
from src.common.repo.base_repo import AbstractRepo, Item

class Dispatch(Item):
    line_1: dict[str, str | int] | None = None
    line_2: dict[str, str | int] | None = None
    line_3: dict[str, str | int] | None = None
    line_4: dict[str, str | int] | None = None
    wind_speed: float | None = None
    wind_direction: str | None = None
    winds_instructor: str | None = None
    timestamp: str = datetime.datetime.now().strftime(r'%Y-%m-%d %H:%M:%S')

class DispatchRepo(AbstractRepo[Dispatch]):
    TABLE_NAME = os.environ.get('DISPATCH_TABLE', '') # TODO deal with unset env variable
    ITEM_TYPE = Dispatch