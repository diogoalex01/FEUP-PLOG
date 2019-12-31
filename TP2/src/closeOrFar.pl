% to run, 'closeOrFar.'

:- include('interface.pl').
:- include('utilities.pl').

:- use_module(library(clpfd)). % CLP(FD) SICStus library
:- use_module(library(lists)).
:- use_module(library(random)).

closeOrFar :- 
    main_menu(Option),
    find_CF(Option, Board),
    display_game(Board).

% checks if a given board has a Close&Far solution
find_CF(1, FFVars) :-
    board_beg(Vars),
    display_game(Vars),
    replaceAll('close', ' far ', '     ', 1, 2, _, Vars, FVars),
    display_game(FVars),

    % variables and domains
    length(FVars, L),
    N is round(sqrt(L)),
    domain(FVars, 0, 2),

    % contraints
    write('1------\n'),
    row_constraints(N, FVars, N),
    write('2------\n'),
    %column_constraints(N, FVars, N),

    % solution search
    labeling([value(my_sel)], FVars),

    replaceAll(0, 1, 2, '     ', 'close', ' far ', FVars, FFVars).

% generates a random board that complies with Close&Far constraints
find_CF(2, FFVars) :-
    ask_size(N),

    % variables and domains
    L is N * N,
    length(Vars, L),
    domain(Vars, 0, 2),

    % contraints
    row_constraints(N, Vars, N),
    column_constraints(N, Vars, N),

    % solution search
    labeling([value(my_sel)], Vars),

    replaceAll(0, 1, 2, '     ', 'close', ' far ', Vars, FVars),
    write('\nSOLVED Close&Far:\n'),
    display_game(FVars),
    unsolve(FVars, _, FFVars, L, L),
    write('\nUNSOLVED Close&Far:\n').

% -------- Row Constraints -------- %

row_constraints(1, Vars, N):-
    sub_list(1, N, Vars, Row),
    global_cardinality(Row, [0-_, 1-2, 2-2]),
    check_proximity(Row).

row_constraints(Index, Vars, N):-
    %write('1.1-----\n'),
    IndexMax is N * Index,
    %write('1.2-----\n'),
    IndexMin is N * (Index - 1) + 1,
    %write('1.3-----\n'),
    sub_list(IndexMin, IndexMax, Vars, Row),
    %write('1.4-----\n'),
    global_cardinality(Row, [0-_, 1-2, 2-2]),
    %write('1.5-----\n'),
    check_proximity(Row),
    %write('1.6-----\n'),
    NewIndex is Index - 1,
    %write('1.7-----\n'),
    row_constraints(NewIndex, Vars, N).
    %write('1.8-----\n').

% ------ Columns Constraints ------ %

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

% --------------------------------- %

% checks is the 'close' and 'far' elements are correctly placed
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

% chooses N board positions randomnly and empties them
unsolve(NNBoard, _, NNBoard, _, 0).
unsolve(Board, NBoard, NNBoard, L, N) :-
    random(1, L, R),
    replace_at_index(Board, R, '     ', NBoard),
    NN is N - 1,
    unsolve(NBoard, _, NNBoard, L, NN).