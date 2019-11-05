readColumn(NewColumn) :-
    repeat,
    inputColumn(NewColumn),
    validateColumnInput(NewColumn).

readRow(NewRow) :-
    inputRow(NewRow),
    validateRowInput(NewRow).

inputRow(NewRow) :-
    write('Row: '),
    read(Row).

inputColumn(NewColumn) :-
    write('Column : '),
    read(NewColumn).

validateRowInput('A').

validateRowInput('B').

validateRowInput('C').

validateRowInput('D').

validateRowInput('E').

validateRowInput(NewRow) :-
    write('Invalid Row!\n'),
    InputRow(_Row),
    validateRowInput(_Row, NewRow).


validateColumnInput(NewColumn) :-
    (
    NewColumn <= 5, NewColumn >= 1
    ;
    write('Invalid Column\n'), fail
    ).

checkFreePosition(Linha,Coluna,Peca,TabIn) :-
    setNaLinha(Linha, Coluna, Peca, TabIn).

setNaLinha(1, Coluna, Peca, [Linha|Mais]) :-
    setNaColuna(Coluna, Peca, Linha).

setNaLinha(N, Coluna,Peca,[Linha|Resto]) :-
    N>1,
    Next is N-1,
    setNaLinha(Next, coluna, Peca, Resto).

setNaColuna(Linha, 1, Peca, [Blank|Mais]) :-
    (
    Peca = Blank
    ;
    write('Invalid Position\n'), fail
    ).

setNaColuna(Linha, N, Peca, [X|Resto]) :-
    N>1,
    Next is N-1,
    setNaColuna(Linha, Next Peca, Resto).


moveType(Type) :-repeat,
    write('You want to move two or one piece? \'s\' or \'d\' (Single or Double):'),
    once(le_numero(Type)),
    it((Type \== 52, Type \== 67),(write('Invalid input!'), nl, fail)).
