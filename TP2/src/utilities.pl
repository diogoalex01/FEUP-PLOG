clearScreen :-
	write('\33\[2J').

getChar(Input) :-
  get_char(Input),
  get_char(_).

pressEnter :-
  write('Press <ENTER> to continue.\n\n'),
  get_char(_).

% pieces
% ------------------------

setPiece(Row, Column, Piece, TabIn, TabOut) :-
    setRow(Row, Column, Piece, TabIn, TabOut).

% rows
% ------------------------

setRow(1, Column, Piece, [Row|More], [NovaRow|More]) :-
    setColumn(Column, Piece, Row, NovaRow).

setRow(N, Column, Piece, [Row|Tail], [Row|NewTail]) :-
    N > 1,
    Next is N - 1,
    setRow(Next, Column, Piece, Tail, NewTail).

% columns
% ------------------------

setColumn(1, Piece, [_|More], [Piece|More]).

setColumn(N, Piece, [X|Tail], [X|NewTail]) :-
    N > 1,
    Next is N - 1,
    setColumn(Next, Piece, Tail, NewTail).

% generates sequential value for the Row and Column argument
genPosition(Row, Column) :-
  member(Row, [1, 2, 3, 4, 5, 6]),
  member(Column, [1, 2, 3, 4, 5]).

selRandom(ListOfVars, Var, Rest) :-
  random_select(Var, ListOfVars, Rest).