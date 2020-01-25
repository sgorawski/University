import os
import time
import json

import pika

import task

BROKER_URL = os.getenv('BROKER_URL')
TASK_QUEUE_NAME = os.getenv('TASK_QUEUE_NAME')
RESULT_QUEUE_NAME = os.getenv('RESULT_QUEUE_NAME')

connection = pika.BlockingConnection(pika.ConnectionParameters(BROKER_URL))
channel = connection.channel()
channel.queue_declare(queue=TASK_QUEUE_NAME)
channel.queue_declare(queue=RESULT_QUEUE_NAME)


def send_result(name, duration_s):
    body = json.dumps({'name': name, 's': duration_s})
    channel.basic_publish(
        exchange='',
        routing_key=RESULT_QUEUE_NAME,
        body=body,
    )


def callback(ch, method, properties, body):
    data = json.loads(body.decode('utf-8'))
    t = time.time()
    task.main(data['n'])
    duration_s = time.time() - t
    send_result(data['name'], duration_s)
    ch.basic_ack(delivery_tag=method.delivery_tag)


channel.basic_consume(callback, queue=TASK_QUEUE_NAME)
channel.start_consuming()
