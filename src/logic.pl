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
    %write('1--\n'),
    whiteTurn(Board, Board, BoardWhite1, Player1, GameStatus, white),
    %write('2--\n'),
    %write('GSF: '), write(GameStatus), nl,
    checkVictory(GameStatus, '1'),
    %write('3--\n'),
    whiteTurn(Board, BoardWhite1, BoardWhite2, Player2, GameStatus, black),
    %write('4--\n'),
    checkVictory(GameStatus, '1'),
    %write('5--\n'),
    blackTurn(BoardWhite1, BoardWhite2, BoardBlack1, Player2, GameStatus, black),
    %write('6--\n'),
    checkVictory(GameStatus, '2'),
    %write('7--\n'),
    blackTurn(BoardWhite2, BoardBlack1, BoardBlack2, Player1, GameStatus, white),
    %write('8--\n'),
    checkVictory(GameStatus, '2'),
    %write('9--\n'),
    %write('10--\n'),
    game(BoardBlack2, Player1, Player2, GameStatus)
    %write('11--\n')
    ;
    write('\n* Thank you for playing! *\n\n'),
    !
).

whiteTurn(PreviousBoard, Board, FinalBoard, Player, GameStatus, DisplayColor) :-
    once(move(PreviousBoard, Board, FinalBoard, white, black, Player, GameStatus, DisplayColor)).

blackTurn(PreviousBoard, Board, FinalBoard, Player, GameStatus, DisplayColor) :-
    once(move(PreviousBoard, Board, FinalBoard, black, white, Player, GameStatus, DisplayColor)).

move(PreviousBoard, Board, FinalBoard, Color, Adversary, Player, GameStatus, DisplayColor) :-
    repeat,
    (
        %write('1.1--\n'),
        readCoordinates(CRow, CColumn, 'Current'),
        %write('1.2--\n'),
        checkPosition(CRow, CColumn, Color, Board),
        %write('1.3--\n'),
        readCoordinates(NRow, NColumn, 'New'),
        %write('1.4--\n'),
        checkMove(CRow, CColumn, NRow, NColumn, Color, Adversary, Board, FinalBoard, GameStatus),
        %write('1.5--\n'),
        PreviousBoard \= FinalBoard,
        %write('1.6--\n'),
        display_game(FinalBoard, Player, DisplayColor)
        %write('1.7--\n')
        ;
        write('Cannot return to the original position!\n\n'),
        fail
).

readCoordinates(Row, Column, Status) :-
    once(readRow(Row, Status)),
    once(readColumn(Column, Status)).

checkVictory(GameStatus, Player) :-
    (   
        %write('2.1--\n'),
        GameStatus \== 1
        %write('2.2--\n')
        ;
        %write('2.3--\n'),
        %write('P:--'), write(Player), nl,
        Player == '1',
        %write('2.4--\n'),
        playerOneWins,
        %write('2.5--\n'),
        !
        ;
        %write('2.6--\n'),
        %write('P:--'), write(Player), nl,
        Player == '2',
        %write('2.7--\n'),
        playerTwoWins,
        %write('2.8--\n'),
        !
).