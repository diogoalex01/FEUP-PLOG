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
        write('\nInvalid Row!\n\n'),
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
    write('\nInvalid Column!\n\n'),
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
        write('Invalid Position!\n\n'),
        fail
).

getColumn(N, [_X|Remnant], Piece) :-
    N > 1,
    Next is N - 1,
    getColumn(Next, Remnant, Piece).
