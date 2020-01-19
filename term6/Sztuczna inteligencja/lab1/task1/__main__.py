import bfs
import chess

DEBUG = True


with open('zad1_input.txt', 'r') as inp, open('zad1_output.txt', 'w+') as out:
    for line in inp:
        problem = bfs.Problem(
            get_root=lambda: chess.get_initial_state(line),
            is_goal=chess.is_checkmate,
            get_successors=chess.get_next_states,
        )
        actions = bfs.find_solution(problem)
        if DEBUG:
            print(line, *actions, sep='\n')
        out.write(f'{len(actions)}\n')
