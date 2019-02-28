import os

from flask import Flask, jsonify
import psycopg2

app = Flask(__name__)

DBNAME = os.getenv('DBNAME')
USER = os.getenv('USER')
PASSWORD = os.getenv('PASSWORD')
HOST = os.getenv('HOST')
PORT = os.getenv('PORT')

conn = psycopg2.connect(dbname=DBNAME, user=USER, password=PASSWORD, host=HOST, port=PORT)


def get_data():
    with conn.cursor() as cur:
        cur.execute("SELECT * FROM items;")
        return cur.fetchall()


def format_data(rows):
    items = [{'name': name, 'price': price} for name, price in rows]
    avg_price = sum(item['price'] for item in items) / len(items)
    return {'items': items, 'avg_price': avg_price}


@app.route('/')
def index():
    data = format_data(get_data())
    return jsonify(data)
