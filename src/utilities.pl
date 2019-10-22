clearScreen :-
	write('\33\[2J').

getChar(Input) :-
  get_char(Input),
  get_char(_).

pressEnter :-
  write('Press <ENTER> to continue.'), nl, nl,
  get_char(_).