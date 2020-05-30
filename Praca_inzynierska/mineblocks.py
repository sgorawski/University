#!/usr/bin/env python

# Another testing utility

import os
import sys

from dotenv import load_dotenv

from lib import RpcProxy

load_dotenv()

BTC_URL = os.getenv('BTC_URL')

if len(sys.argv) != 2:
    print('Usage: python mineblocks.py <number>')
    sys.exit(1)

proxy = RpcProxy(BTC_URL)
blocks = proxy.make_request('generate', int(sys.argv[1]))
print(blocks)
