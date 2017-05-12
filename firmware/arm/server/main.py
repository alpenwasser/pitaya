import math
import time
import asyncio
import json

from autobahn.asyncio.websocket import WebSocketServerProtocol, WebSocketServerFactory

class ServerProtocol(WebSocketServerProtocol):

    def __init__(self):
        super(ServerProtocol, self).__init__()
        self.task = None
        self.sine = []
        self.frameSize = 2000

    def onConnect(self, request):
        print("Client connecting: {0}".format(request.peer))

    def onOpen(self):
        print('Generating new stream.')
        self.task = loop.create_task(self.stream())

    def onClose(self, wasClean, code, reason):
        self.task.cancel()
        print("WebSocket connection closed: {0}".format(reason))

    def onMessage(self, payload, isBinary):
        if isBinary:
            print("Binary message received: {} bytes".format(len(payload)))
        else:
            payload = payload.decode('utf8')
            print("Text message received: {}".format(payload))
            cmd = json.loads(payload)
            if 'frameSize' in cmd:
                self.frameSize = int(cmd['frameSize'])

    @asyncio.coroutine
    def stream(self):
        t = 0
        b = bytes()
        while True:
            for i in range(0, self.frameSize):
                b += int(16384 + 7000 * math.sin((t+i/self.frameSize)*40*math.pi)).to_bytes(2, byteorder='little')
            self.sendMessage(b, True)
            b = bytes()
            t += 1
            yield from asyncio.sleep(0.035)

if __name__ == '__main__':
    
    factory = WebSocketServerFactory(u"ws://127.0.0.1:9000")
    factory.protocol = ServerProtocol
    loop = asyncio.get_event_loop()
    coro = loop.create_server(factory, '0.0.0.0', 9000)
    server = loop.run_until_complete(coro)

    try:
        loop.run_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.close()
        loop.close()