% to run, 'nudge.'

:- include('interface.pl').
:- include('logic.pl').
:- include('validateInput.pl').
:- include('ai.pl').
:- include('utilities.pl').

:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).

nudge :-
    mainMenu(1),
        board_beg(Board),
    gameOption(GameChoice),
    levelOption(LevelChoice),
        display_game(Board, 'One', white),
        game(Board, 'One', 'Two', _GameStatus, GameChoice, LevelChoice).
