from datetime import datetime

import flask as f

from . import db


class Balance(db.Model):
    __table_args__ = (
        db.PrimaryKeyConstraint('currency', 'address', 'timestamp'),
    )

    currency = db.Column(db.String(3), nullable=False)
    address = db.Column(db.String(100), nullable=False)
    amount = db.Column(db.Numeric(10, 6), nullable=False)
    value_usd = db.Column(db.Numeric(10, 2), nullable=False)
    timestamp = db.Column(db.DateTime(), nullable=False, default=datetime.now)

    def __init__(self, amount, value_usd):
        self.currency = f.session['currency']
        self.address = f.session['address']
        self.amount = amount
        self.value_usd = value_usd


class Price(db.Model):
    __table_args__ = (
        db.PrimaryKeyConstraint('currency', 'timestamp'),
    )

    currency = db.Column(db.String(3), nullable=False)
    value_usd = db.Column(db.Numeric(10, 2), nullable=False)
    timestamp = db.Column(db.DateTime(), nullable=False, default=datetime.now)

    def __init__(self, currency, value_usd):
        self.currency = currency
        self.value_usd = value_usd


class Transfer(db.Model):
    __table_args__ = (
        db.PrimaryKeyConstraint('currency', 'transaction_id', 'timestamp'),
    )

    currency = db.Column(db.String(3), nullable=False)
    from_address = db.Column(db.String(100), nullable=False)
    to_address = db.Column(db.String(100), nullable=False)
    amount = db.Column(db.Numeric(10, 6), nullable=False)
    transaction_id = db.Column(db.String(100), nullable=False)
    timestamp = db.Column(db.DateTime(), nullable=False, default=datetime.now)

    def __init__(self, to_address, amount, transaction_id):
        self.currency = f.session['currency']
        self.from_address = f.session['address']
        self.to_address = to_address
        self.amount = amount
        self.transaction_id = transaction_id
