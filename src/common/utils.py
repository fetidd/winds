from datetime import datetime
from typing import Any
import boto3
import os
import json

from common.models import SendWeightsPayload, WebsocketPayload

API_GATEWAY_ENDPOINT = os.environ.get('API_GATEWAY_ENDPOINT')

def get_client(service: str): # TODO unittest
    environment = os.environ.get("ENVIRONMENT", 'production')
    endpoints = { # TODO this mapping should live somewhere more generic
        'development': {
            'dynamodb': 'http://localhost:8000'
        },
        'production': {
        }
    }
    kwargs = {}
    endpoint = endpoints[environment].get(service)
    if endpoint is not None:
        kwargs['endpoint_url'] = endpoint
    client = boto3.client(service, **kwargs)
    return client

def get_clients(*services: str) -> tuple[Any, ...] | Any: # TODO unittest
    if len(services) < 1:
        raise Exception("No services specified")
    clients = []
    for service in services:
        clients.append(get_client(service))
    if len(clients) > 1:
        clients = tuple(clients)
    else:
        clients = clients[0]
    return clients

def status(code: int = 200) -> dict[str, int]: # TODO unittest
    return {'statusCode': code}

def create_payload(event: dict[str, Any]) -> WebsocketPayload: # TODO unittest
    body = json.loads(event['body'])
    action = body.pop('action')
    kwargs: dict[str, Any] = {
        'timestamp': int(datetime.now().timestamp()),
        'connection_id': event['requestContext']['connectionId'],
        **body
    }
    payload = {
        '$connect': WebsocketPayload,
        'send_weights': SendWeightsPayload
    }[action](**kwargs)
    return payload