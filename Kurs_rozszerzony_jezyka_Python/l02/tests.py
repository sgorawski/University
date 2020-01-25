from operators import Not, And, Or, Implies, Equivalence
from variables import T, F, Var
from checker import is_tautology, values_variations


def test_for_all_values(formula, vars_list):
    print("\nTESTING %s" % formula)
    for val_list in values_variations(len(vars_list)):
        vars_values = dict(zip(vars_list, val_list))
        print("%s - %s" % (vars_values, formula.evaluate(vars_values)))
    print("Tautology - %s\n" % is_tautology(formula, vars_list))


task_form = Implies(Var('p'), And(Var('q'), T()))
test_for_all_values(task_form, ['p', 'q'])


simple_tautology = Or(Var('p'), Not(Var('p')))
test_for_all_values(simple_tautology, ['p'])


test_form_1 = Implies(Var('p'), Or(Var('p'), Var('q')))
test_for_all_values(test_form_1, ['p', 'q'])


test_form_2 = Implies(Implies(Var('p'), Var('q')), Var('q'))
test_for_all_values(test_form_2, ['p', 'q'])


test_form_3 = Equivalence(Not(Implies(Var('p'), Var('q'))),
                          And(Var('p'), Not(Var('q'))))
test_for_all_values(test_form_3, ['p', 'q'])
