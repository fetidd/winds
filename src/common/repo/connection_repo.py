from dataclasses import dataclass
import os
from common.repo.abstract_repo import AbstractRepo, Item

@dataclass
class Connection(Item):
    client_id: str

class ConnectionRepo(AbstractRepo[Connection]):
    TABLE_NAME = os.environ.get('CONNECTIONS_TABLE', '') # TODO what should happen if this is not set?
    ITEM_TYPE = Connection

    def get_connection(self, event) -> Connection:
        return super().get_item(event['requestContext']['connectionId'])