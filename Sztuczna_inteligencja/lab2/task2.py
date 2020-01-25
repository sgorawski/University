import sys
import collections
from enum import Enum

import solver


class Movement(Enum):
    # up and down reversed because board is loaded top to bottom
    U = 0, -1
    D = 0, 1
    L = -1, 0
    R = 1, 0
    
    def add_to(self, position):
        x, y = position
        dx, dy = self.value
        return x + dx, y + dy


class Sokoban:

    def __init__(self, initial_state, walls, destinations):
        self.initial_state = initial_state
        self.walls = walls
        self.destinations = destinations

    def gen_new_states(self, state):
        player, crates_ordered = state
        crates = set(crates_ordered)
        for movement in Movement:
            new_player = movement.add_to(player)
            if new_player in self.walls:
                continue
            if new_player in crates:
                if movement.add_to(new_player) in self.walls | crates:
                    # cannot push crate into wall or another crate
                    continue
                new_crates = crates - {new_player} | {movement.add_to(new_player)}
            else:
                new_crates = crates
            yield (new_player, tuple(sorted(new_crates))), movement.name

    def is_a_win(self, state):
        _, crates_ordered = state
        return set(crates_ordered) == self.destinations
    
    def get_heuristic(self, state):
        _, crates_ordered = state
        return max(
            min(abs(cx - x) + abs(cy - y) for x, y in self.destinations)
            for cx, cy in crates_ordered
        )

    def gen_new_states_with_priority(self, state_with_priority):
        """Wrapper for A*"""
        (_, cost), state = state_with_priority
        cost += 1
        for new_state, action in self.gen_new_states(state):
            heuristic = self.get_heuristic(new_state)
            yield ((heuristic + cost, cost), new_state), action

    @classmethod
    def from_map(cls, board):
        objects = collections.defaultdict(set)

        for y, row in enumerate(board):
            for x, tile in enumerate(row):
                objects[tile].add((x, y))
            
        player = next(iter(objects['K'] | objects['+']))
        crates = tuple(sorted(objects['B'] | objects['*']))
        return cls(
            initial_state=(player, crates),
            walls=objects['W'],
            destinations=objects['G'] | objects['*'] | objects['+'],
        )


if __name__ == '__main__':
    with open('zad_input.txt') as inp:
        game = Sokoban.from_map(inp)

    if '--a-star' in sys.argv:
        solution = solver.find_solution_with_priority(
            root=((0, 0), game.initial_state),
            is_goal=game.is_a_win,
            get_successors=game.gen_new_states_with_priority,
        )
    else:
        solution = solver.find_solution(
            root=game.initial_state,
            is_goal=game.is_a_win,
            get_successors=game.gen_new_states,
        )

    solution_str = ''.join(solution)
    print(solution_str, len(solution_str))  # for insight

    with open('zad_output.txt', 'w+') as out:
        out.write(solution_str)
