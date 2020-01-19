import matplotlib.pyplot as plt

from tests import measure_avg_time


N_VALUES = list(range(256, 700, 64))
V_VALUES = [0, 1, 2, 3]
FIG_FILENAME = 'figure.png'


def perform_test_and_plot():
    times = {v: [] for v in V_VALUES}
    for v in V_VALUES:
        for n in N_VALUES:
            time = measure_avg_time('./matmult', {'-n': n, '-v': v})
            times[v].append(time)
            print('n =', n, 'v =', v, 'avg time =', time)
        plt.plot(N_VALUES, times[v], label='v%d' % v)
    plt.title("Matrix multiply performance")
    plt.xlabel("Matrix size (n)")
    plt.ylabel("Avg time elapsed [s]")
    plt.legend()
    plt.savefig(FIG_FILENAME)
    print("Saved in file", FIG_FILENAME)


if __name__ == '__main__':
    perform_test_and_plot()