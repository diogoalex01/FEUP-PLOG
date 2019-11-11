% to run, 'nudge.'

:- include('interface.pl').
:- include('utilities.pl').
:- include('logic.pl').
:- include('validateInput.pl').

nudge :-
    mainMenu(Choice),
    (
        Choice = 1 -> board_mid(_Var),
                    display_game(_Var, 'One', white),
                    game(_Var, 'One', 'Two', _GameStatus)
).
