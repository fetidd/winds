from dataclasses import dataclass

@dataclass
class WebsocketPayload():
    sender_id: str
    recipient_id: str
    timestamp: int
    connection_id: str


@dataclass
class SendWeightsPayload(WebsocketPayload):
    weights: dict[int, int]


