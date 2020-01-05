clear_screen :-
	write('\33\[2J').

get_character(Input) :-
  get_char(Input),
  get_char(_).

press_enter :-
  write('Press <ENTER> to continue.\n\n'),
  get_char(_).

% makes empty cells on the board (' ') a variable
make_vars(' ', _) :- !.
make_vars(X, X).

% -------- Lists -------- %

% splits List at index N
split(N, List, [H|[T]]) :-
  append(H, T, List),
  length(H, N).

% divides List in Split fragments
divide([], _, _).
divide(List, Split, [Head|Rest]) :-
  split(Split, List, [Head, Remainder]),
  divide(Remainder, Split, Rest).

% replace elment of list O for R
replace(_, _, [], []).
replace(Src, Dest, [Src|T], [Dest|T2]) :- replace(Src, Dest, T, T2).
replace(Src, Dest, [H|T], [H|T2]) :- 
  H \= Src,
  replace(Src, Dest, T, T2).

% replaces B1, B2 and B3 from list Vars for A1, A2, A3 to list FFFVars
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

% transforms a given matrix in a list L
flatten_list([], []).
flatten_list([H|T], L) :-
  \+(is_list(H)),
  flatten_list(T, NL),
  append([H], NL, L).
flatten_list([H|T], L) :-
  is_list(H),
  flatten_list(T, NL),
  append(H, NL, L).

% get column at Index of a matrix
get_column([], _, []).
get_column([H|T], Index, [R|X]) :-
  get_row(H, Index, R),
  get_column(T, Index, X).

get_row([H|_], 1, H) :- !.
get_row([_|T], Index, X) :-
  NIndex is Index - 1,
  get_row(T, NIndex, X).

reset_timer :- statistics(total_runtime, _).
print_time(Msg) :-
  statistics(total_runtime, [_, T]),
  TS is ((T//10) * 10) / 1000,
  write(Msg), write(TS), write('s'), nl.