clear_screen :-
	write('\33\[2J').

get_character(Input) :-
  get_char(Input),
  get_char(_).

press_enter :-
  write('Press <ENTER> to continue.\n\n'),
  get_char(_).

% pieces
% ------------------------

set_piece(Row, Column, Piece, TabIn, TabOut) :-
  set_row(Row, Column, Piece, TabIn, TabOut).

% rows
% ------------------------

set_row(1, Column, Piece, [Row|More], [NovaRow|More]) :-
  set_column(Column, Piece, Row, NovaRow).

set_row(N, Column, Piece, [Row|Tail], [Row|NewTail]) :-
  N > 1,
  Next is N - 1,
  set_row(Next, Column, Piece, Tail, NewTail).

% columns
% ------------------------

set_column(1, Piece, [_|More], [Piece|More]).

set_column(N, Piece, [X|Tail], [X|NewTail]) :-
  N > 1,
  Next is N - 1,
  set_column(Next, Piece, Tail, NewTail).

% generates sequential value for the Row and Column argument
gen_position(Row, Column) :-
  member(Row, [1, 2, 3, 4, 5, 6]),
  member(Column, [1, 2, 3, 4, 5]).

%%

%get_row(1, [_Row|_More]).
%get_row(N, [_Row|Tail]) :-
%  N > 1,
%  Next is N - 1,
%  get_row(Next, Tail).

% ------------

%get_column(1, [_Current|_More]).
%get_column(N, [_X|Tail]) :-
%  N > 1,
%  Next is N - 1,
%  get_column(Next, Tail).

% ------------

split_at(N, List, [H|[T]]) :-
  append(H, T, List),
  length(H, N).

divide([], _, _).
divide(List, Split, [Head|Rest]) :-
  split_at(Split, List, [Head, Remainder]),
  divide(Remainder, Split, Rest).

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

replace(_, _, [], []).
replace(O, R, [O|T], [R|T2]) :- replace(O, R, T, T2).
replace(O, R, [H|T], [H|T2]) :- H \= O, replace(O, R, T, T2).