from functools import wraps

import flask as f


def authenticate(currency, address):
    f.session['currency'] = currency
    f.session['address'] = address


def deauthenticate():
    f.session.pop('address')
    f.session.pop('currency')


def is_authenticated():
    return 'currency' in f.session and 'address' in f.session


def authenticated(view):
    @wraps(view)
    def _(*args, **kwargs):
        if not is_authenticated():
            return f.redirect(f.url_for('wallets.index'))
        return view(*args, **kwargs)
    return _


def get():
    assert is_authenticated()
    return f.session['currency'], f.session['address']


def get_text():
    assert is_authenticated()
    return f"{f.session['currency'].upper()} {f.session['address']}"
