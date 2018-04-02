"""
Main views module containing home page and login/logout endpoints.
"""

from flask import Blueprint, render_template, redirect, url_for, flash, request
from flask_login import current_user, login_user, logout_user

from mdb.models import User, Article
from mdb.forms import LoginForm


core = Blueprint('core', __name__)


@core.route('/index')
@core.route('/')
def index():
    """Main view displaying all articles, ordered by creation time.
    If search query is specified, articles and users matching the query
    are displayed instead.
    """
    query = request.args.get('query')
    if query:
        query = '%%%s%%' % query
        articles = Article.query.filter(
            Article.title.like(query) | Article.content.like(query)).order_by(
            Article.timestamp.desc()).all()
        users = User.query.filter(
            User.username.like(query) | User.email.like(query)).order_by(
            User.username.desc()).all()
        return render_template(
            'core/search.html', articles=articles, users=users)
    articles = Article.query.order_by(Article.timestamp.desc()).all()
    return render_template('core/index.html', articles=articles)


@core.route('/login', methods=['GET', 'POST'])
def login():
    """Login endpoint, using the login form from forms module.
    Validates username and password until both are correct,
    redirects to homepage upon successful login.
    """
    if current_user.is_authenticated:
        return redirect(url_for('core.index'))

    form = LoginForm()
    if form.validate_on_submit():
        user = User.query.filter_by(username=form.username.data).first()
        if user is None or not user.check_password(form.password.data):
            flash("Invalid username or password")
            return redirect(url_for('core.login'))
        login_user(user, remember=form.remember.data)
        return redirect(url_for('core.index'))
    return render_template('core/login.html', form=form)


@core.route('/logout', methods=['POST'])
def logout():
    """Logout endpoint, logs out current user."""
    logout_user()
    return redirect(url_for('core.index'))
