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
find_CF(1, FFFFFFVars) :-
    (
        board_six(Vars),
        %display_game(Vars),
        replaceAll('close', ' far ', '     ', 1, 2, '     ', Vars, FVars),
        maplist(make_var, FVars, FFVars),
        % variables and domains
        length(FFVars, L),
        N is round(sqrt(L)),
        domain(FFVars, 0, 2),

        R1 is 4 * N,
        length(NF, R1),
        R2 is 2 * R1,
        length(NNF, R2),
        length(FFFVars, N),
        length(FFFFVars, L),
        R3 is R2 + L,
        length(FFFFFVars, R3),
        R4 is N - 4,

        write(FFVars), nl,
        divide(FFVars, N, FFFVars),
        % contraints
        write('------------1----------\n'),
        row_constraints(N, FFFVars, [], NF, R4),
        write('------------2----------\n'),
        write('------------3----------\n'),
        write(FFFVars),nl,
        write('------------4----------\n'),
        column_constraints(N, FFFVars, NF, NNF, R4),
        write('------------5----------\n'),
        flatten(FFFVars, FFFFVars),
        write(FFFFVars), nl,
        write('------------6----------\n'),
        append(NNF, FFFFVars, FFFFFVars),
        write('------------7----------\n'),
        % solution search
        labeling([value(my_sel)], FFFFFVars),
        write('------------8----------\n'),
        split_at(R2, FFFFFVars, [_,T]),
        replaceAll(0, 1, 2, '     ', 'close', ' far ', T, FFFFFFVars)
        ;
        write('\n* There\'s no solution for the given board. *')
    ).

% generates a random board that complies with Close&Far constraints
find_CF(2, FFFFFVars) :-
    ask_size(N),

    % variables and domains
    L is N * N,
    length(Vars, L),
    length(FVars, N),
    domain(Vars, 0, 2),

    R1 is 4 * N,
    length(NF, R1),
    R2 is 2 * R1,
    length(NNF, R2),
    length(FFVars, L),
    R3 is R2 + L,
    length(FFFVars, R3),
    R4 is N - 4,

    % contraints
    write('------------1----------\n'),
    divide(Vars, N, FVars),
    write('------------2----------\n'),
    row_constraints(N, FVars, [], NF, R4),
    write('------------3----------\n'),
    write(FVars),
    write('------------4----------\n'),
    column_constraints(N, FVars, NF, NNF, R4),
    write('------------5----------\n'),
    flatten(FVars, FFVars),
    write('------------6----------\n'),

    append(NNF, FFVars, FFFVars),
    write('------------7----------\n'),
    % solution search
    labeling([value(my_sel)], FFFVars),
    write('------------8----------\n'),

    split_at(R2, FFFVars, [_,T]),
    write('------------9----------\n'),
    replaceAll(0, 1, 2, '     ', 'close', ' far ', T, FFFFVars),
    write('\nSOLVED Close&Far:\n'),
    display_game(FFFFVars),
    unsolve(FFFFVars, _, FFFFFVars, L, L),
    write('\nUNSOLVED Close&Far:\n').

% -------- Row Constraints -------- %

% row_constraints(1, [Row|_], _, L, NL):-
%     write('---'), write(1), nl,
%     write(Row), nl,
%     global_cardinality(Row, [0-_, 1-2, 2-2]),
%     check_proximity(Row, L, NL).

% row_constraints(Index, [Row|T], N, L, NL):-
%     write('---'), write(Index), nl,
%     write(Row), nl,
%     global_cardinality(Row, [0-_, 1-2, 2-2]),
%     check_proximity(Row, L, NNL),
%     NewIndex is Index - 1,
%     row_constraints(NewIndex, T, N, NNL, NL).

row_constraints(1, Vars, L, NL, N) :-
    nth1(1, Vars, Row),
    write('---'), write(1), nl,
    write(Row), nl,
    check_proximity(Row, L, NL),
    global_cardinality(Row, [0-N, 1-2, 2-2]).

row_constraints(Index, Vars, L, NL, N) :-
    nth1(Index, Vars, Row),
    write('---'), write(Index), nl,
    write(Row), nl,
    check_proximity(Row, L, NNL),
    global_cardinality(Row, [0-N, 1-2, 2-2]),
    NewIndex is Index - 1,
    row_constraints(NewIndex, Vars, NNL, NL, N).

% ------ Columns Constraints ------ %

column_constraints(1, Vars, L, NL, N) :-
    columnN(Vars, 1, Column),
    write('---'), write(1), nl,
    write(Column), nl,
    check_proximity(Column, L, NL),
    global_cardinality(Column, [0-N, 1-2, 2-2]).

column_constraints(Index, Vars, L, NL, N) :-
    columnN(Vars, Index, Column),
    write('---'), write(Index), nl,
    write(Column), nl,
    check_proximity(Column, L, NNL),
    global_cardinality(Column, [0-N, 1-2, 2-2]),
    NewIndex is Index - 1,
    column_constraints(NewIndex, Vars, NNL, NL, N).

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

extract(Index, List, Column) :-
    findall(Elem, (member(L1, List), nth1(Index, L1, Elem)), Column).

columnN([],_,[]).
columnN([H|T], I, [R|X]):-
   rowN(H, I, R), 
columnN(T,I,X).

rowN([H|_],1,H):-!.
rowN([_|T],I,X) :-
    I1 is I-1,
    rowN(T,I1,X).