board_eight(
[ 
 '     ', '     ', '     ', '     ', '     ', '     ', '     ', '     ',
 '     ', '     ', '     ', '     ', '     ', '     ', '     ', '     ',
 '     ', '     ', '     ', '     ', '     ', '     ', '     ', '     ',
 '     ', 'close', '     ', '     ', '     ', '     ', '     ', '     ',
 '     ', 'close', '     ', '     ', '     ', '     ', '     ', '     ',
 '     ', '     ', '     ', '     ', '     ', '     ', '     ', '     ',
 '     ', '     ', '     ', '     ', '     ', '     ', '     ', '     ',
 '     ', '     ', '     ', '     ', '     ', '     ', '     ', '     '
]
).

board_seven(
[ 
 '     ', '     ', '     ', ' far ', '     ', '     ', '     ',
 '     ', '     ', '     ', '     ', '     ', '     ', ' far ',
 '     ', '     ', '     ', '     ', '     ', 'close', '     ',
 '     ', '     ', 'close', '     ', '     ', '     ', '     ',
 '     ', 'close', '     ', '     ', '     ', '     ', '     ',
 ' far ', '     ', '     ', '     ', '     ', '     ', '     ',
 '     ', '     ', '     ', '     ', 'close', '     ', '     '
]
).

board_six(
[ 
 ' far ', '     ', '     ', '     ', '     ', '     ',
 '     ', '     ', '     ', '     ', ' far ', '     ',
 '     ', '     ', '     ', 'close', '     ', '     ',
 '     ', '     ', '     ', '     ', '     ', 'close',
 '     ', ' far ', '     ', '     ', '     ', '     ',
 '     ', '     ', ' far ', '     ', '     ', '     '
]
).

display_border(0).
display_border(N) :-
    Next is N - 1,
    write(' ------ '),
    display_border(Next).

display_cell(Cell) :-
    write(Cell),
    write(' |'),
    write(' ').

display_row([], N) :-
    nl,
    display_border(N),
    nl.

display_row([Head|Tail], N) :-
    display_cell(Head),
    display_row(Tail, N).

display_board([], _).
display_board([Head|Tail], N) :-
    write('| '),
    display_row(Head, N),
    display_board(Tail, N).

display_game(Board) :-
    length(Board, L),
    N is round(sqrt(L)),
    divide(Board, N, NewBoard),
    display_border(N),
    nl,
    display_board(NewBoard, N),
    nl.

main_menu(Option) :-
    print_main_menu,
    write('Option: '),
    get_character(Choice),
    (
        Choice == '1',
        Option = 1,
        nl
        ;
        Choice == '2',
        Option = 2,
        nl
        ;
        Choice == '3',
        halt
        ;
        nl,
        write('Invalid input. Try again.\n'),
        press_enter,
        nl,
        main_menu(Option)
).

print_main_menu :-
    clear_screen,
    write(' ------- ------- ------- ------- ------- \n'),
    write('|                                       |\n'),
    write('| Nudge                                 |\n'),
    write('|                                       |\n'),
    write('| 1. Check Board                        |\n'),
    write('| 2. Generate Board                     |\n'),
    write('| 3. Exit                               |\n'),
    write('|                                       |\n'),
    write('|                                       |\n'),
    write('| Choose an option:                     |\n'),
    write(' ------- ------- ------- ------- ------- \n\n\n').

ask_size(N) :-
    write('Size of the board (N x N): '),
    read(NN),
    (
        NN > 3,
        NN < 20,
        N = NN
        ;
        nl,
        ask_size(N)
    ),
    nl
.


% [
% [1,7,3,9,5,1,7,3],
% [1,9,5,1,7,3,9,1],
% [5,1,7,3,9,5,1,7],
% [7,3,9,5,1,7,3,9],
% [9,5,1,7,3,9,5,1],
% [1,7,3,9,5,1,7,3],
% [3,9,5,1,7,3,9,5],
% [1,7,3,9,5,1,7,3],
% 9,5,3,1,1,7,5,3,9,5,3,1,7,3,1,9,5,1,9,7,3,9,7,5,1,7,5,3,9,5,3,1,
% [1,7,3,9,5,1,7,3],
% [3,9,5,1,7,3,9,5],
% [5,1,7,3,9,5,1,7],
% [7,3,9,5,1,7,3,9],
% [9,5,1,7,3,9,5,1],
% [1,7,3,9,5,1,7,3],
% [3,9,5,1,7,3,9,5],
% [5,1,7,3,9,5,1,7],
% 1,7,5,5,1,7,5,5,7,3,1,1,3,9,7,7,9,5,3,3,5,1,9,9,1,7,5,5,7,3,1,3,
% 1,5,1,7,3,9,5,1,7,3,9,5,1,7,3,9,5,1,7,3,9,5,1,7,3,9,5,1,7,3,9,7,
% 5,1,7,3,9,5,1,7,3,9,5,1,7,3,9,5,1,7,3,9,5,1,7,3,9,5,1,7,3,9,5,1
% ]