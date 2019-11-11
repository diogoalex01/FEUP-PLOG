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

game(Board, Player1, Player2, GameStatus) :-
(
    write('1--\n'),
    whiteTurn(Board, Board, BoardWhite1, Player1, GameStatus),
    write('2--\n'),
    write('GSF: '), write(GameStatus), nl,
    GameStatus \== 1,
    whiteTurn(Board, BoardWhite1, BoardWhite2, Player2, GameStatus),
    write('3--\n'),
    GameStatus \== 1,
    blackTurn(BoardWhite1, BoardWhite2, BoardBlack1, Player2, GameStatus),
    write('4--\n'),
    GameStatus \== 1,
    blackTurn(BoardWhite2, BoardBlack1, BoardBlack2, Player1, GameStatus),
    write('5--\n'),
    GameStatus \== 1,
    write('6--\n'),
    game(BoardBlack2, Player1, Player2, GameStatus),
    write('7--\n')
    ;
    write(' HELLLLLLLO\n\n'),
    !
).

whiteTurn(PreviousBoard, Board, FinalBoard, Player, GameStatus) :-
    move(PreviousBoard, Board, FinalBoard, white, black, Player, GameStatus).

blackTurn(PreviousBoard, Board, FinalBoard, Player, GameStatus) :-
    move(PreviousBoard, Board, FinalBoard, black, white, Player, GameStatus).

move(PreviousBoard, Board, FinalBoard, Color, Adversary, Player, GameStatus) :-
    repeat,
    (
        readCoordinates(CRow, CColumn, 'Current'),
        checkPosition(CRow, CColumn, Color, Board),
        readCoordinates(NRow, NColumn, 'New'),
        checkMove(CRow, CColumn, NRow, NColumn, Color, Adversary, Board, FinalBoard, GameStatus),
        PreviousBoard \= FinalBoard,
        display_game(FinalBoard, Player, Color)
        ;
        write('Cannot return to the original position!\n\n'),
        fail
).

readCoordinates(Row, Column, Status) :-
    once(readRow(Row, Status)),
    once(readColumn(Column, Status)).
