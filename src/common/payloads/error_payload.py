import json

class ErrorPayload:
    def __init__(self, error_message: str, error_code: int = 99999):
        self.error_message = error_message
        self.error_code = error_code

    def __repr__(self) -> str:
        return json.dumps({
            'error_message': self.error_message,
            'error_code': self.error_code
        })