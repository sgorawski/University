import requests

from .utils import d2

from settings import COINLAYER_API_URL, COINLAYER_API_KEY


def get():
    params = {'access_key': COINLAYER_API_KEY, 'symbols': 'BTC,ETH'}
    resp = requests.get(COINLAYER_API_URL, params=params)
    resp.raise_for_status()
    rates = resp.json()['rates']
    return {ccy.lower(): d2(value_usd) for ccy, value_usd in rates.items()}
