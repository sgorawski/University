from decimal import Decimal as D

import pytest

from lib import Ethereum, RpcProxy
from . import ETH_URL, ETH_ROOT_PRIV


@pytest.fixture
def ethereum():
    proxy = RpcProxy(ETH_URL)
    return Ethereum(proxy)


def test_scenario(ethereum):
    addr, priv, _ = ethereum.create_wallet()
    assert ethereum.get_balance(addr) == D(0)

    ethereum.send_money(ETH_ROOT_PRIV, {addr: D(10)})
    assert ethereum.get_balance(addr) == D(10)

    addr2, *_ = ethereum.create_wallet()
    addr3, *_ = ethereum.create_wallet()

    ethereum.send_money(priv, {addr2: D(2), addr3: D(3)})
    assert ethereum.get_balance(addr2) == D(2)
    assert ethereum.get_balance(addr3) == D(3)


def test_mnemonic_phrase(ethereum):
    addr, priv, seed = ethereum.create_wallet()
    assert ethereum.create_wallet(seed) == (addr, priv, seed)
