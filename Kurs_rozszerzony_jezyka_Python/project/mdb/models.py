"""
Module with models,
bound using the SQLAlchemy ORM to the Sqlite3 database.
"""

from datetime import datetime
from hashlib import md5

from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash

from mdb import db, login


@login.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


class User(UserMixin, db.Model):
    """Class contains user-specific fields,
    including hashed password.
    """
    __table_args__ = {'extend_existing': True}
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), index=True, unique=True)
    email = db.Column(db.String(128), index=True, unique=True)
    password_hash = db.Column(db.String(128))
    is_admin = db.Column(db.Boolean, default=False)
    articles = db.relationship('Article', backref='author', lazy='dynamic')

    def __init__(self, username, email, password):
        self.username = username
        self.email = email
        self.password_hash = generate_password_hash(password)

    def __repr__(self):
        return "<User %s>" % self.username

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def get_image_url(self, size=80):
        """Method used to get user profile images,
        utilizing the Gravatar API. If no image for an email is found,
        a retro-style pixel art is returned.
        """
        email_hash = md5(self.email.lower().encode('utf-8')).hexdigest()
        return (
            "https://www.gravatar.com/avatar/%s?d=retro&s=%s"
            % (email_hash, size),
        )


class Article(db.Model):
    """Class contains articles' title and content,
    with a foreign key referring to the author.
    """
    __table_args__ = {'extend_existing': True}
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(256), index=True, unique=True)
    content = db.Column(db.Text)
    timestamp = db.Column(db.DateTime, index=True, default=datetime.utcnow())
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))

    def __init__(self, title, content, author):
        self.title = title
        self.content = content
        self.author = author

    def __repr__(self):
        return "<Article %s>" % self.title
