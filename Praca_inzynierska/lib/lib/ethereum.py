from decimal import Decimal as D

from pywallet.utils.ethereum import HDPrivateKey
from pywallet.wallet import create_wallet
from eth_account.account import Account

from .exc import NotEnoughMoney

GAS_LIMIT = 21_000


def int_of_hex(num_hex):
    return int(num_hex, base=16)


def eth_of_wei(amount_wei):
    return amount_wei / D('1e18')


def wei_of_eth(amount_eth):
    return int(amount_eth * D('1e18'))


class Ethereum:

    def __init__(self, proxy, network='eth'):
        self.proxy = proxy
        self.network = network

    def create_wallet(self, seed=None):
        wallet = self.create_hd_wallet(seed)
        priv = HDPrivateKey.from_b58check(wallet['xprivate_key'])._key.to_hex()
        addr = self.get_address_of_private_key(priv)
        return addr, priv, wallet['seed']

    def create_hd_wallet(self, seed=None):
        return create_wallet(self.network, seed)

    def get_balance(self, address, block='latest'):
        balance_wei_hex = self.proxy.make_request('eth_getBalance', address, block)
        return eth_of_wei(int_of_hex(balance_wei_hex))

    def send_money(self, from_priv, amount_by_address):
        from_addr = self.get_address_of_private_key(from_priv)
        gas_price_wei = self.get_gas_price_wei()

        total_gas_cost_eth = GAS_LIMIT * eth_of_wei(gas_price_wei) * len(amount_by_address)
        total_required_eth = sum(amount_by_address.values()) + total_gas_cost_eth
        if self.get_balance(from_addr) < total_required_eth:
            raise NotEnoughMoney(from_addr)

        nonce = self.get_nonce(from_addr)

        tx_ids = []
        for i, (to_addr, amount) in enumerate(amount_by_address.items()):
            tx = {
                'from': from_addr,
                'to': to_addr,
                'value': wei_of_eth(amount),
                'nonce': hex(nonce + i),
                'gasPrice': hex(gas_price_wei),
                'gas': hex(GAS_LIMIT),
            }
            signed_tx = Account.sign_transaction(tx, from_priv).rawTransaction.hex()
            tx_id = self.proxy.make_request('eth_sendRawTransaction', signed_tx)
            tx_ids.append(tx_id)

        return tx_ids

    def get_gas_price_wei(self):
        gas_price_wei_hex = self.proxy.make_request('eth_gasPrice')
        return int_of_hex(gas_price_wei_hex)

    def get_nonce(self, addr):
        nonce_hex = self.proxy.make_request('eth_getTransactionCount', addr, 'pending')
        return int_of_hex(nonce_hex)

    def get_address_of_private_key(self, priv):
        return Account.from_key(priv).address
