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
    find_CF(10, _).
    %display_game(Board).

find_CF(N, Vars) :-
    %replace('     ', _, Vars, FVars),
    %replace('close', 1, FVars, FFVars),
    %replace(' far ', 2, FFVars, FFFVars),
    Number is N * N,
    length(Vars, Number),
    domain(Vars, 0, 2),
        write('1.1---\n'),
    row_constraints(N, Vars, N),
        write('1.2---\n'),
    column_constraints(N, Vars, N),
            write('1.3---\n'),
    labeling([value(my_sel)], Vars),
    replace(0, '     ', Vars, FVars),
    replace(1, 'close', FVars, FFVars),
    replace(2, ' far ', FFVars, FFFVars),
    display_game(FFFVars), nl.

%%%%%%%%%%%%%%%%%%%%%%%%%

row_constraints(1, Vars, N):-
    sub_list(1, N, Vars, Row),
    global_cardinality(Row, [0-_, 1-2, 2-2]),
    check_proximity(Row).

row_constraints(Index, Vars, N):-
    IndexMax is N * Index,
    IndexMin is N * (Index - 1) + 1,
    sub_list(IndexMin, IndexMax, Vars, Row),
    global_cardinality(Row, [0-_, 1-2, 2-2]),
    check_proximity(Row),
    NewIndex is Index - 1,
    row_constraints(NewIndex, Vars, N).

check_proximity(L) :-
    element(C1, L, 1),
    element(C2, L, 1),
    C1 #\= C2,
    element(F1, L, 2),
    element(F2, L, 2),
    F1 #\= F2,
    T1 #= abs(C2 - C1),
    T2 #= abs(F2 - F1),
    T2 #> T1.

get_column(_, 0, _, _, SubList, FinalList):-
    append(SubList, [], FinalList).
get_column(I, 1, N, WholeList, SubList, FinalList):-
    sub_list(I, I, WholeList, NewList),
    append(NewList, SubList, NewNewList),
    get_column(I, 0, N, WholeList, NewNewList, FinalList).

get_column(I, Line, N, WholeList, SubList, FinalList):-
    Index is I + N * (Line - 1),
    sub_list(Index, Index, WholeList, NewList),
    append(NewList, SubList, NewNewList),
    NewLine is Line - 1,
    get_column(I, NewLine, N, WholeList, NewNewList, FinalList).

column_constraints(1, Vars, N):-
    get_column(1, N, N, Vars, _, Column),
    global_cardinality(Column, [0-_, 1-2, 2-2]),
    check_proximity(Column).

column_constraints(Index, Vars, N):-
    get_column(Index, N, N, Vars, _, Column),
    global_cardinality(Column, [0-_, 1-2, 2-2]),
    check_proximity(Column),
    NewIndex is Index-1,
    column_constraints(NewIndex, Vars, N).

%%%%%%%%%%%%%%%%%%%%%%%%%

sub_list(StartPos, EndPos, WholeList, SubList) :-
    sub_list_aux(1, StartPos, EndPos, WholeList, SubList).

sub_list_aux(EndPos, _, EndPos, [X|_], [X]).
sub_list_aux(StartPos, StartPos, EndPos, [X|Rest], [X|More]) :-
    Next is StartPos + 1,
    sub_list_aux(Next, StartPos, EndPos, Rest, More).
sub_list_aux(N, StartPos, EndPos, [X|Rest], [X|More]) :-
    N > StartPos,
    N < EndPos,
    Next is N + 1,
    sub_list_aux(Next, StartPos, EndPos, Rest, More).
sub_list_aux(N, StartPos, EndPos, [_|Rest], More) :-
    N < StartPos,
    Next is N + 1,
    sub_list_aux(Next, StartPos, EndPos, Rest, More).
