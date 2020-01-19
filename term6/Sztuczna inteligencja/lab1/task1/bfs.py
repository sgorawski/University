from queue import Queue


class Problem:

    def __init__(self, get_root, is_goal, get_successors):
        self.get_root = get_root
        self.is_goal = is_goal
        self.get_successors = get_successors


def construct_path(state, meta):
    actions = []
    while state in meta:
        state, action = meta[state]
        actions.append(action)
    actions.reverse()
    return actions


def find_solution(problem):
    to_visit = Queue()
    visited = set()
    meta = {}

    root = problem.get_root()
    to_visit.put(root)

    while not to_visit.empty():
        sub_root = to_visit.get()
        print(root, sub_root, problem.is_goal(sub_root), sep='\n')
        if problem.is_goal(sub_root):
            return construct_path(sub_root, meta)

        for child, action in problem.get_successors(sub_root):
            if child in visited:
                continue
            meta[child] = (sub_root, action)
            to_visit.put(child)

        visited.add(sub_root)
