import argparse
import logging
from collections import defaultdict

logging.basicConfig(level=logging.INFO)

import search_engine

TRIGRAMS_FILE_PATH = 'data/przypadkowe_trigramy.txt'

FLAGS = None

parser = argparse.ArgumentParser()
parser.add_argument('--min-size', type=int, default=0)
parser.add_argument('--with-words', nargs='*', action='append')


def find_trigram_groups(trigrams_raw):
    groups_by_quote_ids = defaultdict(list)
    for line in trigrams_raw:
        trigram = line.split()
        try:
            quote_ids = search_engine.find_quote_ids(trigram)
        except ValueError as e:
            logging.error(e)
            continue
        key = tuple(sorted(quote_ids))
        groups_by_quote_ids[key].append(trigram)
    return groups_by_quote_ids.values()


def display(group):
    return '\n'.join(' '.join(trigram) for trigram in group)


def should_display(group):
    if len(group) < FLAGS.min_size:
        return False
    if not FLAGS.with_words:
        return True
    return any(
        any(
            set(trigram).issuperset(set(words))
            for trigram in group
        )
        for words in FLAGS.with_words
    )


if __name__ == '__main__':
    FLAGS = parser.parse_args()
    with open(TRIGRAMS_FILE_PATH) as f:
        for group in find_trigram_groups(f):
            if not should_display(group):
                continue
            print(display(group), end='\n\n')
