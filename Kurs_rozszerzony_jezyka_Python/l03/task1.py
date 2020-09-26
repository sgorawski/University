def primes_comprehension(n):
    return [
        x for x in range(2, n + 1)
        if all(x % i != 0 for i in range(2, x))
    ]


def primes_functional(n):
    return list(filter(
        lambda x: all(map(lambda i: x % i != 0, range(2, x))),
        range(2, n + 1),
    ))
