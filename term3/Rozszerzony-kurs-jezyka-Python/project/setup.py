from setuptools import setup

setup(
    name='mdb',
    packages=['mdb'],
    include_package_data=True,
    install_requires=[
        'flask',
        'flask-wtf',
        'flask-sqlalchemy',
        'flask-migrate',
        'flask-login',
        'markdown',
    ],
    test_suite='tests.load_tests',
)
