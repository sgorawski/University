:- use_module(library(clpfd)).

clabel([]).
clabel([H|T]) :- indomain(H), clabel(T).

cindomain(X) :- fd_dom(X, D), di(D, X).

di(A..B, I) :- !, numlist(A, B, L), di(L, I).
di([], _) :- !, fail.
di([H|_], I) :- di(H, I).
di([_|T], I) :- !, di(T, I).
di(X\/_, I) :- !, di(X, I).
di(_\/X, I) :- !, di(X, I).
di(D, D) :- integer(D).
