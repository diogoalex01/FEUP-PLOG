% to run, 'closeOrFar.'

:- include('interface.pl').
:- include('utilities.pl').

:- use_module(library(clpfd)). % CLP(FD) SICStus library
:- use_module(library(lists)).
:- use_module(library(random)).

closeOrFar :- 
    %mainMenu,
    board_beg(Board),
    display_game(Board),
    findSol(_).
    %display_game(Board).

findSol(_) :-
    Vars = [A1, A2, A3, A4,
            A5, A6, A7, A8, 
            A9, A10, A11, A12, 
            A13, A14, A15, A16],
    domain(Vars, 0, 2),
    %%
    global_cardinality([A1, A2, A3, A4], [1-2, 2-2]),
    global_cardinality([A5, A6, A7, A8], [1-2, 2-2]),
    global_cardinality([A9, A10, A11, A12], [1-2, 2-2]),
    global_cardinality([A13, A14, A15, A16], [1-2, 2-2]),
    global_cardinality([A1, A5, A9, A13], [1-2, 2-2]),
    global_cardinality([A2, A6, A10, A14], [1-2, 2-2]),
    global_cardinality([A3, A7, A11, A15], [1-2, 2-2]),
    global_cardinality([A4, A8, A12, A16], [1-2, 2-2]),
    %%
    labeling([], Vars),
    write('1---'), nl, write(Vars), nl.

subList(StartPos, EndPos, WholeList, SubList) :-
    subList1(1, StartPos, EndPos, WholeList, SubList).

subList(N, StartPos, EndPos, [_, Remnant], More) :-
    N < StartPos,
    Next is N + 1,
    subList(Next, StartPos, EndPos, Remnant, More).   

subList1(EndPos, _, EndPos, _, []).

subList1(StartPos, StartPos, EndPos, [X|Remnant], [X|More]) :-
    Next is StartPos + 1,
    subList1(Next, StartPos, EndPos, Remnant, More).

subList1(N, StartPos, EndPos, [X|Remnant], [X|More]) :-
    N > StartPos,
    N < EndPos,
    Next is N + 1,
    subList1(Next, StartPos, EndPos, Remnant, More).
