from common.utils import status
from common.models import SendWeightsPayload
from common.decorators import lambda_handler
import logging

logging.getLogger().setLevel('INFO')

@lambda_handler
def handler(payload: SendWeightsPayload, api_client, db_client):
    api_client.post_to_connection(ConnectionId=payload.connection_id, Data=f'got {api_client}, {db_client} and {payload}')
    return status()

