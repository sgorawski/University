import os

import requests
from flask import Flask, render_template, redirect, url_for, request

app = Flask(__name__)

READER_URL = os.getenv('READER_URL')
WRITER_URL = os.getenv('WRITER_URL')


def get_data():
    resp = requests.get(f'{READER_URL}/')
    return resp.json()


def upload_item(name, price):
    item = {'name': name, 'price': price}
    requests.post(f'{WRITER_URL}/', json=item)


@app.route('/')
def index():
    data = get_data()
    return render_template(
        'index.html', items=data['items'], avg_price=data['avg_price']
    )


@app.route('/upload', methods=['POST', 'GET'])
def upload():
    if request.method == 'POST':
        upload_item(request.form['name'], request.form['price'])
        return redirect(url_for('index'))
    return render_template('upload.html')
