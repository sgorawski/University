% A Jinja2 Prolog template for simple constraint problems
% with {0, 1} variables domain.

:- use_module(library(clpfd)).

solve(Vs) :-
	Vs = {{ variables }},
	Vs ins 0..1,
	{% for constraint in constraints -%}
		{{ constraint }},
	{% endfor -%}
	label(Vs).

:- solve(X), write(X), nl.
