import csv
import logging
from collections import defaultdict

_logger = logging.getLogger(__name__)

_BASE_FORMS_FILE_PATH = 'data/polimorfologik-2.1.txt'
_TOKENIZED_QUOTES_FILE_PATH = 'data/tokenized_quotes.txt'

_BASE_FORMS = {}
_QUOTES = []
_INDEX = defaultdict(set)

with open(_BASE_FORMS_FILE_PATH) as f:
    _logger.info('Loading base forms...')
    for base, word, *_ in csv.reader(f, delimiter=';'):
        _BASE_FORMS[word] = base

with open(_TOKENIZED_QUOTES_FILE_PATH) as f:
    _logger.info('Loading quotes...')
    for i, line in enumerate(f):
        words = line.split()
        _QUOTES.append(words)
        for word in words:
            if base := _BASE_FORMS.get(word):
                _INDEX[base].add(i)

_logger.info('Ready')


def find_quote_ids(query):
    try:
        base_query = {_BASE_FORMS[qword] for qword in query}
    except KeyError as e:
        raise ValueError(f'No base form for "{e.args[0]}"')
    return set.intersection(*(_INDEX[base] for base in base_query))


def find_quotes(query):
    base_query = {_BASE_FORMS[qword] for qword in query}
    for i in find_quote_ids(query):
        quote = _QUOTES[i]
        indices = [
            i for i, word in enumerate(quote)
            if _BASE_FORMS.get(word) in base_query
        ]
        yield quote, indices
