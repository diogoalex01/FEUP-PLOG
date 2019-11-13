% generates possible moves
moveAI(PreviousBoard, Board, Piece, FinalBoard, GameStatus) :-
    genPosition(Row, Column),
    checkPosition(Row, Column, Piece, Board),
    checkMoveAI(PreviousBoard, Row, Column, Board, FinalBoard, GameStatus).

% confirms the direction each piece can move
checkMoveAI(PreviousBoard, Row, Column, Board, FinalBoard, GameStatus) :-
    % up movement
    R is Row - 1,
    R > 0,
    checkRowAI(Row, R, Column, PreviousBoard, Board, FinalBoard, GameStatus)
    ;
    % down movement
    R is Row + 1,
    R < 6,
    checkRowAI(Row, R, Column, PreviousBoard, Board, FinalBoard, GameStatus)
    ;
    % left movement
    C is Column - 1,
    C > 0,
    checkColumnAI(Row, C, Column, PreviousBoard, Board, FinalBoard, GameStatus)
    ;
    % right movement
    C is Column + 1,
    C < 6,
    checkColumnAI(Row, C, Column, PreviousBoard, Board, FinalBoard, GameStatus)
    ;
    fail.

% checks if the horizontal move is valid
checkRowAI(Row, R, Column, PreviousBoard, Board, FinalBoard, GameStatus) :-
    once(checkNudge(Row, Column, Row, Column, R, Column, black, white, Board, FinalBoard, 0, GameStatus)),
    once(checkReturnPosition(PreviousBoard, FinalBoard)).

% checks if the vertical move is valid
checkColumnAI(Row, C, Column, PreviousBoard, Board, FinalBoard, GameStatus) :-
    once(checkNudge(Row, Column, Row, Column, Row, C, black, white, Board, FinalBoard, 0, GameStatus)),
    once(checkReturnPosition(PreviousBoard, FinalBoard)).
