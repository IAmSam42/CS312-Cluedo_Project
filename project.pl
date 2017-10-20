%%  Cluedo Project  %%

% suspects(L, R) Where R is all of the possible suspected things in list L.
suspects([], []).
suspects([H|T], [H|R]) :-  \+ prop(_, has, H),
                          suspects(T, R).
suspects([H|T], R) :-  prop(_, has, H),
                          suspects(T, R).

%% Knowledge Base %%

% The player represented by the program.
me(p1).

% List of all the characters
characters([mrs_scarlett, colonel_mustard, mrs_white, reverend_green, mrs_peacock, professor_plum]).

% List of all the weapons
weapons([candlestick, dagger, lead_pipe, revolver, rope, spanner]).

% List of all the rooms
rooms([kitchen, ballroom, conservatory, dinning_room, billiard_room, library, lounge, hall, study]).

%prop(player, has, card) means that 'player' has 'card' in their hand
prop(p1, has, lead_pipe).
prop(p1, has, dagger).
prop(p1, has, ballroom).
prop(p4, has, colonel_mustard).