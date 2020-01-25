from queue import Queue, PriorityQueue


def construct_path(state, meta):
    actions = []
    while state in meta:
        state, action = meta[state]
        actions.append(action)
    actions.reverse()
    return actions


def find_solution(root, is_goal, get_successors):
    to_visit = Queue()
    visited = {root}
    meta = {}

    to_visit.put(root)

    while not to_visit.empty():
        sub_root = to_visit.get()
        if is_goal(sub_root):
            return construct_path(sub_root, meta)

        for child, action in get_successors(sub_root):
            if child in visited:
                continue
            meta[child] = (sub_root, action)
            to_visit.put(child)
            visited.add(child)


def find_solution_with_priority(root, is_goal, get_successors):
    _, state = root
    to_visit = PriorityQueue()
    visited = {state}
    meta = {}

    to_visit.put(root)

    while not to_visit.empty():
        sub_root = to_visit.get()
        _, state = sub_root
        if is_goal(state):
            return construct_path(state, meta)

        for (priority, child), action in get_successors(sub_root):
            if child in visited:
                continue
            meta[child] = (state, action)
            to_visit.put((priority, child))
            visited.add(child)
