import os

from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def msg():
    return jsonify({
        'app_v': 1,
        'msg': os.getenv('MSG'),
    })
