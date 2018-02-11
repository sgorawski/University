"""
Printing multiplication table
for all numbers like [x1, x2] * [y1, y2].
"""


def multiplication_table(x1, x2, y1, y2):
    print(' ', end=' ')
    for x in range(x1, x2 + 1):
        print(x, end=' ')
    print()

    for y in range(y1, y2 + 1):
        print(y, end=' ')
        for x in range(x1, x2 + 1):
            print(x * y, end=' ')
        print()


if __name__ == "__main__":
    multiplication_table(3, 5, 2, 4)
