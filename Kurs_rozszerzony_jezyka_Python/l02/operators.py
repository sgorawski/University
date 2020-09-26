from formula import Formula


class Not(Formula):
    def __init__(self, expr):
        self.expr = expr

    def __str__(self):
        return "¬%s" % self.expr

    def evaluate(self, vars_values):
        return not self.expr.evaluate(vars_values)


class And(Formula):
    def __init__(self, left_expr, right_expr):
        self.left_expr = left_expr
        self.right_expr = right_expr

    def __str__(self):
        return "(%s ∧ %s)" % (self.left_expr, self.right_expr)

    def evaluate(self, vars_values):
        return (
            self.left_expr.evaluate(vars_values)
            and self.right_expr.evaluate(vars_values)
        )


class Or(Formula):
    def __init__(self, left_expr, right_expr):
        self.left_expr = left_expr
        self.right_expr = right_expr

    def __str__(self):
        return "(%s ∨ %s)" % (self.left_expr, self.right_expr)

    def evaluate(self, vars_values):
        return (
            self.left_expr.evaluate(vars_values)
            or self.right_expr.evaluate(vars_values)
        )


class Implies(Formula):
    def __init__(self, left_expr, right_expr):
        self.left_expr = left_expr
        self.right_expr = right_expr

    def __str__(self):
        return "(%s ⇒ %s)" % (self.left_expr, self.right_expr)

    def evaluate(self, vars_values):
        return (
            (not self.left_expr.evaluate(vars_values))
            or self.right_expr.evaluate(vars_values)
        )


class Equivalence(Formula):
    def __init__(self, left_expr, right_expr):
        self.left_expr = left_expr
        self.right_expr = right_expr

    def __str__(self):
        return "(%s ⇔ %s)" % (self.left_expr, self.right_expr)

    def evaluate(self, vars_values):
        return (
            (
                self.left_expr.evaluate(vars_values)
                and self.right_expr.evaluate(vars_values)
            ) or (
                (not self.left_expr.evaluate(vars_values))
                and (not self.right_expr.evaluate(vars_values))
            )
        )
