%%  Cluedo Project  %%

%nextQuestion(T,Q) is true if T is the type of the answer R, where R is the next question the program reccomends the player asks.
%   -If there are no possble answers, the type is 'error'
%   -If there is exactly one possible answer, the type is 'answer'
%   -If there are multiple answers, the type is 'question'
nextQuestion(error, [])     :-  possibleAnswers([]).
nextQuestion(answer, Q)     :-  possibleAnswers([Q|[]]).
nextQuestion(question, Q)   :-  possibleAnswers([A, B | T]),
                                chooseQuestion([A, B | T], Q).

%chooseQuestion(L, Q) return true if Q is an answer listed in L, where the Room of Q is the current room.
%   -If there are no possble questions to ask in the current room, R is none_in_current_room.
chooseQuestion([], none_in_current_room).
chooseQuestion([(C, W, R)|_], (C, W, R)) :- current_room(R).
chooseQuestion([(_, _, R)|T], Q) :- \+ current_room(R),
                                    chooseQuestion(T, Q).

%possibleAnswers(A) is true if A is a list of all the combinations of cards that could be the answer, in the order (Character, Weapon, Room)
possibleAnswers(A) :- characters(C),
                      weapons(W),
                      rooms(R),
                      suspects(C, CS),
                      suspects(W, WS),
                      suspects(R, RS),
                      combine(WS, RS, A1),
                      combine(CS, A1, A).

%combine(L1, L2, R) is true if R is a list of all the pairs of L1 and L2 arranged as (L1 element, L2 element).
combine([], _, []).
combine([H1|T1], L2, R) :- formPairs(H1, L2, C),
                           combine(T1, L2, R1),
                           concat(C, R1, R).

%concat(A, B, R) is true if R is list A concatenated with list B
concat([],R,R).
concat([H|T], B, [H|R]) :- concat(T, B, R).

%formPairs(E, L, R) returns true if R is the list L where every element of R is a pair (E, X), where X is an element of L
formPairs(_, [], []).
formPairs(E, [H|T], [(E, H)|R]) :- formPairs(E, T, R).

% suspects(L, R) Is true if R is all of the possible suspects in list L.
suspects([], []).
suspects([H|T], [H|R]) :-  \+ prop(_, has, H),
                          suspects(T, R).
suspects([H|T], R) :-  prop(_, has, H),
                          suspects(T, R).

%% Knowledge Base %%

% The player represented by the program.
me(p1).
% The current room.
current_room(kitchen).

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
