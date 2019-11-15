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

% generates sequential value for the Row and Column argument
genPosition(Row, Column) :-
  member(Row, [1, 2, 3, 4, 5]),
  member(Column, [1, 2, 3, 4, 5]).
  
% randomly selects one of the possible boards
getBoard(Win, Other, BoardAI, GameLevel) :-
  length(Win, X),
  (
    GameLevel == 1,
    join_lists(Win, Other, Boards),
    random_select(BoardAI, Boards, _)
    ;
    (
    %write('30'),
    %write('\n Win: '), write(X), nl,
    %write('31'),
    X \== 0,
    %write('32'),
    random_select(BoardAI, Win, _)
    ;
    %write('33'),
    random_select(BoardAI, Other, _)
    %write('34')
    )
  ).


% finds coordinates of new positions for nudges (symmetric)
findCoordinates(Row, Column, ARow, AColumn, NRow, NColumn) :-
  NRow is 2 * ARow - Row,
  NColumn is 2 * AColumn - Column.

pieceCounter(Board, FinalBoard, Color) :-
    genPosition(Row, Column),
    checkPosition(Row, Column, Color, Board),
    FinalBoard = Board.

join_lists([], L, L).
join_lists([X|L1], L2, [X|L3]) :- 
  join_lists(L1, L2, L3).
