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
    whiteTurn(Board, BoardWhite1, Player2),
    whiteTurn(BoardWhite1, BoardWhite2, Player2),
    blackTurn(BoardWhite2, BoardBlack1, Player1),
    blackTurn(BoardBlack1, BoardBlack2, Player1),
    game(BoardBlack2, Player1, Player2).

whiteTurn(Board, FinalBoard, Player2) :-
    repeat,
    move(Board, FinalBoard, white, Player2).

blackTurn(Board, FinalBoard, Player1) :-
    repeat,
    move(Board, FinalBoard, black, Player1).

move(Board, FinalBoard, Color, Player) :-
    readCoordinates(CRow, CColumn, 'Current'),
    checkPosition(CRow, CColumn, Color, Board),
    readCoordinates(NRow, NColumn, 'New'),
    checkMove(CRow, CColumn, NRow, NColumn, Color, Board, FinalBoard),
    display_game(FinalBoard, Player, Color).

readCoordinates(Row, Column, Status) :-
    once(readRow(Row, Status)),
    once(readColumn(Column, Status)).
