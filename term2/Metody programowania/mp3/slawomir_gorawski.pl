:- module(slawomir_gorawski, [parse/3]).

% HELPER PREDICATES
is_empty([]).

% -----INPUT PROCESSING-----
% 
% 
% LEXER - INPUT TOKENIZATION
lexer(Token_list) -->
    whitespaces, !,
    lexer(Token_list).
lexer(Token_list) -->
    comment, !,
    lexer(Token_list).
lexer([Token|Token_list]) -->
    token(Token), !,
    lexer(Token_list).
lexer([]) --> [].

% WHITESPACE REMOVAL
whitespaces -->
    whitespace,
    whitespaces, !.
whitespaces --> whitespace.

whitespace --> [W],
    { member(W, [9, 10, 11, 12, 13, 32]) }.

% COMMENTS REMOVAL
comment --> [40], [42],
    comment(1).
comment(0) --> [], !.
comment(X) --> [40], [42], !,
    { X1 is X + 1 },
    comment(X1).
comment(X) --> [42], [41], !,
    { X1 is X - 1 },
    comment(X1).
comment(X) --> [_],
    comment(X).

% TOKENS PARSING
token(Op) --> operator(Op), !.
token(Num) --> number(Num), !.
token(Keyword) --> keyword(Keyword), !.
token(Id) --> id(Id).

% OPERATOR CLASSIFICATION
% signs
operator(t_sign('(')) --> [40], !.
operator(t_sign(')')) --> [41], !.
operator(t_sign('[')) --> [91], !.
operator(t_sign(']')) --> [93], !.
operator(t_sign('..')) --> [46], [46], !.
% binary operators with priorities
operator(t_bin_op(1, ',')) --> [44], !.
operator(t_bin_op(2, '=')) --> [61], !.
operator(t_bin_op(2, '<>')) --> [60], [62], !.
operator(t_bin_op(2, '<')) --> [60], !.
operator(t_bin_op(2, '>')) --> [62], !.
operator(t_bin_op(2, '<=')) --> [60], [61], !.
operator(t_bin_op(2, '>=')) --> [62], [61], !.
operator(t_bin_op(3, '@')) --> [64], !.
operator(t_bin_op(4, '^')) --> [94], !.
operator(t_bin_op(4, '|')) --> [124], !.
operator(t_bin_op(4, '+')) --> [43], !.
operator(t_bin_op(5, '&')) --> [38], !.
operator(t_bin_op(5, '*')) --> [42], !.
operator(t_bin_op(5, '/')) --> [47], !.
operator(t_bin_op(5, '%')) --> [37], !.
% unary operators
operator(t_un_op('#')) --> [35], !.
operator(t_un_op('~')) --> [126], !.
% both binary and unary operator
operator(t_bin_op(4, '-')) --> [45].

% NUMBER RECOGNITION
number(t_num(N)) -->
    digits(Digit_list),
    { \+is_empty(Digit_list),
      number_codes(N, Digit_list) }.

digits([Digit|Digit_list]) -->
    digit(Digit), !,
    digits(Digit_list).
digits([]) --> [].

digit(D) --> [D],
    { code_type(D, digit) }.

% KEYWORD RECOGNITION
% keywords
keyword(t_kw(def)) --> [100], [101], [102], !.
keyword(t_kw(else)) --> [101], [108], [115], [101], !.
keyword(t_kw(if)) --> [105], [102], !.
keyword(t_kw(in)) --> [105], [110], !.
keyword(t_kw(let)) --> [108], [101], [116], !.
keyword(t_kw(then)) --> [116], [104], [101], [110], !.
% wildcard
keyword(t_wildc) --> [95].

% ID PARSING
id(t_id(Id)) -->
    letter_or_underscore(First_code),
    rest_of_id(Code_list),
    { atom_codes(Id, [First_code|Code_list]) }.

letter_or_underscore(95) --> [95], !.
letter_or_underscore(L) --> [L],
    { code_type(L, alpha) }.

rest_of_id([Code|Code_list]) -->
    id_char(Code), !,
    rest_of_id(Code_list).
rest_of_id([]) --> [].

id_char(C) -->
    letter_or_underscore(C), !.
id_char(C) -->
    number_or_apostrophe(C).

number_or_apostrophe(39) --> [39], !.
number_or_apostrophe(N) --> [N],
    { code_type(N, digit) }.
% -----END OF INPUT PROCESSING-----


% -----PROCESSED INPUT PARSER-----
% 
% 
% PROGRAM DCG
program(Tree_list) -->
    definitions(Tree_list).

% DEFINITIONS DCG
definitions([Def_tree|Tree_list]) -->
    definition(Def_tree), !,
    definitions(Tree_list).
definitions([]) --> [].

% DEFINITION DCG
definition(def(Name, Pat, Exp)) -->
    [t_kw(def)],
    [t_id(Name)],
    [t_sign('(')],
    pattern(Pat),
    [t_sign(')')],
    [t_bin_op(_, '=')],
    expression(Exp).

% PATTERN DCG
pattern(pair(no, P1, P2)) -->
    simple_pattern(P1),
    [t_bin_op(_, ',')], !,
    pattern(P2).
pattern(Var) -->
    simple_pattern(Var).
simple_pattern(wildcard(no)) -->
    [t_wildc], !.
simple_pattern(Pat) -->
    [t_sign('(')], !,
    pattern(Pat),
    [t_sign(')')].
simple_pattern(Var) -->
    variable(Var).

