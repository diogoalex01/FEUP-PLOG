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

% check postition
% ------------------------

checkPosition(Row, Column, Piece, TabIn) :-
    getRow(Row, Column, Piece, TabIn).

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

checkMove(CRow, CColumn, NRow, NColumn, Color, Adversary, Board, FinalBoard, GameStatus) :-
    (
        checkSamePosition(CRow, NRow, CColumn, NColumn),
        checkNudge(CRow, CColumn, CRow, CColumn, NRow, NColumn, Color, Adversary, Board, FinalBoard, 0, GameStatus),
        checkDiagonal(CRow, CColumn, NRow, NColumn)
        ;
        write('Invalid move!\n\n'),
        fail
).

checkSamePosition(CRow, NRow, CColumn, NColumn) :-
    (
        CRow \= NRow
        ;
        CColumn \= NColumn
        ;
        write('You are already there!\n'),
        fail
).

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
        % both movements -> diagonally
        write('Diagonals are not allowed!\n'),
        fail
).

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
        %write('IR: '), write(IRow), write(' CR: '), write(CRow), write(' NR: '), write(NRow), nl,
        %write('IC: '), write(IColumn), write(' CC: '), write(CColumn), write(' NC: '), write(NColumn), nl,
        TRow is 2 * NRow - CRow,
        TColumn is 2 * NColumn - CColumn,
        checkPosition(TRow, TColumn, '     ', Board),
        checkLimits(TRow, TColumn),
        setPiece(TRow, TColumn, Adversary, MidBoard1, FinalBoard)
        ;
        % nudging out of the board (2 to 1)
        checkPosition(NRow, NColumn, Adversary, Board),
        N > 0,
        setPiece(IRow, IColumn, '     ', Board, MidBoard),
        setPiece(NRow, NColumn, Color, MidBoard, FinalBoard),
        TRow is 2 * NRow - CRow,
        TColumn is 2 * NColumn - CColumn,
        (TRow < 1 ; TColumn < 1 ; TRow > 5 ; TColumn > 5),
        GameStatus = 1
        ;
        % nudging out of the board (3 to 2)
        N > 1,
        checkPosition(NRow, NColumn, Adversary, Board),
        TRow is 2 * CRow - NRow,
        TColumn is 2 * CColumn - NColumn,
        TTRow is 2 * NRow - CRow,
        TTColumn is 2 * NColumn - CColumn,
        setPiece(IRow, IColumn, '     ', Board, MidBoard),
        setPiece(NRow, NColumn, Color, MidBoard, MidBoard1),
        setPiece(TRow, TColumn, '     ', MidBoard1, MidBoard2),
        setPiece(TTRow, TTColumn, Color, MidBoard2, FinalBoard),
        GameStatus = 1
        ;
        % standard nudge
        checkPosition(NRow, NColumn, Color, Board),
        NNRow is 2 * NRow - CRow,
        NNColumn is 2 * NColumn - CColumn,
        %checkLimits(NNRow, NNColumn),
        Next is N + 1, % counts the number of pieces nudging
        checkNudge(IRow, IColumn, NRow, NColumn, NNRow, NNColumn, Color, Adversary, Board, MidBoard, Next, GameStatus),
        setPiece(IRow, IColumn, '     ', MidBoard, FinalBoard)
        ;
        fail
).

checkLimits(Row, Column) :-
    (
        Row > 0,
        Row < 6,
        Column > 0,
        Column < 6
        ;
        fail
).
