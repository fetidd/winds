import logging
from common.utils import status, get_clients
from common.repo.connection_repo import Connection, ConnectionRepo

logging.getLogger().setLevel('INFO')

def handler(event, context):
    logging.info(f'$connect: event = {event}')
    logging.info(f'$connect: context = {context}')

    db = get_clients('dynamodb')
    connection_repo = ConnectionRepo(client=db)

    new_connection = Connection(id=event['requestContext']['connectionId'], client_id='')
    logging.info(f'$connect: connection_id = {new_connection.id}')

    db_put_result = connection_repo.put_item(new_connection)
    logging.info(f'$connect: db_put_result = {db_put_result}')

    return status()
