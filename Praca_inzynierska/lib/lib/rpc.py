import requests

from .exc import RpcError


class RpcProxy:

    def __init__(self, url, timeout_s=3):
        self.url = url
        self.timeout_s = timeout_s

    def make_request(self, method, *params):
        body = self._get_request_body(method, params)
        resp = requests.post(self.url, json=body, timeout=self.timeout_s)
        data = resp.json()  # RPC always returns JSON, even on error
        assert body['id'] == data['id']
        if resp.status_code != 200:
            raise RpcError(data['error'])
        return data['result']

    def _get_request_body(self, method, params):
        return {
            'jsonrpc': '2.0',
            'method': method,
            'params': list(params),
            'id': id(self),
        }
