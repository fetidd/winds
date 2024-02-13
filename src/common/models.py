from typing import Any
from pydantic import BaseModel

class WebsocketPayload(BaseModel):
    sender_id: str
    recipient_id: str
    timestamp: int
    connection_id: str

class SendWeightsPayload(WebsocketPayload):
    weights: dict[int, int]

class Request(BaseModel):
    client_id: str
    client_type: str
    action: str
    recipient: str
    payload: Any