% EXPRESSION DCG
expression(if(no, E1, E2, E3)) -->
    [t_kw(if)], !,
    expression(E1),
    [t_kw(then)],
    expression(E2),
    [t_kw(else)],
    expression(E3).
expression(let(no, P, E1, E2)) -->
    [t_kw(let)], !,
    pattern(P),
    [t_bin_op(_, '=')],
    expression(E1),
    [t_kw(in)],
    expression(E2).
expression(OpExp) -->
    op_exp(OpExp).

% OPERATOR EXPRESSION DCG
% binary operators
op_exp(Exp) -->
    op_exp_1(Exp).

% priority 1, right-associative, represented as pair
op_exp_1(pair(no, E1, E2)) -->
    op_exp_2(E1),
    [t_bin_op(1, _)], !,
    op_exp_1(E2).
op_exp_1(Exp) -->
    op_exp_2(Exp).

% priority 2, no associativity
op_exp_2(op(no, Op, E1, E2)) -->
    op_exp_3(E1),
    [t_bin_op(2, Op)], !,
    op_exp_3(E2).
op_exp_2(Exp) -->
    op_exp_3(Exp).

% priority 3, right-associative
op_exp_3(op(no, Op, E1, E2)) -->
    op_exp_4(E1),
    [t_bin_op(3, Op)], !,
    op_exp_3(E2).
op_exp_3(Exp) -->
    op_exp_4(Exp).

% priority 4, left-associative
op_exp_4(Exp) -->
    op_exp_5(A),
    [t_bin_op(4, Op)], !,
    op_exp_4(A, Op, Exp).
op_exp_4(Exp) -->
    op_exp_5(Exp).

op_exp_4(A, Prev_op, Exp) -->
    op_exp_5(E2),
    [t_bin_op(4, Op)], !,
    op_exp_4(op(no, Prev_op, A, E2), Op, Exp).
op_exp_4(A, Op, op(no, Op, A, Exp)) --> 
    op_exp_5(Exp).

% priority 5, left-associative
op_exp_5(Exp) -->
    un_op_exp(A),
    [t_bin_op(5, Op)], !,
    op_exp_5(A, Op, Exp).
op_exp_5(Exp) -->
    un_op_exp(Exp).

op_exp_5(A, Prev_op, Exp) -->
    un_op_exp(E2),
    [t_bin_op(5, Op)], !,
    op_exp_5(op(no, Prev_op, A, E2), Op, Exp).
op_exp_5(A, Op, op(no, Op, A, Exp)) --> 
    un_op_exp(Exp).

%unary operators
un_op_exp(op(no, Op, E)) -->
    [t_un_op(Op)], !,
    un_op_exp(E).
un_op_exp(op(no, '-', E)) -->
    [t_bin_op(4, '-')], !,
    un_op_exp(E).
un_op_exp(Exp) -->
    simple_exp(Exp).

% SIMPLE EXPRESSION DCG
simple_exp(Bitsel) -->
    bitsel(Bitsel), !.
simple_exp(Exp) -->
    simpler_exp(Exp).

% BIT SELECTION DCG
create_bitsel_atom(Pos, E1, (E2, E3), bitsel(Pos, E1, E2, E3)) :- !.
create_bitsel_atom(Pos, E1, E2, bitsel(Pos, E1, E2)).

bitsel(Atom) -->
    simpler_exp(SE),
    bitsel_sequence(BS),
    bitsel_modules(SE, BS, R, Last),
    { create_bitsel_atom(no, R, Last, Atom) }.

% 2 new
bitsel_modules(SE, BS, R, L) -->
    bitsel_sequence((NBS1, NBS2)), !,
    { create_bitsel_atom(no, SE, BS, Acc) },
    bitsel_modules(Acc, (NBS1, NBS2), R, L).
% 1 new
bitsel_modules(SE, BS, R, L) -->
    bitsel_sequence(NBS), !,
    { create_bitsel_atom(no, SE, BS, Acc) },
    bitsel_modules(Acc, NBS, R, L).
% end of recursion
bitsel_modules(SE, BS, SE, BS) --> [].

% helper predicate
bitsel_sequence((E1, E2)) -->
    [t_sign('[')],
    expression(E1),
    [t_sign('..')], !,
    expression(E2),
    [t_sign(']')].
bitsel_sequence(Exp) -->
    [t_sign('[')],
    expression(Exp),
    [t_sign(']')].

% avoiding infinite recursion
simpler_exp(Exp) -->
    [t_sign('(')], !,
    expression(Exp),
    [t_sign(')')].
simpler_exp(Exp) -->
    atomic_exp(Exp).

% ATOMIC EXPRESSION DCG
atomic_exp(bit(no, E)) -->
    [t_sign('[')],
    expression(E), !,
    [t_sign(']')].
atomic_exp(empty(no)) -->
    [t_sign('[')], !,
    [t_sign(']')].
atomic_exp(num(no, N)) -->
    [t_num(N)], !.
atomic_exp(call(no, Name, E)) -->
    [t_id(Name)],
    [t_sign('(')], !,
    expression(E),
    [t_sign(')')].
atomic_exp(Var) -->
    variable(Var).

% VARIABLE DCG
variable(var(no, X)) -->
    [t_id(X)].

% -----END OF PROCESSED INPUT PARSER-----

parse(_Path, Codes, Program) :-
    phrase(lexer(Token_list), Codes),
    phrase(program(Program), Token_list).