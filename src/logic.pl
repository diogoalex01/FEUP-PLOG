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

game(Board, Player1, Player2) :-
    whiteTurn(Board, MidBoard, Player2),
    blackTurn(MidBoard, FinalBoard, Player1),
    game(FinalBoard, Player1, Player2).


whiteTurn(Board, FinalBoard, Player2) :-
    repeat,
    once(readRow(CRow, 'Current')),
    once(readColumn(CColumn, 'Current')),
    checkPosition(CRow, CColumn, white, Board),
    once(readRow(NRow, 'New')),
    once(readColumn(NColumn, 'New')),
    checkPosition(NRow, NColumn, '     ', Board),
    setPiece(CRow, CColumn, '     ', Board, MidBoard),
    setPiece(NRow, NColumn, white, MidBoard, FinalBoard),
    display_game(FinalBoard, Player2).

blackTurn(Board, FinalBoard, Player1) :-
    repeat,
    once(readRow(CRow, 'Current')),
    once(readColumn(CColumn, 'Current')),
    checkPosition(CRow, CColumn, black, Board),
    once(readRow(NRow, 'New')),
    once(readColumn(NColumn, 'New')),
    checkPosition(NRow, NColumn, '     ', Board),
    setPiece(CRow, CColumn, '     ', Board, MidBoard),
    setPiece(NRow, NColumn, black, MidBoard, FinalBoard),
    display_game(FinalBoard, Player1).

