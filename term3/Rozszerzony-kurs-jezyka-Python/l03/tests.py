from time import time
from task1 import primes_comprehension, primes_functional
from task2 import perfect_comprehension, perfect_functional


print("\nprimes(20)")
print(primes_comprehension(20))
print(primes_functional(20))


print("\nperfect(1000)")
print(perfect_comprehension(1000))
print(perfect_functional(1000))


def measure_time(f, n):
    beginning = time()
    f(n)
    print("\nTime used by %s(%d) - %fs" % (f.__name__, n, time() - beginning))


measure_time(primes_comprehension, 10000)
measure_time(primes_functional, 10000)
measure_time(perfect_comprehension, 5000)
measure_time(perfect_functional, 5000)
