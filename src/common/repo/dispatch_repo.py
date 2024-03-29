import datetime
import os
from common.repo.base_repo import BaseRepo, Item

class Dispatch(Item):
    line_1: dict[str, str | int] | None = None
    line_2: dict[str, str | int] | None = None
    line_3: dict[str, str | int] | None = None
    line_4: dict[str, str | int] | None = None
    wind_speed: float | None = None
    wind_direction: str | None = None
    winds_instructor: str | None = None
    timestamp: str = datetime.datetime.now().strftime(r'%Y-%m-%d %H:%M:%S')

class DispatchRepo(BaseRepo):
    ITEM_TYPE = Dispatch
    TABLE_NAME = os.environ.get('DISPATCH_TABLE', 'Dispatches') # TODO deal with unset env variable