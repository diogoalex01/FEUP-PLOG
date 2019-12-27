board_beg(
[
    [' F ', '   ', '   ', '   ', '   '],
    ['   ', '   ', '   ', ' F ', '   '],
    ['   ', '   ', ' C ', '   ', '   '],
    ['   ', '   ', '   ', '   ', ' C '],
    ['   ', ' F ', '   ', '   ', '   '],
    ['   ', '   ', ' F ', '   ', '   '] 
]).

display_border :-
    write(' --- ----- ----- ----- ----- -----').

display_cell(Cell) :-
    write(Cell),
    write(' |'),
    write(' ').

display_row([]) :-
    nl,
    display_border,
    nl.

display_row([Head|Tail]) :-
    display_cell(Head),
    display_row(Tail).

display_board([], _).
display_board([Head|Tail], N) :-
    format('| ~D | ', [N]),
    display_row(Head),
    N1 is N + 1,
    display_board(Tail, N1).

display_game(Board) :-
    write('     ----- ----- ----- ----- -----\n'),
    write('    |  A  -  B  -  C  -  D  -  E  |\n'),
    display_border,
    nl,
    display_board(Board, 1), % 1 - starting row number
    nl.

mainMenu :-
    printMainMenu,
    write('Option: '),
    getChar(Char),
    (
        Char = '1',
        nl
        ;
        Char = '2',
        halt
        ;
        nl,
        write('Invalid input. Try again.\n'),
        pressEnter,
        nl,
        mainMenu
).

printMainMenu :-
    clearScreen,
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
