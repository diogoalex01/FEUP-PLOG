% row validation
% ------------------------

readRow(Row, Status) :-
    write(Status),
    write(' Row '),
    inputRow(Row),
    validateRowInput(Row).

inputRow(Row) :-
    read(Row).

validateRowInput(Row) :-
    (
        Row =< 5,
        Row >= 1
        ;
        write('\nInvalid row!\n\n'),
        fail
).

% column validation
% ------------------------

readColumn(Column, Status) :-
    write(Status),
    write(' Column '),
    inputColumn(Temp_Column),
    validateColumnInput(Temp_Column, Column),
    write('\n').

inputColumn(Temp_Column) :-
    read(Temp_Column).

validateColumnInput('A', Column) :-
    Column = 1.
validateColumnInput('B', Column) :-
    Column = 2.
validateColumnInput('C', Column) :-
    Column = 3.
validateColumnInput('D', Column) :-
    Column = 4.
validateColumnInput('E', Column) :-
    Column = 5.

validateColumnInput(_Column, Column) :-
    write('\nInvalid column!\n\n'),
    inputColumn(Column),
    validateColumnInput(Column).

% checks if a Piece is in that place (Row, Column)
% ------------------------

checkPosition(Row, Column, Piece, Board) :-
    getRow(Row, Column, Piece, Board).

getRow(1, Column, Piece, [Row|_More]) :-
    getColumn(Column, Row, Piece).

getRow(N, Column, Piece, [_Row|Remnant]) :-
    N > 1,
    Next is N - 1,
    getRow(Next, Column, Piece, Remnant).

% ------------

getColumn(1, [Current|_More], Piece) :-
    (
        Piece == Current
        ;
        fail
).

getColumn(N, [_X|Remnant], Piece) :-
    N > 1,
    Next is N - 1,
    getColumn(Next, Remnant, Piece).

% check move possibilities
% ------------------------

% verifies if a given move (CRow, CColumn) -> (NRow, NColumn) is valid
checkMove(CRow, CColumn, NRow, NColumn, Color, Adversary, Board, FinalBoard, PreviousBoard, GameStatus) :-
    (
        %write('1--\n'),
        once(checkSamePosition(CRow, NRow, CColumn, NColumn)),
        %write('2--\n'),
        once(checkNudge(CRow, CColumn, CRow, CColumn, NRow, NColumn, Color, Adversary, Board, FinalBoard, 0, GameStatus)),
        %write('3--\n'),
        once(checkDiagonal(CRow, CColumn, NRow, NColumn)),
        %write('4--\n'),
        once(checkReturnPosition(PreviousBoard, FinalBoard))
        %write('5--\n')
        ;
        fail
).

% checks if the player is trying to move to the same place
checkSamePosition(CRow, NRow, CColumn, NColumn) :-
    (
        CRow \= NRow
        ;
        CColumn \= NColumn
        ;
        write('You are already there!\n\n'),
        fail
).

% checks if the player is trying to return to the same place in the same turn
checkReturnPosition(PreviousBoard, FinalBoard) :-
    (
        PreviousBoard \= FinalBoard
        ;
        write('Cannot return to the starting position!\n'),
        fail
).

% checks if the player is trying to move diagonally
checkDiagonal(CRow, CColumn, NRow, NColumn) :-
    (
        % just moving columns
        abs(CColumn - NColumn) =:= 1,
        CRow - NRow =:= 0
        ;
        % just moving rows
        abs(CRow - NRow) =:= 1,
        CColumn - NColumn =:= 0
        ;
        % moving more than a cell vertically
        abs(CColumn - NColumn) =\= 1,
        CRow - NRow =:= 0,
        write('Can\'t move more than a cell at a time!\n'),
        fail
        ;
        % moving more than a cell horizontally
        abs(CRow - NRow) =\= 1,
        CColumn - NColumn =:= 0,
        write('Can\'t move more than a cell at a time!\n'),
        fail
        ;
        % both movements -> diagonally
        abs(CColumn - NColumn) =:= 1,
        abs(CRow - NRow) =:= 1,
        write('Diagonals are not allowed!\n'),
        fail
).

% checks if the player is trying to nudge incorrectly
checkNudge(IRow, IColumn, CRow, CColumn, NRow, NColumn, Color, Adversary, Board, FinalBoard, N, GameStatus) :-
    (
        % standard move
        checkPosition(NRow, NColumn, '     ', Board),
        setPiece(IRow, IColumn, '     ', Board, MidBoard),
        setPiece(NRow, NColumn, Color, MidBoard, FinalBoard)
        ;
        % nudging opponents
        checkPosition(NRow, NColumn, Adversary, Board),
        N > 0,
        setPiece(IRow, IColumn, '     ', Board, MidBoard),
        setPiece(NRow, NColumn, Color, MidBoard, MidBoard1),
        findCoordinates(CRow, CColumn, NRow, NColumn, TRow, TColumn),
        checkPosition(TRow, TColumn, '     ', Board),
        checkLimits(TRow, TColumn),
        setPiece(TRow, TColumn, Adversary, MidBoard1, FinalBoard)
        ;
        % nudging out of the board (2 to 1)
        checkPosition(NRow, NColumn, Adversary, Board),
        N > 0,
        setPiece(IRow, IColumn, '     ', Board, MidBoard),
        setPiece(NRow, NColumn, Color, MidBoard, FinalBoard),
        findCoordinates(CRow, CColumn, NRow, NColumn, TRow, TColumn),
        (TRow < 1 ; TColumn < 1 ; TRow > 5 ; TColumn > 5),
        GameStatus = 1
        ;
        % nudging out of the board (3 to 2)
        N > 1,
        checkPosition(NRow, NColumn, Adversary, Board),
        findCoordinates(NRow, NColumn, CRow, CColumn, TRow, TColumn),
        findCoordinates(CRow, CColumn, NRow, NColumn, TTRow, TTColumn),
        setPiece(IRow, IColumn, '     ', Board, MidBoard),
        setPiece(NRow, NColumn, Color, MidBoard, MidBoard1),
        setPiece(TRow, TColumn, '     ', MidBoard1, MidBoard2),
        setPiece(TTRow, TTColumn, Color, MidBoard2, FinalBoard),
        GameStatus = 1
        ;
        % standard nudge
        checkPosition(NRow, NColumn, Color, Board),
        findCoordinates(CRow, CColumn, NRow, NColumn, NNRow, NNColumn),
        Next is N + 1, % counts the number of pieces nudging
        checkNudge(IRow, IColumn, NRow, NColumn, NNRow, NNColumn, Color, Adversary, Board, MidBoard, Next, GameStatus),
        setPiece(IRow, IColumn, '     ', MidBoard, FinalBoard)
        ;
        write('Invalid Nudge!\n'),
        fail
).
