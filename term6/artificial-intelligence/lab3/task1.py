from queue import Queue


def possible_settings(n, pattern):
    if not n:
        return [[]]
    if not pattern:
        return [[0] * n]
    block_len = pattern[0]
    block = [1] * block_len
    new_n = n - block_len
    if pattern[1:]:
        block += [0]
        new_n -= 1
    current_possibilities = [block + p for p in possible_settings(new_n, pattern[1:])]
    required_len = sum(pattern) + len(pattern) - 1
    if required_len < n:
        return current_possibilities + [[0, *p] for p in possible_settings(n - 1, pattern)]
    else:
        return current_possibilities


class Picross:

    def __init__(self, rows, columns):
        self.possible_rows = [possible_settings(len(columns), row) for row in rows]
        self.possible_columns = [possible_settings(len(rows), column) for column in columns]

    def solve(self):
        to_visit = Queue()

        for y in range(len(self.possible_rows)):
            for x in range(len(self.possible_columns)):
                to_visit.put((x, y))

        while not to_visit.empty():
            x, y = to_visit.get()
            changed = self.try_to_adjust(x, y)
            if not changed:
                to_visit.put((x, y))
    
    def try_to_adjust(self, x, y):
        b = self.possible_rows[y][0][x]
        if all(r[x] == b for r in self.possible_rows[y]):
            self.possible_columns[x] = [c for c in self.possible_columns[x] if c[y] == b]
            return True
            
        b = self.possible_columns[x][0][y]
        if all(c[y] == b for c in self.possible_columns[x]):
            self.possible_rows[y] = [r for r in self.possible_rows[y] if r[x] == b]
            return True
        
        return False

    def as_image(self):
        return '\n'.join(
            ''.join('#' if c == 1 else '.' for c in rows[0])
            for rows in self.possible_rows
        )


if __name__ == '__main__':
    with open('zad_input.txt') as inp:
        size_raw = inp.readline()
        num_rows, num_cols = map(int, size_raw.split())
        row_nums = [[int(x) for x in inp.readline().split()] for _ in range(num_rows)]
        col_nums = [[int(x) for x in inp.readline().split()] for _ in range(num_cols)]
    
    puzzle = Picross(row_nums, col_nums)
    puzzle.solve()
    
    with open('zad_output.txt', 'w+') as out:
        out.write(puzzle.as_image())
