from time import time

from task1 import primes_generator, primes_comprehension, primes_functional
from task3 import sentences


# TASK 1 TEST
def time_test(fun, n):
    begin = time()
    fun(n)
    return time() - begin


def format_output(out, length):
    output = " %f" % out
    return output + ' ' * (length - len(output))


for name in ['', "generator", "comprehension", "functional"]:
    print(' ' + name + ' ' * (12 - len(name) - 1), end='|')
print()
for n in [10, 100, 1000]:
    print(' ' + str(n) + ' ' * (12 - len(str(n)) - 1), end='|')
    for fun in [primes_generator, primes_comprehension, primes_functional]:
        print(format_output(time_test(fun, n), 12), end='|')
    print()
print("\n\n\n")


# TASK 3 TEST
with open("example.txt", 'r') as f:
    for sentence in sentences(f):
        print(sentence)
