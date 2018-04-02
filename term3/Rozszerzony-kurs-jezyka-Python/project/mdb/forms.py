"""
Module with forms, using the wtf-forms library.
"""

from flask_wtf import FlaskForm
from wtforms.fields import StringField, PasswordField, TextAreaField, \
    BooleanField, SubmitField
from wtforms.validators import DataRequired, Email, EqualTo, ValidationError

from mdb.models import User, Article


class LoginForm(FlaskForm):
    """Form for logging in, requires non-empty username and password."""
    username = StringField('Username', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    remember = BooleanField('Remember me')
    submit = SubmitField('Login')


class UserRegisterForm(FlaskForm):
    """Registration form, requires non-empty fields,
    correct email, non-empty username and password,
    and same text in both password inputs.
    """
    username = StringField('Username', validators=[DataRequired()])
    email = StringField('Email', validators=[DataRequired(), Email()])
    password = PasswordField('Password', validators=[DataRequired()])
    password2 = PasswordField('Repeat password',
                              validators=[DataRequired(), EqualTo('password')])
    submit = SubmitField('Register')

    def validate_username(self, username):
        user = User.query.filter_by(username=username.data).first()
        if user is not None:
            raise ValidationError("This username is already in use.")

    def validate_email(self, email):
        user = User.query.filter_by(email=email.data).first()
        if user is not None:
            raise ValidationError("This email is already in use.")


class UserUpdateForm(FlaskForm):
    """Form working like the registration one, but with fewer fields -
    password can not be changed.
    """
    username = StringField('Username', validators=[DataRequired()])
    email = StringField('Email', validators=[DataRequired(), Email()])
    submit = SubmitField('Save')

    def __init__(self, user):
        super().__init__(obj=user)
        self.__user = user

    def validate_username(self, username):
        user = User.query.filter_by(username=username.data).first()
        if user is not None and user is not self.__user:
            raise ValidationError("This username is already in use.")

    def validate_email(self, email):
        user = User.query.filter_by(email=email.data).first()
        if user is not None and user is not self.__user:
            raise ValidationError("This email is already in use.")


class ArticleCreateForm(FlaskForm):
    """Form used for articles creation,
    requires unique title. Feature: markdown supported in content field.
    """
    title = StringField('Title', validators=[DataRequired()])
    content = TextAreaField('Content')
    submit = SubmitField('Submit')

    def validate_title(self, title):
        article = Article.query.filter_by(title=title.data).first()
        if article is not None:
            raise ValidationError("This title is already in use.")


class ArticleEditForm(FlaskForm):
    """Form identical in function to the creation one,
    save for default text in input fields.
    """
    title = StringField('Title', validators=[DataRequired()])
    content = TextAreaField('Content')
    submit = SubmitField('Submit')

    def __init__(self, article):
        super().__init__(obj=article)
        self.__article = article

    def validate_title(self, title):
        article = Article.query.filter_by(title=title.data).first()
        if article is not None and article is not self.__article:
            raise ValidationError("This title is already in use.")
