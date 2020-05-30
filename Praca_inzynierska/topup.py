#!/usr/bin/env python

# Utility for local testing
# Usage: python topup.py <currency> <address> <amount>

import os
import sys
from decimal import Decimal as D

from dotenv import load_dotenv

from lib import RpcProxy, Bitcoin, Ethereum
from lib.exc import RpcError

load_dotenv()

BTC_URL = os.getenv('BTC_URL')
ETH_URL = os.getenv('ETH_URL')
ETH_ROOT_PRIV = os.getenv('ETH_ROOT_PRIV')
ETH_ROOT_ADDR = os.getenv('ETH_ROOT_ADDR')

if len(sys.argv) != 4:
    print('Usage: python topup.py <currency> <address> <amount>')
    sys.exit(1)

_, currency, address, amount = sys.argv

if currency == 'btc':
    proxy = RpcProxy(BTC_URL)
    btc = Bitcoin(proxy, 'btctest')
    try:
        tx_id = btc.proxy.make_request('sendtoaddress', address, D(amount))
        btc.proxy.make_request('generate', 1)
        print(f'Done! {tx_id}')
    except RpcError as e:
        print(e)
        print('Insufficient funds? Try using mineblocks.py to generate some.')
        sys.exit(1)

elif currency == 'eth':
    proxy = RpcProxy(ETH_URL)
    eth = Ethereum(proxy)
    tx_ids = eth.send_money(ETH_ROOT_PRIV, {address: D(amount)})
    print(f'Done! {tx_ids[0]}')

else:
    print(f'Currency {currency} not supported')
    sys.exit(1)
