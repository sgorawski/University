import random


def opt_dist(digits, n):
    """Based on a sliding window, idea:
    for all possible window positions find a min value
    of flips of digits inside window to 1
    and flips outside window to 0.
    """
    total_num_1s = sum(digits)
    num_1s_in_window = sum(digits[:n])
    least_flips = (n - num_1s_in_window) + (total_num_1s - num_1s_in_window)
    for start, end in zip(digits, digits[n:]):
        num_1s_in_window -= start
        num_1s_in_window += end
        least_flips = min(
            (n - num_1s_in_window) + (total_num_1s - num_1s_in_window),
            least_flips
        )
    return least_flips


if __name__ == '__main__':
    with open('zad4_input.txt') as inp, open('zad4_output.txt', 'w+') as out:
        for line in inp:
            digits_raw, n_raw = line.split()
            digits, n = [int(x) for x in digits_raw], int(n_raw)
            ans = opt_dist(digits, n)
            out.write(f'{ans}\n')
