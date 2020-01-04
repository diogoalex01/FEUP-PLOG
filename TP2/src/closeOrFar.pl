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
find_CF(1, FFFFFFVars) :-
    (
        board_seven(Vars),
        replaceAll('close', ' far ', '     ', 1, 2, '     ', Vars, FVars),
        maplist(make_vars, FVars, FFVars),

        % variables and domains
        length(FFVars, L),
        N is round(sqrt(L)),
        domain(FFVars, 0, 2),
        R1 is 4 * N,
        R2 is 2 * R1,
        R3 is R2 + L,
        R4 is N - 4,
        length(NF, R1),
        length(NNF, R2),
        length(FFFVars, N),
        length(FFFFVars, L),
        length(FFFFFVars, R3),

        divide(FFVars, N, FFFVars),

        % contraints
        row_constraints(N, FFFVars, [], NF, R4),
        column_constraints(N, FFFVars, NF, NNF, R4),

        flatten_list(FFFVars, FFFFVars),
        append(NNF, FFFFVars, FFFFFVars),

        % solution search
        labeling([value(my_sel)], FFFFFVars),

        split_at(R2, FFFFFVars, [_,T]),
        replaceAll(0, 1, 2, '     ', 'close', ' far ', T, FFFFFFVars),
        write('\nSOLVABLE Close&Far:\n')
        ;
        write('\n* There\'s no solution for the given board. *')
    ).

% generates a random board that complies with Close&Far constraints
find_CF(2, FFFFFVars) :-
    ask_size(N),

    % variables and domains
    L is N * N,
    length(Vars, L),
    domain(Vars, 0, 2),
    length(FVars, N),
    R1 is 4 * N,
    R2 is 2 * R1,
    R3 is R2 + L,
    R4 is N - 4,
    length(NF, R1),
    length(NNF, R2),
    length(FFVars, L),
    length(FFFVars, R3),

    divide(Vars, N, FVars),

    % contraints
    row_constraints(N, FVars, [], NF, R4),
    column_constraints(N, FVars, NF, NNF, R4),

    flatten_list(FVars, FFVars),
    append(NNF, FFVars, FFFVars),

    % solution search
    labeling([value(my_sel)], FFFVars),

    split_at(R2, FFFVars, [_,T]),
    replaceAll(0, 1, 2, '     ', 'close', ' far ', T, FFFFVars),
    write('\nSOLVED Close&Far:\n'),
    display_game(FFFFVars),
    unsolve(FFFFVars, _, FFFFFVars, L, L),
    write('\nUNSOLVED Close&Far:\n').

% -------- Row Constraints -------- %

row_constraints(1, Vars, L, NL, N) :-
    nth1(1, Vars, Row),
    global_cardinality(Row, [0-N, 1-2, 2-2]),
    check_proximity(Row, L, NL).

row_constraints(Index, Vars, L, NL, N) :-
    nth1(Index, Vars, Row),
    global_cardinality(Row, [0-N, 1-2, 2-2]),
    check_proximity(Row, L, NNL),
    NewIndex is Index - 1,
    row_constraints(NewIndex, Vars, NNL, NL, N).

% ------ Columns Constraints ------ %

column_constraints(1, Vars, L, NL, N) :-
    get_column(Vars, 1, Column),
    global_cardinality(Column, [0-N, 1-2, 2-2]),
    check_proximity(Column, L, NL).

column_constraints(Index, Vars, L, NL, N) :-
    get_column(Vars, Index, Column),
    global_cardinality(Column, [0-N, 1-2, 2-2]),
    check_proximity(Column, L, NNL),
    NewIndex is Index - 1,
    column_constraints(NewIndex, Vars, NNL, NL, N).

% --------------------------------- %

% checks is the 'close' and 'far' elements are correctly placed
check_proximity(L, NL, NNL) :-
    element(C1, L, 1),
    element(C2, L, 1),
    C2 #> C1,
    element(F1, L, 2),
    element(F2, L, 2),
    F2 #> F1,
    T1 #= abs(C2 - C1),
    T2 #= abs(F2 - F1),
    T2 #> T1,
    append([C1], NL, NL2),
    append([C2], NL2, NL3),
    append([F1], NL3, NL4),
    append([F2], NL4, NNL).

% chooses N board positions randomnly and empties them
unsolve(NNBoard, _, NNBoard, _, 0).
unsolve(Board, NBoard, NNBoard, L, N) :-
    random(1, L, R),
    replace_at_index(Board, R, '     ', NBoard),
    NN is N - 1,
    unsolve(NBoard, _, NNBoard, L, NN).
