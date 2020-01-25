from ..task4 import Generator


BIGRAMS = {
    10: ("fst", "snd"),
    1: ("snd", "fst"),
}

TRIGRAMS = {
    10: ("fst", "snd", "trd"),
    1: ("snd", "fst", "trd"),
}


def test_generator_bigrams():
    gen = Generator(2)
    for count, words in BIGRAMS.items():
        gen.add_ngram(count, *words)
    act = gen.generate(["fst", "snd"], 2)
    assert act == [("fst snd", 10), ("snd fst", 1)]


def test_generator_trigrams():
    gen = Generator(3)
    for count, words in TRIGRAMS.items():
        gen.add_ngram(count, *words)
    act = gen.generate(["fst", "snd", "trd"], 2)
    assert act == [("fst snd trd", 10), ("snd fst trd", 1)]
