from queue import Queue
import collections
import random

import task2
import solver


MAX_UNCERTAINTY = 2
MAX_NUM_ACTIONS = 150


class Commando:

    def __init__(self, initial_state, walls, destinations):
        self.initial_state = initial_state
        self.walls = walls
        self.destinations = destinations
    
    def gen_new_states(self, state):
        return (
            (tuple(sorted(self.move(movement, state))), movement.name)
            for movement in task2.Movement
        )
    
    def is_a_win(self, state):
        return all(pos in self.destinations for pos in state)
    
    def reduce_uncertainty(self):
        state = set(self.initial_state)
        movements = []

        movement = collections.namedtuple('temp', 'value')((0, 0))
        while len(state) > MAX_UNCERTAINTY:
            movement = random.choice([
                m for m in task2.Movement
                if m.add_to(movement.value) != (0, 0)
            ])
            state = self.move(movement, state)
            movements.append(movement.name)

        return tuple(sorted(state)), ''.join(movements)
    
    def move(self, movement, state):
        return {
            movement.add_to(pos)
            if movement.add_to(pos) not in self.walls
            else pos
            for pos in state
        }

    @classmethod
    def from_map(cls, board):
        objects = collections.defaultdict(set)

        for y, row in enumerate(board):
            for x, tile in enumerate(row):
                objects[tile].add((x, y))
        
        state = objects['S'] | objects['B']
        return cls(
            initial_state=tuple(sorted(state)),
            walls=objects['#'],
            destinations=objects['G'] | objects['B'],
        )


if __name__ == '__main__':
    with open('zad_input.txt') as inp:
        game = Commando.from_map(inp)
    
    while True:
        try:
            root, random_movements = game.reduce_uncertainty()

            to_visit = Queue()
            visited = {root}

            to_visit.put((root, ''))

            while not to_visit.empty():
                sub_root, solution = to_visit.get()
                if game.is_a_win(sub_root):
                    break
                if len(solution) > MAX_NUM_ACTIONS - len(random_movements):
                    raise Exception

                for child, action in game.gen_new_states(sub_root):
                    if child in visited:
                        continue
                    to_visit.put((child, solution + action))
                    visited.add(child)
                    
        except Exception:
            pass
        else:
            break
    
    solution_str = random_movements + solution
    print(random_movements, solution, len(solution_str))

    with open('zad_output.txt', 'w+') as out:
        out.write(solution_str)
