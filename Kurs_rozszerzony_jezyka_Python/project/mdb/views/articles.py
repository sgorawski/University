"""
Module containing article-specific views,
mostly for performing CRUD operations.
"""

from flask import Blueprint, render_template, redirect, url_for, flash
from flask_login import current_user, login_required

from mdb import db
from mdb.models import Article
from mdb.forms import ArticleCreateForm, ArticleEditForm
from mdb.parser import parse_md


articles = Blueprint('articles', __name__, url_prefix='/articles')


@articles.route('/<title>')
def index(title):
    """Article reading endpoint,
    displaying article with content formatted to HTML.
    """
    article = Article.query.filter_by(title=title).first_or_404()
    text = parse_md(article.content)
    can_modify = (
        current_user == article.author
        or (not current_user.is_anonymous and current_user.is_admin)
    )
    return render_template(
        'articles/index.html',
        article=article,
        text=text,
        can_modify=can_modify,
    )


@articles.route('/create', methods=['GET', 'POST'])
@login_required
def create():
    """Article creation endpoint;
    available to logged in users only.
    """
    form = ArticleCreateForm()
    if form.validate_on_submit():
        article = Article(
            title=form.title.data,
            content=form.content.data,
            author=current_user,
        )
        db.session.add(article)
        db.session.commit()
        return redirect(url_for('articles.index', title=article.title))
    return render_template('articles/edit.html', form=form)


@articles.route('/edit/<title>', methods=['GET', 'POST'])
@login_required
def edit(title):
    """Article edition endpoint, similar to the creation one;
    available only to admin or author.
    """
    article = Article.query.filter_by(title=title).first_or_404()
    if current_user != article.author or not current_user.is_admin:
        return redirect(url_for('core.index'))

    form = ArticleEditForm(article=article)
    if form.validate_on_submit():
        article.title = form.title.data
        article.content = form.content.data
        db.session.commit()
        return redirect(url_for('articles.index', title=article.title))
    return render_template('articles/edit.html', form=form)


@articles.route('/delete/<title>', methods=['POST'])
@login_required
def delete(title):
    """Article deletion ednpoins,
    available only to admin or author.
    """
    article = Article.query.filter_by(title=title).first_or_404()
    if current_user != article.author or not current_user.is_admin:
        return redirect(url_for('core.index'))

    db.session.delete(article)
    db.session.commit()
    flash("Article %s deleted" % title)
    return redirect(url_for('core.index'))
