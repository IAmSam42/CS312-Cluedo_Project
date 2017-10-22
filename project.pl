%%  Cluedo Project  %%

%Work out all the possible answers left.
possibleAnswers(A) :- characters(C),
                      weapons(W),
                      rooms(R),
                      suspects(C, CS),
                      suspects(W, WS),
                      suspects(R, RS),
                      combine(WS, RS, A1),
                      combine(CS, A1, A).

combine([], _, []).
combine([H1|T1], L2, R) :- formPairs(H1, L2, C),
                           combine(T1, L2, R1),
                           concat(C, R1, R).

concat([],X,X).
concat([X|Y], Z, [X|W]) :- concat(Y, Z, W).

%formPairs(E, L, R) returns true of R is the list L where every elements is in a pair with X (X,_)
formPairs(_, [], []).
formPairs(X, [H|T], [(X, H)|R]) :- formPairs(X, T, R).

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
