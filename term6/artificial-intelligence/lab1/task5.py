import random

import task4


class Picross:
    MAX_NUM_TRIES = 10_000

    def __init__(self, row_nums, col_nums):
        self.row_nums = row_nums
        self.col_nums = col_nums
        self.reset()
    
    def reset(self):
        self.rows = [[0] * len(self.col_nums) for _ in self.row_nums]
        self.cols = [[0] * len(self.row_nums) for _ in self.col_nums]
        for x in range(len(self.cols)):
            for y in range(len(self.rows)):
                if random.randint(0, 1):
                    self.flip(x, y)

    def try_to_solve(self):
        for _ in range(self.MAX_NUM_TRIES):
            if self.is_solved():
                return
            
            if random.randint(0, 1):
                self.change_random_row()
            else:
                self.change_random_col()
    
    def opt_dist(self, digits, n):
        # fancy wrapper
        return task4.opt_dist(digits, n)

    def is_solved(self):
        return all(
            self.opt_dist(row, n) == 0
            for row, n in zip(self.rows, self.row_nums)
        ) and all(
            self.opt_dist(col, n) == 0
            for col, n in zip(self.cols, self.col_nums)
        )
    
    def change_random_row(self):
        y = random.randint(0, len(self.row_nums) - 1)
        row, row_num = self.rows[y], self.row_nums[y]

        best_flip_x, min_dist = 0, len(row) + len(self.col_nums) + 1

        for x, (col, col_num) in enumerate(zip(self.cols, self.col_nums)):
            self.flip(x, y)

            curr_dist = self.opt_dist(row, row_num) + self.opt_dist(col, col_num)
            if curr_dist < min_dist:
                min_dist = curr_dist
                best_flip_x = x

            self.flip(x, y)
        
        self.flip(best_flip_x, y)
    
    def change_random_col(self):
        x = random.randint(0, len(self.col_nums) - 1)
        col, col_num = self.cols[x], self.col_nums[x]

        best_flip_y, min_dist = 0, len(col) + len(self.row_nums) + 1

        for y, (row, row_num) in enumerate(zip(self.rows, self.row_nums)):
            self.flip(x, y)

            curr_dist = self.opt_dist(col, col_num) + self.opt_dist(row, row_num)
            if curr_dist < min_dist:
                min_dist = curr_dist
                best_flip_y = y

            self.flip(x, y)
        
        self.flip(x, best_flip_y)

    def flip(self, x, y):
        self.rows[y][x] ^= 1
        self.cols[x][y] ^= 1

    def as_image(self):
        return '\n'.join(
            ''.join('#' if c == 1 else '.' for c in row)
            for row in self.rows
        )


if __name__ == '__main__':
    with open('zad5_input.txt') as inp:
        size_raw = inp.readline()
        num_rows, num_cols = map(int, size_raw.split())
        row_nums = [int(inp.readline()) for _ in range(num_rows)]
        col_nums = [int(inp.readline()) for _ in range(num_cols)]
    
    puzzle = Picross(row_nums, col_nums)

    while not puzzle.is_solved():
        puzzle.reset()
        puzzle.try_to_solve()
    
    with open('zad5_output.txt', 'w+') as out:
        out.write(puzzle.as_image())
