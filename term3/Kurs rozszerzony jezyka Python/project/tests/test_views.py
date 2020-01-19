from datetime import datetime

from flask_login import login_user

from tests import MdbTestCase
from mdb import db
from mdb.models import User, Article


class LayoutTests(MdbTestCase):
    """docstring"""

    def test_user_anonymous(self):
        response = self.app.get('/')
        self.assertContains("Register", response)
        self.assertContains("Login", response)

    def test_user_logged_in(self):
        self.login_user(self.user)
        response = self.app.get('/')
        self.assertContains("test-user", response)
        self.assertContains("Logout", response)

    def test_admin_logged_in(self):
        self.login_user(self.admin)
        response = self.app.get('/')
        self.assertContains("Admin", response)


class IndexViewTests(MdbTestCase):
    """docstring"""

    def test_no_articles(self):
        response = self.app.get('/')
        self.assertContains("no articles", response)

    def test_with_articles(self):
        title = "test-title"
        article = Article(title, "test-content", self.user)
        db.session.add(article)
        db.session.commit()
        response = self.app.get('/')
        self.assertContains(title, response)


class LoginViewTests(MdbTestCase):
    """docstring"""

    def test_valid_credentials(self):
        response = self.login("test-user", "testpwd")
        self.assertContains("test-user", response)

    def test_empty_username_or_password(self):
        response = self.login("", "testpwd")
        self.assertContains("This field is required", response)
        response = self.login("test-user", "")
        self.assertContains("This field is required", response)
        response = self.login("", "")
        self.assertContains("This field is required", response)

    def test_invalid_username_or_password(self):
        response = self.login("test-user", "wrong")
        self.assertContains("Invalid username or password", response)
        response = self.login("wrong", "testpwd")
        self.assertContains("Invalid username or password", response)
        response = self.login("wrong", "wrong")
        self.assertContains("Invalid username or password", response)


class UsersViewTests(MdbTestCase):
    """docstring"""

    def test_user_anonymous(self):
        response = self.app.get('/users/test-user')
        self.assertNotContains("Edit profile", response)
        self.assertNotContains("Delete profile", response)

    def test_matching_user(self):
        self.login_user(self.user)
        response = self.app.get('/users/test-user')
        self.assertContains("Edit profile", response)
        self.assertContains("Delete profile", response)

    def test_not_matching_user(self):
        user2 = User("test-user-2", "test-user-2@test.com", "testpwd")
        db.session.add(user2)
        db.session.commit()
        self.login_user(user2)
        response = self.app.get('/users/test-user')
        self.assertNotContains("Edit profile", response)
        self.assertNotContains("Delete profile", response)

    def test_not_matching_admin(self):
        self.login_user(self.admin)
        response = self.app.get('/users/test-user')
        self.assertNotContains("Edit profile", response)
        self.assertNotContains("Delete profile", response)

    def test_no_articles(self):
        response = self.app.get('/users/test-user')
        self.assertContains("has not created anything", response)

    def test_with_articles(self):
        title = "test-title"
        article = Article(title, "test-content", self.user)
        db.session.add(article)
        db.session.commit()
        response = self.app.get('/users/test-user')
        self.assertContains(title, response)


class ArticlesViewTests(MdbTestCase):
    """docstring"""

    def setUp(self):
        super().setUp()
        self.title = "test-title"
        article = Article(self.title, "test-content", self.user)
        db.session.add(article)
        db.session.commit()

    def test_basic_info(self):
        response = self.app.get('/articles/%s' % self.title)
        self.assertContains(self.title, response)
        self.assertContains(self.user.username, response)
        self.assertContains("test-content", response)

    def test_user_anonymous(self):
        response = self.app.get('/articles/%s' % self.title)
        self.assertNotContains("Edit article", response)
        self.assertNotContains("Delete article", response)

    def test_user_is_author(self):
        self.login_user(self.user)
        response = self.app.get('/articles/%s' % self.title)
        self.assertContains("Edit article", response)
        self.assertContains("Delete article", response)

    def test_user_is_not_author(self):
        user2 = User("test-user-2", "test-user-2@test.com", "testpwd")
        db.session.add(user2)
        db.session.commit()
        self.login_user(user2)
        response = self.app.get('/articles/%s' % self.title)
        self.assertNotContains("Edit article", response)
        self.assertNotContains("Delete article", response)

    def test_user_is_admin(self):
        self.login_user(self.admin)
        response = self.app.get('/articles/%s' % self.title)
        self.assertContains("Edit article", response)
        self.assertContains("Delete article", response)


class AdminViewTests(MdbTestCase):
    """docstring"""

    def test_visible_for_admin_only(self):
        response = self.app.get('/admin', follow_redirects=True)
        self.assertNotContains("Administration panel", response)
        self.login("test-user", "testpwd")
        response = self.app.get('/admin', follow_redirects=True)
        self.assertNotContains("Administration panel", response)
        self.logout()
        self.login("test-admin", "testpwd")
        response = self.app.get('/admin', follow_redirects=True)
        self.assertContains("Administration panel", response)

    def test_contains_all_users(self):
        self.login_user(self.admin)
        response = self.app.get('/admin/users')
        self.assertContains("test-user", response)
        self.assertContains("test-admin", response)

    def test_contains_all_articles(self):
        article1 = Article("test-title-1", "test-content", self.user)
        article2 = Article("test-title-2", "test-content", self.admin)
        db.session.add_all([article1, article2])
        db.session.commit()
        self.login_user(self.admin)
        response = self.app.get('/admin/articles')
        self.assertContains("test-title-1", response)
        self.assertContains("test-title-2", response)

