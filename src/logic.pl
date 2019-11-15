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

% ------------------------

% main game loop
game(Board, Player1, Player2, GameStatus, GameChoice, GameLevel) :-
(
    (
        GameChoice \== 3, % Player vs Player or Computer vs Player 
        write('1--\n'),
        once(whiteTurn(Board, Board, BoardWhite1, Player1, GameStatus, white)),   
        write('2--\n'),
        once(gameOver(GameStatus, '1')),
        write('3--\n'),
        once(whiteTurn(Board, BoardWhite1, BoardWhite2, Player2, GameStatus, black)),
        write('4--\n'),
        once(gameOver(GameStatus, '1')),
        write('5--\n')
        ;
        GameChoice == 3, % Computer vs Computer
        write('6--\n'),
        aiTurn(Board, Board, Player1, Player2, white, black, GameStatus, BoardWhite2, GameLevel),
        write('8--\n')
    ),
    (
        write('9--\n'),
        GameChoice \== 2, % Computer vs Player or Computer vs Computer
        write('10--\n'),
        once((BoardWhite1 = Board ; BoardWhite1 = BoardWhite1)), % Board for Computer vs Computer, BoardWhite1 for Player vs Computer
        write('11--\n'),
        aiTurn(BoardWhite1, BoardWhite2, Player2, Player1, black, white, GameStatus, BoardNext, GameLevel),
        write('12--\n')
        ;
        write('13--\n'),
        GameChoice == 2, % Player vs Player
        write('14--\n'),
        once(blackTurn(BoardWhite1, BoardWhite2, BoardBlack1, Player2, GameStatus, black)),
        write('15--\n'),
        once(gameOver(GameStatus, '2')),
        write('16--\n'),
        once(blackTurn(BoardWhite2, BoardBlack1, BoardNext, Player1, GameStatus, white)),
        write('17--\n'),
        once(gameOver(GameStatus, '2')),
        write('18--\n')
    ),
    write('19--\n'),
    game(BoardNext, Player1, Player2, GameStatus, GameChoice, GameLevel)
    ;
    write('\n* Thank you for playing! *\n\n'),
    !
).

% ai's double turn
aiTurn(PreviousBoard, Board, _, Player2, Color, Adversary, GameStatus, BoardAI, GameLevel) :-
    %write('1\n'),
    once(findall(FinalBoard, moveAI(PreviousBoard, Board, FinalBoard, Color, Adversary, GameStatus), AllBoards1)),
    %write('2\n'),
    once(value(AllBoards1, _, NewWin1, _, _, Adversary)),
    length(NewWin1, L),
    (
        (
            GameLevel == 1,
            random_member(BoardAI, AllBoards1)
            ;
            L \== 0,
            %write('3\n'),
            random_member(BoardAI, NewWin1)
        )
        ;
        once(validMoves(AllBoards1, PreviousBoard, Color, Adversary, GameStatus, _, AllBoards)),
        once(value(AllBoards, _, NewWin, _, NewOther, Adversary)),
        %write('6\n'),
        once(getBoard(NewWin, NewOther, BoardAI, GameLevel))
    ),
    %write('7\n'),
    once(display_game(BoardAI, Player2, Adversary)),
    (
        %write('8--\n'),
        once(gameOverAI(BoardAI, Adversary, 1))
        %write('9--\n')
        %sleep(1)
        ;
        %write('10--\n'),
        !,
        fail
    ).

value([], Board, Board, Board1, Board1, _) :- !.
value([Head|Tail], Win, NewWin, Other, NewOther, Adversary) :-
    (
        %write('\n24\n'),
        gameOverAI(Head, Adversary, 0),
        %write('25\n'),
        join_lists(Other, [Head], Other2),
        join_lists(Win, [], Win2)
        %write('26\n')
        ;
        %write('27\n'),
        join_lists(Win, [Head], Win2),
        join_lists(Other, [], Other2)
        %write('28\n\n')
    ),
    value(Tail, Win2, NewWin, Other2, NewOther, Adversary).

validMoves([], _, _, _, _, Board, Board) :- !.
validMoves([Head|Tail], PreviousBoard, Color, Adversary, GameStatus, AllBoards, FinalistBoard) :-
    findall(NewFinalBoard, moveAI(PreviousBoard, Head, NewFinalBoard, Color, Adversary, GameStatus), NewAllBoards),
    join_lists(AllBoards, NewAllBoards, FinalAllBoards),
    validMoves(Tail, PreviousBoard, Color, Adversary, GameStatus, FinalAllBoards, FinalistBoard).

%display1([]).
%display1([Head|Tail]) :-
%    display_game(Head, '1', black), nl,
%    display1(Tail).

gameOverAI(Board, Adversary, EndGame) :-
    % finds number of pieces of the opponent on the board
    findall(FinalBoard, pieceCounter(Board, FinalBoard, Adversary), AllPieces),
    length(AllPieces, Length),
    Length == 3
    ;
    % black wins because white has less than 3 pieces on the board
    write('20--\n'),
    EndGame == 1,
    write('21--\n'),
    Adversary == white,
    write('22--\n'),
    playerTwoWins,
    write('23--\n')
    ;
    % white wins because black has less than 3 pieces on the board
    EndGame == 1,
    Adversary == black,
    playerOneWins
    ;
    % used to check if it's a winner board, but not ending the game
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
        write('30--\n'),
        Player == '1',
        write('31--\n'),
        playerOneWins
        ;
        Player == '2',
        playerTwoWins
).
