from dataclasses import dataclass
import os
from common.repo.abstract_repo import AbstractRepo, Item

@dataclass
class Dispatch(Item):
    dispatch_id: str

@dataclass
class DispatchRepo(AbstractRepo[Dispatch]):
    TABLE_NAME = os.environ.get('DISPATCH_TABLE', '') # TODO deal with unset env variable
    ITEM_TYPE = Dispatch