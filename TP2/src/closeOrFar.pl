% to run, 'closeOrFar.'
% consult('/Users/diogoalex/University/FEUP-PLOG/TP2/src/closeOrFar.pl').

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
find_CF(1, FFFFFVars) :-
    (
        board_beg(Vars),
        %display_game(Vars),
        replaceAll('close', ' far ', '     ', 1, 2, '     ', Vars, FVars),
        maplist(make_var, FVars, FFVars),

        % variables and domains
        length(FFVars, L),
        N is round(sqrt(L)),
        domain(FFVars, 0, 2),
                length(NF, 32),
        length(NNF, L),
        length(FFFVars, L),
        length(FFFFVars, 128),

        % contraints
        row_constraints(N, FFVars, N, [], NF),
        divide(FFVars, N, FFFVars),
        column_constraints(N, FFFVars, N, NF, NNF),
        append(NNF, FFFVars, FFFFVars),
        display_game(FFFVars),
        % solution search
        labeling([value(my_sel)], FFFFVars),

        replaceAll(0, 1, 2, '     ', 'close', ' far ', FFFFVars, FFFFFVars)
        ;
        write('\n* There\'s no solution for the given board. *')
    ).

% generates a random board that complies with Close&Far constraints
find_CF(2, FFFFVars) :-
    ask_size(N),

    % variables and domains
    L is N * N,
    length(Vars, L),
    length(FVars, L),
    domain(Vars, 0, 2),

    length(FVars, L),
    length(NF, 32),
    length(NNF, L),
    length(FFVars, 128),

    % contraints
    row_constraints(N, Vars, N, [], NF),
    divide(Vars, N, FVars),
    display_game(FVars),
    column_constraints(N, FVars, N, NF, NNF),

    append(NNF, Vars, FFVars),
    % solution search
    labeling([value(my_sel)], FFVars),

    replaceAll(0, 1, 2, '     ', 'close', ' far ', FFVars, FFFVars),
    write('\nSOLVED Close&Far:\n'),
    display_game(FFVars),
    unsolve(FFFVars, _, FFFFVars, L, L),
    write('\nUNSOLVED Close&Far:\n').

% -------- Row Constraints -------- %

row_constraints(1, Vars, N, L, NL):-
    sub_list(1, N, Vars, Row),
    global_cardinality(Row, [0-_, 1-2, 2-2]),
    check_proximity(Row, L, NL).

row_constraints(Index, Vars, N, L, NL):-
    IndexMax is N * Index,
    IndexMin is N * (Index - 1) + 1,
    sub_list(IndexMin, IndexMax, Vars, Row),
    global_cardinality(Row, [0-_, 1-2, 2-2]),
    check_proximity(Row, L, NNL),
    NewIndex is Index - 1,
    row_constraints(NewIndex, Vars, N, NNL, NL).

% ------ Columns Constraints ------ %

column_constraints(1, Vars, _, L, NL):- 
    extract(1, Vars, Column),
    write(Column), nl,
    global_cardinality(Column, [0-_, 1-2, 2-2]),
    check_proximity(Column, L, NL).

column_constraints(Index, Vars, N, L, NL):-
    extract(Index, Vars, Column),
    write(Index),
    write(Column), nl,
    global_cardinality(Column, [0-_, 1-2, 2-2]),
    check_proximity(Column, L, NNL),
    NewIndex is Index - 1,
    column_constraints(NewIndex, Vars, N, NNL, NL).

% test_all_columns(1, Vars, N, Columns, FinalColumns):- 
%     extract(1, Vars, Column),
%     %write(Column), nl,
%     global_cardinality(Column, [0-_, 1-2, 2-2]),
%     append(Columns, Column, FinalColumns).

% test_all_columns(Index, Vars, N, Columns, FinalColumns):-
%     extract(Index, Vars, Column),
%     %write(Column), nl,
%     check_palindrome(Column, N),
%     append(Columns, Column, NewColumns),
%     NewIndex is Index-1,
%     test_all_columns(NewIndex, Vars, N, NewColumns, FinalColumns).

% column_constraints(1, Vars, N, L, NL):-
%     write('1.6-----\n'),
%     get_column(1, N, N, Vars, _, Column),
%         write('1.7-----\n'),
%     global_cardinality(Column, [0-_, 1-2, 2-2]),
%         write('1.8-----\n'),
%     check_proximity(Column, L, NL),
%         write('1.9-----\n').

% column_constraints(Index, Vars, N, L, NL):-
%     write('1.1-----\n'),
%     get_column(Index, N, N, Vars, _, Column),
%         write('1.2-----\n'),
%     global_cardinality(Column, [0-_, 1-2, 2-2]),
%         write('1.3-----\n'),
%     check_proximity(Column, L, NNL),
%         write('1.4-----\n'),
%     NewIndex is Index - 1,
%         write('1.5-----\n'),
%     column_constraints(NewIndex, Vars, N, NNL, NL),
%         write('1.10-----\n').

% get_column(_, 0, _, _, SubList, FinalList):-
%     append(SubList, [], FinalList).
% get_column(I, 1, N, WholeList, SubList, FinalList):-
%     sub_list(I, I, WholeList, NewList),
%     append(NewList, SubList, NewNewList),
%     get_column(I, 0, N, WholeList, NewNewList, FinalList).

% get_column(I, Line, N, WholeList, SubList, FinalList):-
    % Index is I + N * (Line - 1),
    % sub_list(Index, Index, WholeList, NewList),
    % append(NewList, SubList, NewNewList),
    % NewLine is Line - 1,
    % get_column(I, NewLine, N, WholeList, NewNewList, FinalList).

% --------------------------------- %

% checks is the 'close' and 'far' elements are correctly placed
check_proximity(L, NL, NNL) :-
    element(C1, L, 1),
    element(C2, L, 1),
    C1 #> C2,
    element(F1, L, 2),
    element(F2, L, 2),
    F1 #> F2,
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

extract(K,X,COLUMN):- 
     findall(Elem , (member(X1,X), nth1(K,X1,Elem)) , COLUMN).
