% Definiujemy moduł zawierający testy.
% Należy zmienić nazwę modułu na {imie}_{nazwisko}_tests gdzie za
% {imie} i {nazwisko} należy podstawić odpowiednio swoje imię
% i nazwisko bez wielkich liter oraz znaków diakrytycznych
:- module(slawomir_gorawski_tests, [tests/3]).

% Zbiór faktów definiujących testy
% Należy zdefiniować swoje testy
tests(empty_program, input(""), program([])).
tests(invalid, input("def main()"), no).
tests(adder, file('adder.hdml'), yes).
tests(srcpos, input("def main(_) = 1"),
  program([def(main, wildcard(file(test, 1, 10, 9, 1)), num(no, 1))])).

% testy analizujace input - wszystkie wyrazenia
tests(if, input("def main(_) = if 1 then 2 else 3"),
      program([def(main, wildcard(no), if(no, num(no, 1), num(no, 2), num(no, 3)))])).
tests(let, input("def main(_) = let P = 1 in 2"),
      program([def(main, wildcard(no), let(no, 'P', num(no, 1), num(no, 2)))])).
tests(op1, input("def main(_) = #1"),
      program([def(main, wildcard(no), op(no, '#', num(no, 1)))])).
tests(op2, input("def main(_) = 1 > 2"),
      program([def(main, wildcard(no), op(no, '>', num(no, 1), num(no, 2)))])).
tests(pair, input("def main(_) = 1, 2"),
      program([def(main, wildcard(no), pair(no, num(no, 1), num(no, 2)))])).
tests(bitsel1, input("def main(_) = 1[2]"),
      program([def(main, wildcard(no), bitsel(no, num(no, 1), num(no, 2)))])).
tests(bitsel2, input("def main(_) = 1[2..3]"),
      program([def(main, wildcard(no), bitsel(no, num(no, 1), num(no, 2), num(no, 3)))])).
tests(call, input("def main(_) = main(1)"),
      program([def(main, wildcard(no), call(no, main, num(no, 1)))])).
tests(var, input("def main(_) = X"),
      program([def(main, wildcard(no), var(no, 'X'))])).
tests(num, input("def main(_) = 1"),
      program([def(main, wildcard(no), num(no, 1))])).
tests(empty, input("def main(_) = []"),
      program([def(main, wildcard(no), empty(no))])).
tests(bit, input("def main(_) = [1]"),
      program([def(main, wildcard(no), bit(no, num(no, 1)))])).

% testy na zewnetrzne pliki
tests(ext_valid, file('valid.hdml'), yes).
tests(ext_invalid, file('invalid.hdml'), no).
tests(ext_multiple_defs, file('multiple_defs.hdml'), yes).