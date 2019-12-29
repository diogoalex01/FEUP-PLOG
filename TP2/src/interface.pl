board_beg(
[ 
 '     ', '     ', '     ', '     ', '     ', '     ', '     ', '     ',
 '     ', 'close', '     ', '     ', '     ', '     ', '     ', '     ',
 '     ', ' far ', '     ', '     ', '     ', '     ', '     ', '     ',
 '     ', '     ', '     ', '     ', '     ', '     ', '     ', '     ',
 '     ', '     ', '     ', '     ', '     ', '     ', '     ', '     ',
 '     ', '     ', '     ', '     ', '     ', '     ', '     ', '     ',
 '     ', '     ', '     ', '     ', '     ', '     ', '     ', '     ',
 '     ', '     ', '     ', '     ', '     ', '     ', '     ', '     '
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

main_menu :-
    print_main_menu,
    write('Option: '),
    get_character(Char),
    (
        Char = '1',
        nl
        ;
        Char = '2',
        halt
        ;
        nl,
        write('Invalid input. Try again.\n'),
        press_enter,
        nl,
        main_menu
).

print_main_menu :-
    clear_screen,
    write(' ------- ------- ------- ------- ------- \n'),
    write('|                                       |\n'),
    write('| Nudge                                 |\n'),
    write('|                                       |\n'),
    write('| 1. Start Game                         |\n'),
    write('| 2. Exit                               |\n'),
    write('|                                       |\n'),
    write('|                                       |\n'),
    write('| Choose an option:                     |\n'),
    write(' ------- ------- ------- ------- ------- \n\n\n').
