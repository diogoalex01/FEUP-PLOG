% row validation
% ------------------------

readRow :-
    inputRow(NewRow),
    validateRowInput(NewRow).

inputRow(NewRow) :-
    write('Row: '),
    read(NewRow).

validateRowInput(NewRow) :-
    (
        NewRow =< 5,
        NewRow >= 1
        ;
        write('\nInvalid Row!\n\n'),
        fail
).

% column validation
% ------------------------

readColumn :-
    inputColumn(NewColumn),
    validateColumnInput(NewColumn).

inputColumn(NewColumn) :-
    write('Column: '),
    read(NewColumn).

validateColumnInput('A').
validateColumnInput('B').
validateColumnInput('C').
validateColumnInput('D').
validateColumnInput('E').

validateColumnInput(NewColumn) :-
    write('\nInvalid Column!\n\n'),
    inputColumn(NewColumn),
    validateColumnInput(NewColumn).

% empty postition
% ------------------------

checkEmptyPosition(Row, Column, Piece, TabIn) :-
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
