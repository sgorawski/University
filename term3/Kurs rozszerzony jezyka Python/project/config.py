import os

ROOT = os.path.abspath(os.path.dirname(__file__))

SECRET_KEY = (os.environ.get('SECRET_KEY')
              or 'a52292525d73e98aaa4b191216f010dc')
SQLALCHEMY_DATABASE_URI = (os.environ.get('DATABASE_URL')
                           or 'sqlite:///' + os.path.join(ROOT, 'mdb.db'))
SQLALCHEMY_TRACK_MODIFICATIONS = False
