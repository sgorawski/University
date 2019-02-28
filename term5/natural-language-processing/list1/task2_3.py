import random
from abc import ABC, abstractmethod
from typing import Dict, List, Tuple, Optional

import click


class Generator(ABC):
    @abstractmethod
    def add(self, *_):
        """Add new n-gram to collection"""

    @abstractmethod
    def generate(self) -> str:
        """Generate a sentence using n-grams collection"""


class _BiGenerator(Generator, ABC):
    @abstractmethod
    def add(self, count: int, prev: str, succ: str):
        """Signature suited to match bigrams file line"""


class _TriGenerator(Generator, ABC):
    @abstractmethod
    def add(self, count: int, prev1: str, prev2: str, succ: Optional[str]):
        """Signature suited to match trigrams file line"""


class Bigram(_BiGenerator):
    def __init__(self):
        self.succs: Dict[str, List[str]] = {}

    def add(self, _, prev: str, succ: str):
        succs = self.succs.get(prev, [])
        if not succs:
            self.succs[prev] = succs
        succs.append(succ)

    def generate(self) -> str:
        prev = random.choice(list(self.succs))
        words = [prev]
        succs = self.succs.get(prev)
        while succs:
            succ = random.choice(succs)
            words.append(succ)
            succs = self.succs.get(succ)
        return " ".join(words)


class Trigram(_TriGenerator):
    def __init__(self):
        self.succs: Dict[Tuple[str, str], List[str]] = {}

    def add(self, _, prev1: str, prev2: str, succ: str = None):
        if not succ:
            return
        succs = self.succs.get((prev1, prev2), [])
        if not succs:
            self.succs[(prev1, prev2)] = succs
        succs.append(succ)

    def generate(self) -> str:
        prev1, prev2 = random.choice(list(self.succs))
        words = [prev1, prev2]
        succs = self.succs.get((prev1, prev2))
        while succs:
            succ = random.choice(succs)
            words.append(succ)
            prev1, prev2 = prev2, succ
            succs = self.succs.get((prev1, prev2))
        return " ".join(words)


class BigramFreq(_BiGenerator):
    def __init__(self):
        self.succs: Dict[str, List[Tuple[str, int]]] = {}

    def add(self, count: int, prev: str, succ: str):
        succs = self.succs.get(prev, [])
        if not succs:
            self.succs[prev] = succs
        succs.append((succ, count))

    def generate(self) -> str:
        prev = random.choice(list(self.succs))
        words = [prev]
        succs = self.succs.get(prev)
        while succs:
            population, weights = zip(*succs)
            succ = random.choices(population, weights)[0]
            words.append(succ)
            succs = self.succs.get(succ)
        return " ".join(words)


class TrigramFreq(_TriGenerator):
    def __init__(self):
        self.succs: Dict[Tuple[str, str], List[Tuple[str, int]]] = {}

    def add(self, count: int, prev1: str, prev2: str, succ: str = None):
        if not succ:
            return
        succs = self.succs.get((prev1, prev2), [])
        if not succs:
            self.succs[(prev1, prev2)] = succs
        succs.append((succ, count))

    def generate(self) -> str:
        prev1, prev2 = random.choice(list(self.succs))
        words = [prev1, prev2]
        succs = self.succs.get((prev1, prev2))
        while succs:
            population, weights = zip(*succs)
            succ = random.choices(population, weights)[0]
            words.append(succ)
            prev1, prev2 = prev2, succ
            succs = self.succs.get((prev1, prev2))
        return " ".join(words)


GEN_CLS = {
    (2, False): Bigram,
    (3, False): Trigram,
    (2, True): BigramFreq,
    (3, True): TrigramFreq,
}

NGRAMS_FILE = {
    2: "poleval_2grams.txt",
    3: "poleval_3grams.txt",
}


@click.command()
@click.option("-n", help="n-grams to use", default=2)
@click.option("-f", help="use frequency", is_flag=True)
@click.option("-s", help="number of sentences to generate", default=1)
@click.option("-k", help="at least k occurencies", default=2)
def generate(n: int, f: bool, s: int, k: int):
    assert n in (2, 3)
    gen = GEN_CLS[(n, f)]()
    click.echo(f"Loading {n}-grams")
    with open(NGRAMS_FILE[n]) as f:
        for line in f:
            line = line[:-1]
            params = line.split(" ")
            count = int(params.pop(0))
            if count >= k:
                gen.add(count, *params)
    click.echo("Generating sentences")
    for _ in range(s):
        sentence = gen.generate()
        click.echo(10 * "-")
        click.echo(sentence)


if __name__ == "__main__":
    generate()
