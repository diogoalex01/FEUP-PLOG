clearScreen :-
	write('\33\[2J').

getChar(Input) :-
  get_char(Input),
  get_char(_).

pressEnter :-
  write('Press <ENTER> to continue.\n\n'),
  get_char(_).

% reads coordinates (Row, Column)
readCoordinates(Row, Column, Status) :-
  once(readRow(Row, Status)),
  once(readColumn(Column, Status)).

% verifies if a given coordinate is inside the board
checkLimits(Row, Column) :-
  (
    Row > 0,
    Row < 6,
    Column > 0,
    Column < 6
    ;
    fail
).

genPosition(Row, Column) :-
  member(Row, [1, 2, 3, 4, 5]),
  member(Column, [1, 2, 3, 4, 5]).
  