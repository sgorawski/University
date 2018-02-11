from formula import Formula


class T(Formula):
    def __str__(self):
        return "⊤"

    def evaluate(self, _):
        return True


class F(Formula):
    def __str__(self):
        return "⊥"

    def evaluate(self, _):
        return False


class Var(Formula):
    def __init__(self, name):
        self.name = name

    def __str__(self):
        return self.name

    def evaluate(self, vars_values):
        try:
            return vars_values[self.name]
        except KeyError:
            throw ValueError("Variable %s has no defined value" % self.name)
