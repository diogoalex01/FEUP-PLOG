% to run, 'nudge.'

:- include('interface.pl').
:- include('logic.pl').
:- include('validateInput.pl').
:- include('ai.pl').
:- include('utilities.pl').
:- use_module(library(random)).

nudge :-
    mainMenu(1),
        board_mid(Board),
    gameOption(GameChoice),
        display_game(Board, 'One', white),
        game(Board, 'One', 'Two', _GameStatus, GameChoice).
