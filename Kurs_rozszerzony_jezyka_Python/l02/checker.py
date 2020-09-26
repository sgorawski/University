def values_variations(length):
    """
    Function to generate all possible variations of True and False
    of the given length - used to value variables
    """
    if length <= 0:
        return [[]]
    return (
        [*prev, new]
        for prev in values_variations(length - 1)
        for new in [True, False]
    )


def is_tautology(formula, vars_list):
    for val_list in values_variations(len(vars_list)):
        vars_values = dict(zip(vars_list, val_list))
        if not formula.evaluate(vars_values):
            return False
    return True
