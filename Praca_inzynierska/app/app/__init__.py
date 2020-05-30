from flask import Flask
from flask_migrate import Migrate
from flask_sqlalchemy import SQLAlchemy

import settings

app = Flask(__name__)

app.config.from_object(settings)

db = SQLAlchemy(app)
migrate = Migrate(app, db)

from .views import wallets  # noqa
from .auth import is_authenticated, get_text  # noqa

app.register_blueprint(wallets)

app.jinja_env.globals.update(
    is_authenticated=is_authenticated,
    get_text=get_text,
)
