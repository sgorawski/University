from lib import RpcProxy, Bitcoin, Ethereum

BTC_URL = 'http://test:test@localhost:18443'
ETH_URL = 'http://localhost:8545'

blocks = {
    'btc': Bitcoin(RpcProxy(BTC_URL), network='btctest'),
    'eth': Ethereum(RpcProxy(ETH_URL)),
}
