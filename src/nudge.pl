% to run, 'nudge.'

:- include('interface.pl').
:- include('utilities.pl').
:- include('logic.pl').
:- include('validateInput.pl').
:- use_module(library(random)).

nudge :-
    mainMenu(Choice),
        Choice = 1,
        board_mid(_Board),
    gameOption(GameChoice),
        display_game(_Board, 'One', white),
        game(_Board, 'One', 'Two', _GameStatus, GameChoice).
