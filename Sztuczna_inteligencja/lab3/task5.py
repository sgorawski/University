import sys
import itertools

import jinja2


def liststr(iterable):
    return f"[{', '.join(iterable)}]"


def get_variables(height, width):
    return liststr(
        f'V{h}_{w}'
        for h in range(height)
        for w in range(width)
    )


# Constraints

def pre_filled(fields):
    return (
        f'V{h}_{w} #= {val}'
        for (h, w), val in fields.items()
    )


def row_sums(rows, width):
    return (
        f'sum({liststr(f"V{h}_{w}" for w in range(width))}, #=, {sum_in_row})'
        for h, sum_in_row in enumerate(rows)
    )


def col_sums(cols, height):
    return (
        f'sum({liststr(f"V{h}_{w}" for h in range(height))}, #=, {sum_in_col})'
        for w, sum_in_col in enumerate(cols)
    )


def no_single_horizontal(height, width):
    """Prevents
    0 1 0
    """
    return (
        rf'V{h}_{w} #==> V{h}_{w - 1} #\/ V{h}_{w + 1}'
        for w in range(1, width - 1)
        for h in range(height)
    )


def no_single_vertical(height, width):
    """Prevents
    0
    1
    0
    """
    return (
        rf'V{h}_{w} #==> V{h - 1}_{w} #\/ V{h + 1}_{w}'
        for h in range(1, height - 1)
        for w in range(width)
    )


def squares(height, width):
    """If one diagonal in any 2x2 square is filled, the other one must be too
    0 1 <=> 1 0
    1 0     0 1
    """
    return (
        rf'V{h}_{w} #/\ V{h - 1}_{w - 1} #<==> V{h}_{w - 1} #/\ V{h - 1}_{w}'
        for h in range(1, height)
        for w in range(1, width)
    )


def read_input(inp):
    rows = [int(x) for x in next(inp).split()]
    cols = [int(x) for x in next(inp).split()]
    fields = {}
    for line in inp:
        h, w, val = line.split()
        fields[(h, w)] = val
    return rows, cols, fields


if __name__ == '__main__':
    rows, cols, fields = read_input(sys.stdin)
    height, width = len(rows), len(cols)

    variables = get_variables(height, width)
    constraints = itertools.chain(
        pre_filled(fields),
        row_sums(rows, width),
        col_sums(cols, height),
        no_single_horizontal(height, width),
        no_single_vertical(height, width),
        squares(height, width),
    )

    env = jinja2.Environment(loader=jinja2.FileSystemLoader('.'))
    template = env.get_template('binary-puzzle.pl')

    program = template.render(variables=variables, constraints=constraints)
    sys.stdout.write(program)
