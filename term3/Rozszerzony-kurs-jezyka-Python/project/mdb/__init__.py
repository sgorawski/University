"""
Main application module
To run it please use the CLI tool, like this:
$ export FLASK_APP=mdb
$ flask run
"""

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_login import LoginManager


app = Flask(__name__)
app.config.from_object('config')

db = SQLAlchemy(app)
migrate = Migrate(app, db)

login = LoginManager(app)
login.login_view = 'core.login'


from mdb.views import core, admin, users, articles


app.register_blueprint(core)
app.register_blueprint(admin)
app.register_blueprint(users)
app.register_blueprint(articles)
