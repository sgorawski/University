"""
Find decomposition of any number N in form:
N = p1^a1 * p2^a2 * ... * pn^an (p - primes)
Output displayed as a list of (pi, ai) pairs.
"""


def find_divider(n):
    divider = 2
    expotent = 0

    while n % divider != 0:
        divider += 1
    while n % divider == 0:
        expotent += 1
        n /= divider
    return n, (divider, expotent)


def decomposition(n):
    res = []
    while n > 1:
        n, new_pair = find_divider(n)
        res.append(new_pair)
    return res


if __name__ == "__main__":
    print(decomposition(756))
