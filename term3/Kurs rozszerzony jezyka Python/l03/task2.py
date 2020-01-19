def perfect_comprehension(n):
    return [x for x in range(1, n + 1)
            if sum([i for i in range(1, x) if x % i == 0]) == x]


def perfect_functional(n):
    return list(filter(lambda x:
                sum(filter(lambda i: x % i == 0, range(1, x))) == x,
                    range(1, n + 1)))
