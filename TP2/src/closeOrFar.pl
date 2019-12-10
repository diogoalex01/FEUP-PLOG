% to run, 'closeOrFar.'

:- use_module(library(clpfd)). % CLP(FD) SICStus library
:- use_module(library(lists)).

closeOrFar :- .

subList(StartPos, EndPos, WholeList, SubList) :-
    subList1(1, StartPos, EndPos, WholeList, SubList).

subList1(EndPos, _, EndPos, _, []).
subList1(StartPos, StartPos, EndPos, [X|Remnant], [X|More]) :-
    Next is StartPos + 1,
    subList1(Next, StartPos, EndPos, Remnant, More).
subList1(N, StartPos, EndPos, [X|Remnant], [X|More]) :-
    N > StartPos,
    N < EndPos,
    Next is N + 1,
    subList1(Next, StartPos, EndPos, Remnant, More).

subList(N, StartPos, EndPos, [_, Remnant], More) :-
    N < StartPos,
    Next is N + 1,
    subList(Next, StartPos, EndPos, Remnant, More).   
