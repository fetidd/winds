import logging
from common.utils import status, get_clients
from common.repo.connection_repo import ConnectionRepo

logging.getLogger().setLevel('INFO')

def handler(event, context):
    logging.info(f'$disconnect: event = {event}')
    logging.info(f'$disconnect: context = {context}')

    api, db = get_clients('apigatewaymanagementapi', 'dynamodb')
    connection_repo = ConnectionRepo(client=db)

    dead_connection = connection_repo.get_connection(event)
    logging.info(f'$disconnect: connection_id = {dead_connection}')

    db_delete_result = connection_repo.delete_item(dead_connection.id)
    logging.info(f'$disconnect: db_delete_result = {db_delete_result}')

    other_connections = connection_repo.scan()
    logging.info(f'$disconnect: other_connections = {other_connections}')

    if dead_connection.client_id != '': # if the connected client hasn't done anything to set their client_id, don't bother telling anyone they left
        for other_connection in other_connections:
            api.post_to_connection(ConnectionId=other_connection.id, Data=f'{dead_connection.client_id} disconnected')

    return status()
