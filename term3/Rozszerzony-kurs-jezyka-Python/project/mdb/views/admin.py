"""
Module containing administration panel views,
available only for admins.
"""

from functools import wraps

from flask import Blueprint, render_template, redirect, url_for, flash
from flask_login import current_user, login_required

from mdb.models import User, Article


admin = Blueprint('admin', __name__, url_prefix='/admin')


def admin_only(view):
    """Custom decorator guarding access to given views,
    checking whether current user is admin.
    If not, the user is redirected to the home page.
    """
    @wraps(view)
    @login_required
    def check_for_admin(*args, **kwargs):
        if not current_user.is_admin:
            return redirect(url_for('core.index'))
        return view(*args, **kwargs)
    return check_for_admin


# ENDPOINTS

@admin.route('/')
@admin_only
def index():
    return render_template('admin/index.html')


@admin.route('/users')
@admin_only
def users():
    users_list = User.query.order_by(User.username.desc()).all()
    return render_template('admin/users.html', users=users_list)


@admin.route('/articles')
@admin_only
def articles():
    articles_list = Article.query.order_by(Article.timestamp.desc()).all()
    return render_template('admin/articles.html', articles=articles_list)
