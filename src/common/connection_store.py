import datetime
from pydantic import BaseModel

from common.models import Request

class Connection(BaseModel):
    client_id: str
    client_type: str
    joined_timestamp: datetime.datetime

class ConnectionStore:
    _STORE: dict[str, Connection]

    def __init__(self):
        self._STORE = {}

    def add_connection(self, request: Request) -> Connection:
        conn = Connection(
            client_id=request.client_id,
            client_type=request.client_type,
            joined_timestamp=datetime.datetime.now()
        )
        self._STORE[conn.client_id] = conn
        return conn
    
    def get_connection(self, connection_id: str) -> Connection:
        return self._STORE[connection_id]
    
    def drop_connection(self, connection: Connection | str):
        if isinstance(connection, Connection):
            connection_id = connection.client_id
        del self._STORE[connection_id]
        


