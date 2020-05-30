class NotEnoughMoney(Exception):
    pass


class RpcError(Exception):

    def __init__(self, info):
        self.info = info
