% generates possible moves
moveAI(PreviousBoard, Board, FinalBoard, Color, Adversary, GameStatus) :-
    genPosition(Row, Column),
    checkPosition(Row, Column, Color, Board),
    checkMoveAI(PreviousBoard, Row, Column, Board, FinalBoard, Color, Adversary, GameStatus).

% confirms the direction each piece can move
checkMoveAI(PreviousBoard, Row, Column, Board, FinalBoard, Color, Adversary, GameStatus) :-
    % up movement
    R is Row - 1,
    R > 0,
    checkRowAI(Row, R, Column, PreviousBoard, Board, FinalBoard, Color, Adversary, GameStatus)
    ;
    % down movement
    R is Row + 1,
    R < 6,
    checkRowAI(Row, R, Column, PreviousBoard, Board, FinalBoard, Color, Adversary, GameStatus)
    ;
    % left movement
    C is Column - 1,
    C > 0,
    checkColumnAI(Row, C, Column, PreviousBoard, Board, FinalBoard, Color, Adversary, GameStatus)
    ;
    % right movement
    C is Column + 1,
    C < 6,
    checkColumnAI(Row, C, Column, PreviousBoard, Board, FinalBoard, Color, Adversary, GameStatus)
    ;
    fail.

% checks if the horizontal move is valid
checkRowAI(Row, R, Column, PreviousBoard, Board, FinalBoard, Color, Adversary, GameStatus) :-
    once(checkNudge(Row, Column, Row, Column, R, Column, Color, Adversary, Board, FinalBoard, 0, GameStatus, 0)),
    once(checkReturnPosition(PreviousBoard, FinalBoard, 0)).

% checks if the vertical move is valid
checkColumnAI(Row, C, Column, PreviousBoard, Board, FinalBoard, Color, Adversary, GameStatus) :-
    once(checkNudge(Row, Column, Row, Column, Row, C, Color, Adversary, Board, FinalBoard, 0, GameStatus, 0)),
    once(checkReturnPosition(PreviousBoard, FinalBoard, 0)).
