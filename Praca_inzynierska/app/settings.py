import os

from dotenv import load_dotenv

load_dotenv()

SECRET_KEY = os.getenv('SECRET_KEY')
SQLALCHEMY_DATABASE_URI = os.getenv('DATABASE_URL')
SQLALCHEMY_TRACK_MODIFICATIONS = False

BTC_URL = os.getenv('BTC_URL')
ETH_URL = os.getenv('ETH_URL')

COINLAYER_API_URL = os.getenv('COINLAYER_API_URL', 'http://api.coinlayer.com/api/live')
COINLAYER_API_KEY = os.getenv('COINLAYER_API_KEY')
