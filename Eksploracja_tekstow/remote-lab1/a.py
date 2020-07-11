import argparse
import logging

logging.basicConfig(level=logging.INFO)

import search_engine

FLAGS = None

parser = argparse.ArgumentParser()
parser.add_argument('--no-color', action='store_true')


def yellow(text):
    return f'\033[33m{text}\033[m'


def brackets(text):
    return f'[{text}]'


def highlight(text):
    return (brackets if FLAGS.no_color else yellow)(text)


def display(quote, indices):
    for i in indices:
        quote[i] = highlight(quote[i])
    return ' '.join(quote)


if __name__ == '__main__':
    FLAGS = parser.parse_args()
    query = input().split()
    for result in search_engine.find_quotes(query):
        print(display(*result), end='\n\n')
