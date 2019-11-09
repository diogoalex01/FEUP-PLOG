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

checkMove(CRow, CColumn, NRow, NColumn, Color, Board, FinalBoard) :-
    checkDrag(CRow, CColumn, NRow, NColumn, Color, Board, FinalBoard),
    checkDiagonal(CRow, CColumn, NRow, NColumn).

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
        write('Diagonal moves are not allowed!\n\n'),
        fail
).

checkDrag(CRow, CColumn, NRow, NColumn, Color, Board, FinalBoard) :-
    (
        checkPosition(NRow, NColumn, '     ', Board),
        setPiece(CRow, CColumn, '     ', Board, MidBoard),
        setPiece(NRow, NColumn, Color, MidBoard, FinalBoard)
        ;
        checkPosition(NRow, NColumn, Color, Board),
        setPiece(CRow, CColumn, '     ', Board, MidBoard),
        Row is 2 * NRow - CRow,
        Row > 0,
        Row < 6,
        Column is 2 * NColumn - CColumn,
        Column > 0,
        Column < 6,
        setPiece(Row, Column, Color, MidBoard, FinalBoard)
        ;
        write('Invalid move!\n\n'),
        fail
).
