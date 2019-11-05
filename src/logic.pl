setPeca(Linha, Coluna, Peca, TabIn, TabOut) :-
    setNaLinha(Linha, Coluna, Peca, TabIn, TabOut).

setNaLinha(1, Coluna, Peca, [Linha|Mais], [NovaLinha|Mais]) :-
    setNaColuna(Coluna, Peca, Linha, NovaLinha).

setNaLinha(N, Coluna,Peca,[Linha|Resto], [Linha|NovoResto]) :-
    N > 1,
    Next is N - 1,
    setNaLinha(Next, coluna, Peca, Resto, NovoResto).

setNaColuna(Linha, 1, Peca, [_|Mais], [Peca|Mais]).

setNaColuna(Linha, N, Peca, [X|Resto], [X|NovoResto]) :-
    N > 1,
    Next is N - 1,
    setNaColuna(Linha, Next, Peca, Resto, NovoResto).

move(Board) :-
    repeat,
    once(readColumn(Col)),
    once(readRow(Row)),
    checkFreePosition(Row, Col, '   ', Board),
    setPeca(Row, Col, Board, NewBoard),
    display_board(Board, 1).
