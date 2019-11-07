readColumn :-
    repeat,
    inputColumn(NewColumn),
    validateColumnInput(NewColumn).

readRow :-
    inputRow(NewRow),
    validateRowInput(NewRow).

inputRow(NewRow) :-
    write('Row: '),
    read(NewRow).

inputColumn(NewColumn) :-

    repeat,    write('Column : '),
    read(NewColumn).

validateRowInput('A').

validateRowInput('B').

validateRowInput('C').

validateRowInput('D').

validateRowInput('E').

validateRowInput(NewRow) :-
    write('Invalid Row!\n'),
    fail,
    inputRow(NewRow),
    validateRowInput(NewRow).

validateColumnInput(NewColumn) :-
    (
        NewColumn =< 5,
        NewColumn >= 1
        ;
        write('Invalid Column!\n'),
        fail
).

checkFreePosition(Linha,Coluna,Peca,TabIn) :-
    setNaLinha(Linha, Coluna, Peca, TabIn).

setNaLinha(1, Coluna, Peca, [Linha|_Mais]) :-
    setNaColuna(Coluna, Peca, Linha).

setNaLinha(N, Coluna, Peca, [_Linha|Resto]) :-
    N > 1,
    Next is N - 1,
    setNaLinha(Next, Coluna, Peca, Resto).

setNaColuna(1, _Linha, Peca, [Blank|_Mais]) :-
    (
        Peca = Blank
        ;
        write('Invalid Position!\n'),
        fail
).

setNaColuna(N, Linha, Peca, [_X|Resto]) :-
    N > 1,
    Next is N - 1,
    setNaColuna(Next, Linha, Peca, Resto).
