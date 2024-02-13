from websockets import WebSocketClientProtocol, connect
from websockets.exceptions import ConnectionClosedOK
import asyncio
from uuid import uuid4
import sys
import os


sys.path.append(os.environ.get('PROJECT_DIR', '') + '/src')  # TODO there has to be a better way to do this, it's shit
from common.models import Request
from common.repo.dispatch_repo import Dispatch

async def main():
    uri = "ws://localhost:8765"
    async with connect(uri) as websocket:
        while True:
            if input("press key to send") == 'q':
                return
            await send_weights(websocket=websocket)
            res = await websocket.recv()


async def send_weights(websocket: WebSocketClientProtocol):
    dispatch = Dispatch()
    dispatch.line_1 = {'weight': 118}

    request = Request(
        client_id=uuid4().hex,
        client_type='BigTopLine2',
        action='SendWeights',
        recipient='BigBaseWinds',
        payload=dispatch
    )

    await websocket.send(request.model_dump_json())


# async def connect



if __name__ == "__main__":
    asyncio.run(main())