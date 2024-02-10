import logging
from common.utils import status, get_clients
from common.repo.connection_repo import ConnectionRepo

logging.getLogger().setLevel('INFO')

def handler(event, context):
    logging.info(f'$default: event = {event}')
    logging.info(f'$default: context = {context}')

    api, db = get_clients('apigatewaymanagementapi', 'dynamodb')

    connection = ConnectionRepo(db).get_connection(event)
    body = event['body']

    logging.error(f'$default: invalid body {body}')

    api.post_to_connection(ConnectionId=connection.id, Data=f'error: {body}') # TODO this should be a nice useful json object

    return status() # TODO should this response be 200? Or 4xx because the request was bad?