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

display_player(Player) :-
    nl,
    write(' Player: '),
    write(Player),
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

display_board([]).
display_board([Head|Tail], N) :-
    write('|  a  | '),
    display_row(Head),
    N1 is N + 1,
    display_board(Tail, N1).

display_game(_board, _current_player) :-
    nl,
    write('       ------- ------- ------- ------- -------\n'),
    write('      |   A   -   B   -   C   -   D   -   E   |\n'),
    display_border,
    nl,
    display_board(_board, 1),
    display_player(_current_player),
    nl.

mainMenu(Choice) :-
    printMainMenu,
    getChar(Char),
    (
        Char = '1' -> Choice = 1;
		Char = '2' -> Choice = 2;
		Char = '3' -> halt;
		nl,
		write('Invalid input. Try again.'), nl,
		pressEnter, nl,
		mainMenu(Choice)
).

printMainMenu :-
    clearScreen,
    write(' ------- ------- ------- ------- ------- '),nl,
    write('|                                       |'),nl,
    write('| Nudge                                 |'),nl,
    write('|                                       |'),nl,
    write('| 1. Start Game                         |'),nl,
    write('| 2. Help                               |'),nl,
    write('| 3. Exit                               |'),nl,
    write('|                                       |'),nl,
    write('|                                       |'),nl,
    write('| Choose an option:                     |'),nl,
    write(' ------- ------- ------- ------- ------- '),nl,
    nl, nl.