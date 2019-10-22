% to run, for instance:
    % board_end(_Var), display_game(_Var, 'player').

:- include('interface.pl').
:- include('utilities.pl').

nudge :-
    mainMenu(Choice),
    (
        Choice = 1 -> board_end(_Var),
                display_game(_Var, '1')
    ).