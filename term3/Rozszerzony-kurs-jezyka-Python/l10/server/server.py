from xmlrpc.server import SimpleXMLRPCServer

from model import Database


def run_server():
    with SimpleXMLRPCServer(("localhost", 9000), allow_none=True) as server:
        server.register_instance(Database("contacts.db"))
        print("Serving XML-RPC on localhost port 9000")
        try:
            server.serve_forever()
        except KeyboardInterrupt:
            print("Server interrupted, exiting")


if __name__ == "__main__":
    run_server()
