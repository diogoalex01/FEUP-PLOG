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
    write(' ------- ------- ------- ------- -------').

display_player(Player) :-
    write('Player '),
    write(Player),
    nl, nl.

display_cell(Cell) :-
    write('| '),
    write(Cell),
    write(' ').

display_row([]) :-
    write('|'),
    nl,
    display_border,
    nl.

display_row([Head|Tail]) :-
    display_cell(Head),
    display_row(Tail).

display_board([]).
display_board([Head|Tail]) :-
    display_row(Head),
    display_board(Tail).

% para correr, por ex: board_end(X),display_game(X,'1').

display_game(_board, _current_player) :-
    nl,
    display_border,
    nl,
    display_board(_board),
    display_player(_current_player),
    nl.
    %display_border,
    %nl,
    %display_board(_middle_board),
    %display_player(_current_player),
    %nl,
    %display_border,
    %nl,  
    %display_board(_final_board),
    %display_player(_current_player).