from urllib.request import urlopen
from html.parser import HTMLParser
import re


def get_sentences_with_python(page):
    pattern = r"([^.]*Python[^.]*\.)"
    python_parser = _PythonParser(pattern)
    with urlopen(page) as data:
        python_parser.feed(data.read().decode('utf-8'))
        sentences = python_parser.sentences
    return "\n\nNA %s ZNALEZIONO:\n" % page + '\n\n'.join(sentences)


def proof_of_visit(page):
    return "VISITED " + page


class _PythonParser(HTMLParser):
    def __init__(self, pattern):
        super().__init__()
        self.regex = re.compile(pattern)
        self.sentences = []

    def handle_data(self, data):
        self.sentences.extend(map(str.strip, self.regex.findall(data)))
