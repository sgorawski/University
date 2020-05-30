from decimal import Decimal as D

import pytest

from lib import Bitcoin, RpcProxy
from . import BTC_URL


@pytest.fixture(scope='session', autouse=True)
def test_coins():
    RpcProxy(BTC_URL).make_request('generate', 100)


@pytest.fixture
def bitcoin():
    proxy = RpcProxy(BTC_URL)
    return Bitcoin(proxy, 'btctest')


def test_scenario(bitcoin):
    from_addr, from_priv, _ = bitcoin.create_wallet()
    bitcoin.proxy.make_request('sendtoaddress', from_addr, D(10))
    bitcoin.proxy.make_request('generate', 1)

    assert bitcoin.get_balance(from_addr) == D(10)

    addr2, *_ = bitcoin.create_wallet()
    addr3, *_ = bitcoin.create_wallet()

    bitcoin.send_money(from_priv, {addr2: D(2), addr3: D(3)})
    bitcoin.proxy.make_request('generate', 1)

    assert bitcoin.get_balance(addr2) == D(2)
    assert bitcoin.get_balance(addr3) == D(3)
    assert bitcoin.get_balance(from_addr) == D(5) - D('0.001')


def test_mnemonic_phrase(bitcoin):
    addr, priv, seed = bitcoin.create_wallet()
    assert bitcoin.create_wallet(seed) == (addr, priv, seed)
