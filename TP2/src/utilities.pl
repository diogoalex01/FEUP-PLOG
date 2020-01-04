clear_screen :-
	write('\33\[2J').

get_character(Input) :-
  get_char(Input),
  get_char(_).

press_enter :-
  write('Press <ENTER> to continue.\n\n'),
  get_char(_).

% ------------

% splits List at index N
split_at(N, List, [H|[T]]) :-
  append(H, T, List),
  length(H, N).

% divides List in Split fragments
divide([], _, _).
divide(List, Split, [Head|Rest]) :-
  split_at(Split, List, [Head, Remainder]),
  divide(Remainder, Split, Rest).

% randomnly choose a solution
my_sel(Var, _, BB0, BB1) :-
  fd_set(Var, Set),
  fdset_to_list(Set, List),
  random_member(Value, List),
  ( 
    first_bound(BB0, BB1),
    Var #= Value
    ;
    later_bound(BB0, BB1),
    Var #\= Value
  ).

% replace elment of list O for R
replace(_, _, [], []).
replace(O, R, [O|T], [R|T2]) :- replace(O, R, T, T2).
replace(O, R, [H|T], [H|T2]) :- H \= O, replace(O, R, T, T2).

replaceAll(B1, B2, B3, A1, A2, A3, Vars, FFFVars) :-
  replace(B1, A1, Vars, FVars),
  replace(B2, A2, FVars, FFVars),
  replace(B3, A3, FFVars, FFFVars).

% replaces an element E at a given index N
replace_at_index([_|T], 1, E, [E|T]).
replace_at_index([H|T], N, E, [H|R]) :-
  N > 1,
  Next is N - 1,
  replace_at_index(T, Next, E, R).

% makes empty cells on the board ('     ') a variable
make_vars('     ', _) :- !.
make_vars(X, X).

% -------- Lists -------- %

flatten_list([], []).
flatten_list([H|T], L) :- \+(is_list(H)), flatten_list(T, NL), append([H], NL, L).
flatten_list([H|T], L) :- is_list(H), flatten_list(T, NL), append(H, NL, L).

get_column([], _, []).
get_column([H|T], Index, [R|X]) :-
  get_row(H, Index, R),
  get_column(T, Index, X).

get_row([H|_], 1, H) :- !.
get_row([_|T], Index, X) :-
  NIndex is Index - 1,
  get_row(T, NIndex, X).