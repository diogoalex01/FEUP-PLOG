setPiece(Row, Column, Piece, TabIn, TabOut) :-
    setRow(Row, Column, Piece, TabIn, TabOut).

% rows
% ------------------------

setRow(1, Column, Piece, [Row|More], [NovaRow|More]) :-
    setColumn(Column, Piece, Row, NovaRow).

setRow(N, Column, Piece, [Row|Remnant], [Row|NewRemnant]) :-
    N > 1,
    Next is N - 1,
    setRow(Next, Column, Piece, Remnant, NewRemnant).

% columns
% ------------------------

setColumn(1, Piece, [_|More], [Piece|More]).

setColumn(N, Piece, [X|Remnant], [X|NewRemnant]) :-
    N > 1,
    Next is N - 1,
    setColumn(Next, Piece, Remnant, NewRemnant).

% ------------------------

move(Board) :-
    repeat,
    once(readRow(Row, NRow)),
    once(readColumn(Column, NColumn)),
    checkPosition(Row, Column, 'white', Board),
    setPiece(Row, Column, '     ', Board, NewBoard),
    checkPosition(NRow, NColumn, '     ', Board),
    setPiece(Row, Column, white, Board, NewBoard),
    display_game(NewBoard, '1 :'),

    once(readRow(Row, NRow)),
    once(readColumn(Column, NColumn)),
    checkPosition(Row, Column, 'black', Board),
    setPiece(Row, Column, '     ', Board, NewBoard),
    checkPosition(NRow, NColumn, '     ', Board),
    setPiece(Row, Column, black, Board, NewBoard),
    display_game(NewBoard, '2 :').
