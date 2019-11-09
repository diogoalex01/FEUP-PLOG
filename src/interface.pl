board_beg(
[
    ['     ', '     ', '     ', '     ', '     '],
    ['     ', white, white, white, '     '],
    ['     ', '     ', '     ', '     ', '     '],
    ['     ', black, black, black, '     '],
    ['     ', '     ', '     ', '     ', '     '] 
]).

board_mid(
[
    ['     ', '     ', '     ', '     ', '     '],
    ['     ', white, '     ', black, '     '],
    ['     ', white, white, '     ', '     '],
    ['     ', black, black, '     ', '     '],
    ['     ', '     ', '     ', '     ', '     '] 
]).

board_end(
[
    ['     ', '     ', '     ', '     ', '     '],
    ['     ', white, '     ', '     ', '     '],
    ['     ', '     ', '     ', black, white],
    ['     ', black, '     ', '     ', white],
    ['     ', '     ', '     ', '     ', black]
]).

display_border :-
    write(' ----- ------- ------- ------- ------- -------').

display_player(Player, Color) :-
    nl,
    write('* Player: '),
    write(Player),
    write(' ('),
    write(Color),
    write(') *'),
    nl, nl.

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
    format('|  ~D  | ', [N]),
    display_row(Head),
    N1 is N + 1,
    display_board(Tail, N1).

display_game(_board, _current_player, Color) :-
    write('       ------- ------- ------- ------- -------\n'),
    write('      |   A   -   B   -   C   -   D   -   E   |\n'),
    display_border,
    nl,
    display_board(_board, 1), % 1 - starting row number
    display_player(_current_player, Color).

mainMenu(Choice) :-
    printMainMenu,
    write('Option: '),
    getChar(Char),
    (
        Char = '1' -> Choice = 1,
        nl
        ;
        Char = '2' -> Choice = 2
        ;
        Char = '3' -> halt
        ;
        nl,
        write('Invalid input. Try again.\n'),
        pressEnter,
        nl,
        mainMenu(Choice)
).

printMainMenu :-
    clearScreen,
    write(' ------- ------- ------- ------- ------- \n'),
    write('|                                       |\n'),
    write('| Nudge                                 |\n'),
    write('|                                       |\n'),
    write('| 1. Start Game                         |\n'),
    write('| 2. Help                               |\n'),
    write('| 3. Exit                               |\n'),
    write('|                                       |\n'),
    write('|                                       |\n'),
    write('| Choose an option:                     |\n'),
    write(' ------- ------- ------- ------- ------- \n\n\n').
