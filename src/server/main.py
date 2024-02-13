from pydantic import BaseModel
from websockets import WebSocketServerProtocol, serve
import asyncio
import sys
import os
import logging


sys.path.append(os.environ.get('PROJECT_DIR', '') + '/src') # TODO there has to be a better way to do this, it's shit
from common.repo.dispatch_repo import DispatchRepo, Dispatch
from common.models import Request
from common.connection_store import ConnectionStore, Connection

logging.getLogger().setLevel('INFO')

def on_connect(request, connection_repo: ConnectionStore) -> Connection:
    new_connection = connection_repo.add_connection(request)
    return new_connection

async def handler(websocket: WebSocketServerProtocol):
    raw_request = await websocket.recv()
    request = Request.model_validate_json(raw_request)

    connection_store = ConnectionStore()
    connection = on_connect(request, connection_store)

    print(connection_store._STORE)

    dispatch_repo = DispatchRepo()
    dispatch = Dispatch.model_validate(request.model_dump())


    await websocket.send(f'received weights')


async def main():
    async with serve(handler, "localhost", 8765):
        try:
            await asyncio.Future()  # run forever
        except asyncio.exceptions.CancelledError:
            print('\nExiting...')

if __name__ == "__main__":
    asyncio.run(main())


