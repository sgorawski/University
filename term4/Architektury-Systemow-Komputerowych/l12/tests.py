import subprocess
import re


def measure_avg_time(name, flags, tests=10):
    args = [name]
    for k, v in flags.items():
        args += [k, str(v)]
    times = []
    for _ in range(tests):
        out = subprocess.check_output(args)
        time = float(
            re.search(br'[0-9]+\.[0-9]+', out).group().decode('ascii'))
        times.append(time)
    times.sort()
    std_times = times[2:8]   # remove extreme results
    return sum(std_times) / len(std_times)
