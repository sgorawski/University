from flask_wtf import FlaskForm
import wtforms as wtf


class CurrencyField(wtf.SelectField):

    def __init__(self, **kwargs):
        super().__init__(
            label='Currency',
            choices=[
                ('btc', 'Bitcoin'),
                ('eth', 'Ethereum'),
            ],
            **kwargs
        )


class Login(FlaskForm):
    address = wtf.StringField('Address')
    currency = CurrencyField()
    submit = wtf.SubmitField('Access')


class Recipient(wtf.Form):
    address = wtf.StringField('To Address')
    amount = wtf.DecimalField('Amount', places=6)


class Transfer(FlaskForm):
    private_key = wtf.StringField('Private Key')
    recipients = wtf.FieldList(wtf.FormField(Recipient), min_entries=1)
    submit = wtf.SubmitField('Send')


class CreateWallet(FlaskForm):
    currency = CurrencyField()
    mnemonic = wtf.TextAreaField('Mnemonic')
    submit = wtf.SubmitField('Create')
