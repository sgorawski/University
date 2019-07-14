from queue import Queue

import task2
import task4
import solver


class HigherLevelCommando:

    def __init__(self, lower_level_commando):
        self.lower_level_commando = lower_level_commando
        self.real_distances = self.compute_real_distances()
    
    def gen_new_states_with_priority(self, state_with_priority):
        (_, cost), state = state_with_priority
        cost += 1
        for new_state, action in self.lower_level_commando.gen_new_states(state):
            heuristic = self.get_heuristic(new_state)
            yield ((heuristic + cost, cost), new_state), action
    
    def get_heuristic(self, state):
        return max(
            min(self.real_distances[dest][(sx, sy)] for dest in self.lower_level_commando.destinations)
            for sx, sy in state
        )

    def compute_real_distances(self):
        distances = {}
        for root in self.lower_level_commando.destinations:
            to_this_dest = {root: 0}

            to_visit = Queue()
            visited = {root}

            to_visit.put((root, 0))

            while not to_visit.empty():
                sub_root, cost = to_visit.get()
                to_this_dest[sub_root] = cost
                cost += 1

                for movement in task2.Movement:
                    child = movement.add_to(sub_root)
                    if (
                        child in self.lower_level_commando.walls
                        or child in visited
                    ):
                        continue
                    to_visit.put((child, cost))
                    visited.add(child)
            distances[root] = to_this_dest
        return distances


if __name__ == '__main__':
    with open('zad_input.txt') as inp:
        lower_level_commando = task4.Commando.from_map(inp)
        game = HigherLevelCommando(lower_level_commando)
    
    solution = solver.find_solution_with_priority(
        root=((0, 0), lower_level_commando.initial_state),
        is_goal=lower_level_commando.is_a_win,
        get_successors=game.gen_new_states_with_priority,
    )

    solution_str = ''.join(solution)
    print(solution_str, len(solution_str))

    with open('zad_output.txt', 'w+') as out:
        out.write(solution_str)
