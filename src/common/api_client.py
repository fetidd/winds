from common.repo.connection_repo import Connection
from common.utils import get_client
from common.payloads.error_payload import ErrorPayload


class ApiClient:
    def __init__(self, client=get_client('apigatewaymanagementapi')):
        self._client = client

    def ping(self, connection: Connection, message: str="PING"):
        self._client.post_to_connection(ConnectionId=connection.id, Data=message)

    def error(self, connection: Connection, error_payload: ErrorPayload):
        self._client.post_to_connection(ConnectionId=connection.id, Data=error_payload)