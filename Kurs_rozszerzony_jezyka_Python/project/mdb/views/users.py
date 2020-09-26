"""
Module containing user-specific views,
including registration.
"""

from flask import Blueprint, render_template, redirect, url_for, flash
from flask_login import current_user, login_required, login_user

from mdb import db
from mdb.models import User, Article
from mdb.forms import UserRegisterForm, UserUpdateForm


users = Blueprint('users', __name__, url_prefix='/users')


@users.route('/<username>')
def index(username):
    """User profile view, including profile picture,
    and a list of the user's articles."""
    user = User.query.filter_by(username=username).first_or_404()
    articles = (
        Article.query
        .filter_by(author=user)
        .order_by(Article.timestamp.desc())
        .all()
    )
    can_modify = current_user == user
    return render_template(
        'users/index.html',
        user=user,
        articles=articles,
        can_modify=can_modify,
    )


@users.route('/register', methods=['GET', 'POST'])
def register():
    """Registration view, creating new user upon successful validation
    and logging them in.
    """
    if current_user.is_authenticated:
        return redirect(url_for('core.index'))

    form = UserRegisterForm()
    if form.validate_on_submit():
        user = User(
            username=form.username.data,
            email=form.email.data,
            password=form.password.data,
        )
        db.session.add(user)
        db.session.commit()
        flash("Registration successful")
        login_user(user)
        return redirect(url_for('core.index'))
    return render_template('users/register.html', form=form)


@users.route('/update/<username>', methods=['GET', 'POST'])
@login_required
def update(username):
    """Profile edition view, with option to change username or email;
    available only to the profile owner.
    """
    user = User.query.filter_by(username=username).first_or_404()
    if current_user != user:
        return redirect(url_for('core.index'))

    form = UserUpdateForm(user=user)
    if form.validate_on_submit():
        user.username = form.username.data
        user.email = form.email.data
        db.session.commit()
        flash("Profile updated")
        return redirect(url_for('users.index', username=user.username))
    return render_template('users/update.html', form=form)


@users.route('/delete/<username>', methods=['POST'])
@login_required
def delete(username):
    """Profile deletion endpoint;
    available to profile owner and admin.
    """
    user = User.query.filter_by(username=username).first_or_404()
    if (
        current_user != user
        or not current_user.is_admin
        or (current_user.is_admin and user.is_admin)
    ):
        return redirect(url_for('core.index'))

    db.session.delete(user)
    db.session.commit()
    flash("%s's account deleted" % username)
    return redirect(url_for('core.index'))
