import os
import unittest

from config import ROOT
from mdb import app, db
from mdb.models import User


def load_tests():
    test_dir = os.path.join(ROOT, 'tests')
    suite = unittest.defaultTestLoader.discover(test_dir)
    return suite


TEST_DB_PATH = os.path.join(ROOT, 'tests', 'test.db')


class MdbTestCase(unittest.TestCase):
    def setUp(self):
        app.testing = True
        app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + TEST_DB_PATH
        app.config['WTF_CSRF_ENABLED'] = False
        self.app = app.test_client()
        db.create_all()
        self.admin = User("test-admin", "test-admin@test.com", "testpwd")
        self.admin.is_admin = True
        self.user = User("test-user", "test-user@test.com", "testpwd")
        db.session.add_all([self.admin, self.user])
        db.session.commit()

    def tearDown(self):
        db.session.remove()
        db.drop_all()
        os.unlink(TEST_DB_PATH)

    def assertContains(self, text, response):
        self.assertIn(text, response.data.decode('utf-8'))

    def assertNotContains(self, text, response):
        self.assertNotIn(text, response.data.decode('utf-8'))

    def login(self, username, password):
        return self.app.post('/login', data={
            'username': username,
            'password': password,
        }, follow_redirects=True)

    def login_user(self, user):
        self.login(user.username, "testpwd")

    def logout(self):
        return self.app.post('/logout', follow_redirects=True)
