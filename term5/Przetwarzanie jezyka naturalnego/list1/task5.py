import itertools
import functools
import operator
from typing import Dict, Tuple, List

import click


NONEXISTENT_CNT = 1


class Generator:
    def __init__(self):
        self.count_by_tags: Dict[Tuple[str, str], int] = {}
        self.tag: Dict[str, str] = {}

    def add_count(self, count: int, word1: str, word2: str):
        tag1, tag2 = self.tag.get(word1.lower()), self.tag.get(word2.lower())
        if tag1 and tag2:
            self.count_by_tags[(tag1, tag2)] = count

    def add_tag(self, word: str, tag: str):
        self.tag[word] = tag

    def _assess_naturality(self, perm: Tuple[str]) -> int:
        tag_seq = [self.tag.get(word.lower()) for word in perm]
        return functools.reduce(
            operator.mul,
            (
                self.count_by_tags.get((tag_seq[i], tag_seq[i + 1]), NONEXISTENT_CNT)
                for i in range(len(tag_seq) - 1)
            ),
            1,
        )
    
    def generate(self, words: List[str], count: int) -> List[Tuple[str, int]]:
        perms_with_score = [
            (perm, self._assess_naturality(perm))
            for perm in itertools.permutations(words)
        ]
        perms_with_score.sort(key=lambda pwn: pwn[1], reverse=True)
        return [(" ".join(p), n) for p, n in perms_with_score[:count]]


WORD_MULTISETS = [
    "Judyta dała wczoraj Stefanowi czekoladki",
    "Babuleńka miała dwa rogate koziołki",
    "Wczoraj wieczorem spotkałem pewną piękną kobietę",
    "Król Karol kupił królowej Karolinie korale koloru koralowego",
    "Boże coś Polskę ojczyznę naszą",
    "Dwa razy ostra baranina na grubym",
]

BIGRAMS_FILE = "poleval_2grams.txt"
TAGS_FILE = "../supertags.txt"


@click.command()
@click.option("-s", help="Number of sentences for each word set", default=5)
@click.option("-k", help="At least k occurencies", default=2)
def generate(s: int, k: int):
    gen = Generator()
    word_lists = [wl.split(" ") for wl in WORD_MULTISETS]
    all_words = set(itertools.chain.from_iterable(word_lists))
    click.echo("Loading supertags")
    with open(TAGS_FILE) as f:
        for line in f:
            line = line[:-1]
            word, tag = line.split(" ")
            gen.add_tag(word, tag)

    click.echo("Loading bigrams")
    with open(BIGRAMS_FILE) as f:
        for line in f:
            line = line[:-1]
            words = line.split(" ")
            count = int(words.pop(0))
            if count >= k:
                gen.add_count(count, *words)

    click.echo("Generating sentences")
    for words in word_lists:
        click.echo(10 * "-")
        for sentence, naturality in gen.generate(words, s):
            click.echo(f"{naturality} | {sentence}")


if __name__ == "__main__":
    generate()
