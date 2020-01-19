import itertools
import functools
import operator
from typing import List, Dict, Tuple

import click


class Generator:
    def __init__(self, n: int):
        self.n = n
        self.count_by_ngram: Dict[Tuple[str, ...], int] = {}

    def add_ngram(self, count: int, *words):
        self.count_by_ngram[tuple(words)] = count

    def _assess_naturality(self, perm: Tuple[str]) -> int:
        return functools.reduce(
            operator.mul,
            (
                self.count_by_ngram.get(tuple(perm[i:i+self.n]), 0)
                for i in range(len(perm) - self.n + 1)
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

NGRAMS_FILE = {
    2: "poleval_2grams.txt",
    3: "poleval_3grams.txt",
}


@click.command()
@click.option("-n", help="n-grams to use", default=2)
@click.option("-s", help="Number of sentences for each word set", default=5)
def generate(n: int, s: int):
    gen = Generator(n)
    word_lists = [wl.split(" ") for wl in WORD_MULTISETS]
    all_words = set(itertools.chain.from_iterable(word_lists))
    click.echo(f"Loading {n}-grams")
    with open(NGRAMS_FILE[n]) as f:
        for line in f:
            line = line[:-1]
            words = line.split(" ")
            count = int(words.pop(0))
            if all(word in all_words for word in words):
                gen.add_ngram(count, *words)
    click.echo("Generating sentences")
    for words in word_lists:
        click.echo(10 * "-")
        for sentence, naturality in gen.generate(words, s):
            click.echo(f"{naturality} | {sentence}")


if __name__ == "__main__":
    generate()
