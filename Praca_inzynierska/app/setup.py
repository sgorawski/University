#!/usr/bin/env python

from setuptools import setup

setup(
    name='app',
    packages=['app'],
    include_package_data=True,
    install_requires=[
        'flask==1.0.2',
        'flask-wtf==0.14.2',
        'flask-sqlalchemy==2.4.0',
        'flask-migrate==2.5.2',
        'psycopg2-binary==2.8.3',
        'requests==2.21.0',
    ],
    extras_require={
        'dev': [
            'python-dotenv',
        ],
    },
)
