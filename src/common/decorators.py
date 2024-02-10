import functools

from common.utils import create_payload, get_clients

def lambda_handler(handler_func):

    def handler(event, context):
        print(f'wrapper event = {event}')
        print(f'wrapper context = {context}')
        api_client, db_client = get_clients('apigatewaymanagementapi', 'dynamodb')
        payload = create_payload(event)
        return handler_func(payload, api_client, db_client)

    return handler
