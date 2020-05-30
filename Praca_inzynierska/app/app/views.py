from datetime import datetime, timedelta

import flask as f
from lib.exc import RpcError, NotEnoughMoney

from . import forms, auth, prices, db
from .blocks import blocks
from .models import Balance, Price, Transfer
from .utils import d2

wallets = f.Blueprint('wallets', __name__)


@wallets.route('/')
def index():
    if auth.is_authenticated():
        currency, address = auth.get()
        block = blocks[currency]

        try:
            balances = (
                Balance.query
                .filter_by(currency=currency, address=address)
                .order_by(Balance.timestamp)
                .all()
            )
            last_balance = balances and balances[-1]
            curr_amount = block.get_balance(address)

            price = Price.query.filter_by(currency=currency).order_by(Price.timestamp.desc()).first()
            if not price or price.timestamp < datetime.now() - timedelta(minutes=30):
                rates = prices.get()
                v = rates[currency]
                for ccy, value_usd in rates.items():
                    db.session.add(Price(ccy.lower(), value_usd))
                db.session.commit()
            else:
                v = price.value_usd

            curr_value_usd = d2(curr_amount * v)

            if not last_balance or curr_amount != last_balance.amount or curr_value_usd != last_balance.value_usd:
                curr_balance = Balance(curr_amount, curr_value_usd)
                balances.append(curr_balance)
                db.session.add(curr_balance)
                db.session.commit()

            transfers = (
                Transfer.query
                .filter_by(currency=currency, from_address=address)
                .order_by(Transfer.timestamp)
                .all()
            )

            return f.render_template(
                'view_wallet.jinja2',
                balances=balances,
                transfers=transfers,
            )

        except RpcError as e:
            f.flash(e.info.get('message'), category='error')
            auth.deauthenticate()

    return f.render_template('welcome.jinja2')


@wallets.route('/login', methods=['GET', 'POST'])
def login():
    form = forms.Login()

    if form.validate_on_submit():
        auth.authenticate(form.currency.data, form.address.data)
        f.flash(f"Now viewing wallet {auth.get_text()}")
        return f.redirect(f.url_for('wallets.index'))

    return f.render_template('login.jinja2', form=form)


@wallets.route('/logout', methods=['POST'])
@auth.authenticated
def logout():
    f.flash(f"Finished viewing wallet {auth.get_text()}")
    auth.deauthenticate()
    return f.redirect(f.url_for('wallets.index'))


@wallets.route('/transfer', methods=['GET', 'POST'])
@auth.authenticated
def transfer():
    num_recipients = int(f.request.args.get('num-recipients', '1'))
    form = forms.Transfer()
    for _ in range(len(form.recipients), num_recipients):
        form.recipients.append_entry()

    if form.validate_on_submit():
        block = blocks[f.session['currency']]
        to = {
            recipient.address.data: recipient.amount.data
            for recipient in form.recipients if recipient.address.data
        }
        try:
            tx_ids = block.send_money(form.private_key.data, to)
            f.flash(f"Transfer successful")

            for (to_address, amount), tx_id in zip(to.items(), tx_ids):
                transfer = Transfer(to_address, amount, tx_id)
                db.session.add(transfer)
            db.session.commit()

            return f.redirect(f.url_for('wallets.index'))
        except NotEnoughMoney:
            f.flash(f"Not enough money on wallet {auth.get_text()}", category='error')
        except RpcError as e:
            f.flash(e.info.get('message'), category='error')

    return f.render_template('transfer.jinja2', form=form)


@wallets.route('/create-wallet', methods=['GET', 'POST'])
def create():
    form = forms.CreateWallet()

    if form.validate_on_submit():
        currency = form.currency.data
        block = blocks[currency]
        seed = form.mnemonic.data or None

        try:
            address, private_key, mnemonic = block.create_wallet(seed)
            auth.authenticate(currency, address)
            f.flash(f"Created wallet {auth.get_text()}")
            return f.render_template(
                'wallet_created.jinja2', private_key=private_key, mnemonic=mnemonic
            )
        except RpcError as e:
            f.flash(e.info.get('message'), category='error')

    return f.render_template('create_wallet.jinja2', form=form)
