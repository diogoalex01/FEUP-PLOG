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
    (
        GameChoice \== 3, % Player vs Player or Computer vs Player 
        %write('1--\n'),
        whiteTurn(Board, Board, BoardWhite1, Player1, GameStatus, white),   
        %write('2--\n'),
        once(gameOver(GameStatus, '1')),
        %write('3--\n'),
        whiteTurn(Board, BoardWhite1, BoardWhite2, Player2, GameStatus, black),
        %write('4--\n'),
        once(gameOver(GameStatus, '1'))
        %write('5--\n')
        ;
        GameChoice == 3, % Computer vs Computer
        %write('6--\n'),
        aiTurn(Board, Board, Player1, Player2, white, black, GameStatus, BoardWhite2)
        %write('8--\n')
    ),
    (
        %write('9--\n'),
        GameChoice \== 2, % Computer vs Player or Computer vs Computer
        %write('10--\n'),
        (BoardWhite1 = Board ; BoardWhite1 = BoardWhite1), % Board for AI vs AI, BoardWhite1 for Player vs AI
        %write('11--\n'),
        aiTurn(BoardWhite1, BoardWhite2, Player2, Player1, black, white, GameStatus, BoardNext)
        %write('12--\n')
        ;
        %write('13--\n'),
        GameChoice == 2, % Player vs Player
        %write('14--\n'),
        blackTurn(BoardWhite1, BoardWhite2, BoardBlack1, Player2, GameStatus, black),
        %write('15--\n'),
        once(gameOver(GameStatus, '2')),
        %write('16--\n'),
        blackTurn(BoardWhite2, BoardBlack1, BoardNext, Player1, GameStatus, white),
        %write('17--\n'),
        once(gameOver(GameStatus, '2'))
        %write('18--\n')
    ),
    %write('19--\n'),
    game(BoardNext, Player1, Player2, GameStatus, GameChoice)
    ;
    write('\n* Thank you for playing! *\n\n'),
    !
).

% ai's double turn
aiTurn(PreviousBoard, Board, _Player1, Player2, Color, Adversary, GameStatus, BoardAI) :-
    once(findall(FinalBoard, moveAI(PreviousBoard, Board, FinalBoard, Color, Adversary, GameStatus), AllBoards1)),
    %write('20'),
    %getBoard(AllBoards1, NewFinalBoard),
    %write('21'),
    %display_game(NewFinalBoard, Player1, Color),
    %write('22'),
    once(getAllOp(AllBoards1, PreviousBoard, Color, Adversary, GameStatus, _, AllBoards)),
    %length(AllBoards, X),
    %write('Lenght do allboards: '), %write(X),nl,
    %write('23'),
    %display1(AllBoards),
    %write('24'),
    once(getBoard(AllBoards, BoardAI)),
    %write('GS1: '), write(GameStatus), nl,
    %once(gameOverAI(NewFinalBoard, Adversary)).
    %findall(NewFinalFinalBoard, moveAI(Board, NewFinalBoard, NewFinalFinalBoard, Color, Adversary, GameStatus), AllBoards2),
    %getBoard(AllBoards2, BoardAI),
    once(display_game(BoardAI, Player2, Adversary)),
    %write('GS2: '), write(GameStatus), nl,
    once(gameOverAI(BoardAI, Adversary, 1)).

getAllOp([], _, _, _, _, Board, Board) :- !.

getAllOp([A|Resto], PreviousBoard, Color, Adversary, GameStatus, AllBoards, FinalistBoard) :-
    %write('25'),
    %length(Resto, X),
    %write('Lenght: '), write(X),nl,
    findall(NewFinalBoard, moveAI(PreviousBoard, A, NewFinalBoard, Color, Adversary, GameStatus), NewAllBoards),
    join_lists(AllBoards, NewAllBoards, FinalAllBoards),
    getAllOp(Resto, PreviousBoard, Color, Adversary, GameStatus, FinalAllBoards, FinalistBoard).

%display1([]).
%display1([A|Resto]) :-
%display_game(A,1,black),
%display1(Resto).

gameOverAI(Board, Adversary, EndGame) :-
    findall(FinalBoard, pieceCounter(Board, FinalBoard, Adversary), AllPieces),
    length(AllPieces, Length),
    %write('HERE: '), write(Length), nl,
    Length == 3
    ;
    EndGame == 1,
    Adversary == black,
    playerOneWins,
    !
    ;
    EndGame == 1,
    Adversary == white,
    playerTwoWins,
    !
    ;
    EndGame == 0,
    !,
    fail.

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
        readCoordinates(CRow, CColumn, 'Current'),
        checkPosition(CRow, CColumn, Color, Board),
        readCoordinates(NRow, NColumn, 'New'),
        checkMove(CRow, CColumn, NRow, NColumn, Color, Adversary, Board, FinalBoard, PreviousBoard, GameStatus),
        display_game(FinalBoard, Player, DisplayColor)
        ;
        write('* Try again! *\n\n'),
        fail
).

% checks whether the game is over (GameStatus \== 1) and prints the winner (player)
gameOver(GameStatus, Player) :-
    (   
        GameStatus \== 1
        ;
        Player == '1',
        playerOneWins,
        !
        ;
        Player == '2',
        playerTwoWins,
        !
).
