import re

import pytest

from ..task2_3 import Bigram, Trigram, BigramFreq, TrigramFreq


BIGRAMS = {
    1: "start mid",
    4: "mid mid",
    9: "mid end",
}


TRIGRAMS = {
    1: "start start mid",
    4: "start mid end",
    9: "mid end",
}


@pytest.mark.parametrize("bg_cls", [Bigram, BigramFreq])
def test_bigram_gen(bg_cls):
    gen = bg_cls()
    for count, line in BIGRAMS.items():
        params = line.split(" ")
        gen.add(count, *params)
    sentence = gen.generate()
    assert re.fullmatch(r"(start )?(mid )+end", sentence)


@pytest.mark.parametrize("trg_cls", [Trigram, TrigramFreq])
def test_trigram_gen(trg_cls):
    gen = trg_cls()
    for count, line in TRIGRAMS.items():
        params = line.split(" ")
        gen.add(count, *params)
    sentence = gen.generate()
    assert re.fullmatch(r"(start ){0,2}mid end", sentence)
