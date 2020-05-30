from pywallet.wallet import create_wallet
from pywallet.utils.keys import PrivateKey
from pywallet.network import BitcoinMainNet, BitcoinTestNet

from .exc import NotEnoughMoney
from .utils import d6

PYWALLET_NETWORK = {
    'btc': BitcoinMainNet,
    'btctest': BitcoinTestNet,
}

DEFAULT_FEE = d6('0.001')


class Bitcoin:

    def __init__(self, proxy, network='btc'):
        self.proxy = proxy
        self.network = network

    def create_wallet(self, seed=None):
        wallet = self.create_hd_wallet(seed)
        return wallet['address'], wallet['wif'].decode(), wallet['seed']

    def create_hd_wallet(self, seed=None):
        wallet = create_wallet(self.network, seed)
        self.proxy.make_request('importaddress', wallet['address'])
        return wallet

    def get_balance(self, address):
        unspents = self.get_unspents_for_address(address)
        return sum(d6(u['amount']) for u in unspents)

    def get_unspents_for_address(
            self, address, min_confirmations=1, max_confirmations=9_999_999
    ):
        return self.proxy.make_request(
            'listunspent', min_confirmations, max_confirmations, [address]
        )

    def send_money(self, from_priv, amount_by_address):
        fee = self.estimate_fee()
        from_addr = self.get_address_of_private_key(from_priv)
        unspents = self.get_unspents_for_address(from_addr)
        total_required_btc = sum(amount_by_address.values()) + fee

        gathered_btc = 0
        unspents_to_use = []

        ui = iter(unspents)
        try:
            while gathered_btc < total_required_btc:
                unspent = next(ui)
                gathered_btc += d6(unspent['amount'])
                unspents_to_use.append(unspent)
        except StopIteration:
            raise NotEnoughMoney(from_addr)

        change_btc = gathered_btc - total_required_btc
        if change_btc > 0:
            if from_addr in amount_by_address:
                amount_by_address[from_addr] += change_btc
            else:
                amount_by_address[from_addr] = change_btc

        inputs = [
            {'txid': u['txid'], 'vout': u['vout']}
            for u in unspents_to_use
        ]

        raw_tx = self.proxy.make_request(
            'createrawtransaction', inputs, amount_by_address
        )
        signed_tx = self.proxy.make_request(
            'signrawtransactionwithkey', raw_tx, [from_priv]
        )
        tx_id = self.proxy.make_request('sendrawtransaction', signed_tx['hex'])
        return [tx_id] * len(amount_by_address)

    def estimate_fee(self, num_confirmations=1):
        resp = self.proxy.make_request('estimatesmartfee', num_confirmations)
        if 'errors' in resp:
            return DEFAULT_FEE
        return d6(resp)

    def get_address_of_private_key(self, priv):
        net = PYWALLET_NETWORK[self.network]
        return PrivateKey.from_wif(priv, net).get_public_key().to_address()
