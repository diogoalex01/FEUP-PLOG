% row validation
% ------------------------

readRow(BRow, NRow) :-
    write('Current Row'),
    inputRow(BRow),
    validateRowInput(BRow),
    write('New Row'),
    inputRow(NRow),
    validateRowInput(NRow).

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

readColumn(BColumn, NColumn) :-
    write('\nCurrent Column'),
    inputColumn(Column),
    validateColumnInput(Column, BColumn),
    write('New Column'),
    inputColumn(Column),
    nl,
    validateColumnInput(Column, NColumn).

inputColumn(Column) :-
    read(Column).

validateColumnInput('A', NewColumn) :-
    write('\n A! \n\n'),
    NewColumn = 1.
validateColumnInput('B', NewColumn) :-
    write('\n B! \n\n'),
    NewColumn = 2.
validateColumnInput('C', NewColumn) :-
    write('\n C! \n\n'),
    NewColumn = 3.
validateColumnInput('D', NewColumn) :-
    write('\n D! \n\n'),
    NewColumn = 4.
validateColumnInput('E', NewColumn) :-
    write('\n E! \n\n'),
    NewColumn = 5.

validateColumnInput(_Column, NewColumn) :-
    write('\nInvalid Column!\n\n'),
    inputColumn(NewColumn),
    validateColumnInput(NewColumn).

% empty postition
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

getColumn(1, [Blank|_More], Piece) :-
    (
        Piece == Blank
        ;
        write('\nInvalid Position!\n\n'),
        fail
).

getColumn(N, [_X|Remnant], Piece) :-
    N > 1,
    Next is N - 1,
    getColumn(Next, Remnant, Piece).
