setPeca(Linha, Coluna, Peca, TabIn, TabOut) :-
    setNaLinha(Coluna, Linha, Peca, TabIn, TabOut).

setNaLinha(1, Coluna, Peca, [Linha|Mais], [NovaLinha|Mais]) :-
    setNaColuna(Coluna, Peca, Linha, NovaLinha).

setNaLinha(N, Coluna, Peca, [Linha|Resto], [Linha|NovoResto]) :-
    N > 1,
    Next is N - 1,
    setNaLinha(Next, Coluna, Peca, Resto, NovoResto).

setNaColuna(1, _Linha, Peca, [_Y|Mais], [Peca|Mais]).

setNaColuna(N, Linha, Peca, [X|Resto], [X|NovoResto]) :-
    N > 1,
    Next is N - 1,
    setNaColuna(Next, Linha, Peca, Resto, NovoResto).

move(Board) :-
    repeat,
    once(readColumn(_Col)),
    once(readRow(_Row)),
    checkFreePosition(3, 3, '   ', Board),
    setPeca(3, 3, 'w', Board, NewBoard),
    display_board(NewBoard, '1').
