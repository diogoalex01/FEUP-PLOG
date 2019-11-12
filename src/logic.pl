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

% main game loop
game(Board, Player1, Player2, GameStatus, GameChoice) :-
(
    write('1--\n'),
    whiteTurn(Board, Board, BoardWhite1, Player1, GameStatus, white),
    %write('2--\n'),
    %write('GSF: '), write(GameStatus), nl,
    once(gameOver(GameStatus, '1')),
    %write('3--\n'),
    whiteTurn(Board, BoardWhite1, BoardWhite2, Player2, GameStatus, black),
    %write('4--\n'),
    once(gameOver(GameStatus, '1')),
    write('5--\n'),
    (
        write('6--\n'),
        GameChoice = 1,
        write('7--\n'),
        gameAI(BoardWhite2, Player1, Player2),
        write('8--\n')
        ;
        write('9--\n'),
        GameChoice = 2,
        write('10--\n'),
        blackTurn(BoardWhite1, BoardWhite2, BoardBlack1, Player2, GameStatus, black),
        write('11--\n'),
        once(gameOver(GameStatus, '2')),
        write('12--\n'),
        blackTurn(BoardWhite2, BoardBlack1, BoardBlack2, Player1, GameStatus, white),
        write('13--\n'),
        once(gameOver(GameStatus, '2')),
        write('14--\n')
    ),
    %write('10--\n'),
    game(BoardBlack2, Player1, Player2, GameStatus)
    ;
    write('\n* Thank you for playing! *\n\n'),
    !
).

gameAI(Board, Player1, Player2) :-
    %display_game(Board, Player2, black),
    findall(FinalBoard, moveAI(Board, black, FinalBoard), AllBoards1),
    write('88--\n'),
    %display_game(Board, Player2, black),
    %length(AllBoards, Length),
    %write(Length), nl,
    getFirstBoard(AllBoards1, NewFinalBoard),
    write('866--\n'),
    display_game(NewFinalBoard, Player2, black),
    findall(NewFinalFinalBoard, moveAI(NewFinalBoard, black, NewFinalFinalBoard), AllBoards2),
    getFirstBoard(AllBoards2, NewFinalFinalFinalBoard),
    display_game(NewFinalFinalFinalBoard, Player1, white).

getFirstBoard([], []).
getFirstBoard([A|_], A) :-
    length(A, X),
    write(X), nl.

% standard white piece turn
whiteTurn(PreviousBoard, Board, FinalBoard, Player, GameStatus, DisplayColor) :-
    once(move(PreviousBoard, Board, FinalBoard, white, black, Player, GameStatus, DisplayColor)).

% standard black piece turn
blackTurn(PreviousBoard, Board, FinalBoard, Player, GameStatus, DisplayColor) :-
    once(move(PreviousBoard, Board, FinalBoard, black, white, Player, GameStatus, DisplayColor)).

% reads coordinates and if everything succeeds, the move is made
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
        checkMove(CRow, CColumn, NRow, NColumn, Color, Adversary, Board, FinalBoard, PreviousBoard, GameStatus),
        %write('1.5--\n'),
        %PreviousBoard \= FinalBoard,
        %write('1.6--\n'),
        display_game(FinalBoard, Player, DisplayColor)
        %write('1.7--\n')
        ;
        write('* Try again! *\n\n'),
        fail
).

moveAI(Board, Piece, FinalBoard) :-
    genPosition(Row, Column),
    checkPosition(Row, Column, Piece, Board),
    checkMoveAI(Row, Column, Board, FinalBoard).

checkMoveAI(Row, Column, Board, FinalBoard) :-
    R is Row - 1,
    R > 0,
    %write('2.1--\n'),
    %write('R1-- '), write(R), nl,
    checkPosition(R, Column, '     ', Board),
    setPiece(Row, Column, '     ', Board, MidBoard),
    setPiece(R, Column, black, MidBoard, FinalBoard)
    %write('cima--\n'),
    ;
    R is Row + 1,
    R < 6,
    %write('2.2--\n'),
    %write('R2-- '), write(R), nl,
    checkPosition(R, Column, '     ', Board),
    setPiece(Row, Column, '     ', Board, MidBoard),
    setPiece(R, Column, black, MidBoard, FinalBoard)
    %write('baixo--\n'),
    ;
    C is Column - 1,
    C > 0,
    %write('2.3--\n'),
    %write('C1-- '), write(C), nl,
    checkPosition(Row, C, '     ', Board),
    setPiece(Row, Column, '     ', Board, MidBoard),
    setPiece(Row, C, black, MidBoard, FinalBoard)
    %write('esq--\n'),
    ;
    C is Column + 1,
    C < 6,
    %write('2.4--\n'),
    %write('C2-- '), write(C), nl,
    checkPosition(Row, C, '     ', Board),
    setPiece(Row, Column, '     ', Board, MidBoard),
    setPiece(Row, C, black, MidBoard, FinalBoard)
    %write('dir--\n'),
    ;
    %write('troca\n'),
    fail.

% checks whether the game is over (GameStatus \== 1) and prints the winner (player)
gameOver(GameStatus, Player) :-
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