import os

from dotenv import load_dotenv

load_dotenv()

BTC_URL = os.getenv('BTC_URL')
ETH_URL = os.getenv('ETH_URL')
ETH_ROOT_PRIV = os.getenv('ETH_ROOT_PRIV')
ETH_ROOT_ADDR = os.getenv('ETH_ROOT_ADDR')
