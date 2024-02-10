import pytest

from src.common.decorators import lambda_handler

@pytest.fixture
def decorated_function():
    @lambda_handler
    def func(api, db, payload):
        print(f'api={api}')
        print(f'db={db}')
        print(f'payload={payload}')
    return func

def test_handler(decorated_function): # TODO actually test something!
    event = {
        'body': {
            'action': 'send_weights', 
            'weights': [], 
            'sender_id': 'test_sender', 
            'recipient_id': 'test_recipient'
        },
        'requestContext': {
            'connectionId': 'test_conn_id'
        }
    }
    context = {'some': 'context'}
    decorated_function(event, context)
    