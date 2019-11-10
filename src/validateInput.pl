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
        %write('P1--'), write(Piece), write('--'),
        %write('C1--'), write(Current), write('--\n'),
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

checkMove(CRow, CColumn, NRow, NColumn, Color, Adversary, Board, FinalBoard) :-
    (
        checkDrag(CRow, CColumn, CRow, CColumn, NRow, NColumn, Color, Adversary, Board, FinalBoard, 0),
        checkDiagonal(CRow, CColumn, NRow, NColumn)
        ;
        write('Invalid move!\n\n'),
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

checkDrag(IRow, IColumn, CRow, CColumn, NRow, NColumn, Color, Adversary, Board, FinalBoard, N) :-
    (
        checkPosition(NRow, NColumn, '     ', Board),
        setPiece(IRow, IColumn, '     ', Board, MidBoard),
        setPiece(NRow, NColumn, Color, MidBoard, FinalBoard)
        ;
        checkPosition(NRow, NColumn, Adversary, Board),
        N > 0,
        setPiece(IRow, IColumn, '     ', Board, MidBoard),
        setPiece(NRow, NColumn, Color, MidBoard, MidBoard1),
        %write('IR: '), write(IRow), write(' CR: '), write(CRow), write(' NR: '), write(NRow), nl,
        write('IC: '), write(IColumn), write(' CC: '), write(CColumn), write(' NC: '), write(NColumn), nl,
        TRow is 2 * NRow - CRow,
        TColumn is 2 * NColumn - CColumn,
        write('N: '), write(N), nl,
        write('TR: '), write(TRow), write(' TC: '), write(TColumn), nl,
        write('2.5--\n'),
        checkPosition(TRow, TColumn, '     ', Board),
        checkLimits(TRow, TColumn),
        setPiece(TRow, TColumn, Adversary, MidBoard1, FinalBoard)
        ;
        checkPosition(NRow, NColumn, Adversary, Board),
        N > 0,
        setPiece(IRow, IColumn, '     ', Board, MidBoard),
        setPiece(NRow, NColumn, Color, MidBoard, FinalBoard),
        TRow is 2 * NRow - CRow,
        TColumn is 2 * NColumn - CColumn,
        write('hello---\n'),
        (
            write('entrei ao menos'),
            TRow < 1,
            write('1.')
            ;
            TColumn < 1,
            write('2.')
            ;
            write('3.'),
            TRow > 5
            ;
            TColumn > 5,
            write('4.')
        ),
        write('bye---\n')
        ;
        checkPosition(NRow, NColumn, Color, Board),
        NNRow is 2 * NRow - CRow,
        NNColumn is 2 * NColumn - CColumn,
        checkLimits(NNRow, NNColumn),
        Next is N + 1, % counts the number of pieces nudging
        checkDrag(IRow, IColumn, NRow, NColumn, NNRow, NNColumn, Color, Adversary, Board, MidBoard, Next),
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
        write('YOU WON!\n'),
        !
).
