import os

from flask import Flask, request, jsonify
import psycopg2

app = Flask(__name__)

DBNAME = os.getenv('DBNAME')
USER = os.getenv('USER')
PASSWORD = os.getenv('PASSWORD')
HOST = os.getenv('HOST')
PORT = os.getenv('PORT')

conn = psycopg2.connect(dbname=DBNAME, user=USER, password=PASSWORD, host=HOST, port=PORT)


def upload_data(name, price):
    with conn.cursor() as cur:
        cur.execute(f"INSERT INTO items VALUES ('{name}', {price});")
        conn.commit()


@app.route('/', methods=['POST'])
def index():
    body = request.get_json()
    upload_data(body['name'], body['price'])
    return ('', 204)
