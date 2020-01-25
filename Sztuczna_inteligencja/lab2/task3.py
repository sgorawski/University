from queue import Queue

import task2
import solver


class HigherLevelSokoban:

    def __init__(self, lower_level_sokoban):
        self.lower_level_sokoban = lower_level_sokoban

    def gen_new_states_with_priority(self, state_with_priority):
        _, state = state_with_priority
        # print('here')
        for new_state, action in self.get_possible_changes(state):
            heuristic = self.get_heuristic(new_state)
            yield (heuristic, new_state), action
        
    def get_heuristic(self, state):
        _, crates_ordered = state
        return max(
            min(abs(cx - x) + abs(cy - y) for x, y in self.lower_level_sokoban.destinations)
            for cx, cy in crates_ordered
        )

    def get_possible_changes(self, state):
        """Basically a BFS but finds all goals instead of the first one."""
        pos, crates_ordered = state
        crates = set(crates_ordered)

        to_visit = Queue()
        visited = {state}
        
        to_visit.put((pos, ''))

        while not to_visit.empty():
            sub_root, solution = to_visit.get()
            #print(sub_root, visited)
            if sub_root in self.lower_level_sokoban.walls:
                continue

            if sub_root in crates:
                move = task2.Movement[solution[-1]]
                if move.add_to(sub_root) not in self.lower_level_sokoban.walls | crates:
                    yield (sub_root, tuple(sorted(crates - {sub_root} | {move.add_to(sub_root)}))), solution
                continue
            
            for movement in task2.Movement:
                child = movement.add_to(sub_root)
                if child in visited:
                    continue
                to_visit.put((child, solution + movement.name))
                visited.add(child)


if __name__ == '__main__':
    with open('zad_input.txt') as inp:
        lower_level_sokoban = task2.Sokoban.from_map(inp)
        game = HigherLevelSokoban(lower_level_sokoban)

    solution = solver.find_solution_with_priority(
        root=(0, lower_level_sokoban.initial_state),
        is_goal=lower_level_sokoban.is_a_win,
        get_successors=game.gen_new_states_with_priority,
    )  # Best-First search in this case

    solution_str = ''.join(solution)
    print(solution_str, len(solution_str))  # for insight

    with open('zad_output.txt', 'w+') as out:
        out.write(solution_str)
