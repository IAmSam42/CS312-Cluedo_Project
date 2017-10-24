%%  Cluedo Project  %%

%%Natural Language Interface

%A who has question needs to be identified as a query, so that it does not trigger an assignment.
statement([who, has | T0],T1,Ind,C0,C1) :-
    mp([query_has|T0],T1,Ind,C0,C1).
statement([what, is | T0],T1,Ind,C0,C1) :- %Ignore any 'what is'
    noun_phrase(T0,T1,Ind,C0,C1).
statement([what | T0],T1,Ind,C0,C1) :-%Ignore any 'what'
    noun_phrase(T0,T1,Ind,C0,C1).
statement([which | T0],T1,Ind,C0,C1) :- %Ignore any 'which'
    noun_phrase(T0,T1,Ind,C0,C1).
statement([which, is | T0],T1,Ind,C0,C1) :- %Ignore any 'which is'
    noun_phrase(T0,T1,Ind,C0,C1).
statement([what,are,the | T0],T1,Ind,C0,C1) :-
    mp(T0, T1, Ind, C0, C1).
%A statment may just be a noun_phrase.
statement(T0,T1,Ind,C0,C1) :-
    noun_phrase(T0,T1,Ind,C0,C1).

%noun_phrase(T0, T2, Ind, C0, C2) is true if:
%   the difference list between T0 and T2 is a noun phrase,
%   Ind is the individual reffered to by the noun phrase.
%   The difference list between C0 and C2 are the constrains imposed by the noun phrase.
%A noun phrase is a determiner followed by adjectives, followed by a noun, followed by modifying phrase.
noun_phrase(T0, T4, Ind, C0, C4) :-
    det(T0, T1, Ind, C0, C1),
    adjectives(T1, T2, Ind, C1, C2),
    noun(T2, T3, Ind, C2, C3),
    mp(T3, T4, Ind, C3, C4).

%Determiners can be ignored.
det([the | T],T,_,C,C).
det([my | T],T,_,C,C). %Possesive determiners add no aditional information in this context.
det(T,T,_,C,C).

%Adjectives is a list of adjectives, possible empty.
adjectives(T,T,_,C,C).
adjectives(T0,T2,Ind,C0,C2) :-
    adj(T0,T1,Ind,C0,C1),
    adjectives(T1,T2,Ind,C1,C2).

%A modifying phrase is either nothing or a relation between two objects followed by a noun phrase that describes the second object.
mp(T,T,_,C,C).
mp(T0,T2,O1,C0,C2) :-
    reln(T0,T1,O1,O2,C0,C1),
    noun_phrase(T1,T2,O2,C1,C2).
mp(T0,T2,O1,C0,C2) :-    %does/do have relationships
    reln(T0,T1,O1,O2,C0,C1),
    noun_phrase(T1,[have|T2],O2,C1,C2).

reln([query_has|T0],T0,O1,O2,[prop(O1,has,O2)|C],C).
reln([has|T0],T0,O1,O2,[add(O1,O2)|C],C).
reln([have|T0],T0,O1,O2,[add(O1,O2)|C],C).
reln([suspected,rooms|T0],T0,O1,O2,[rooms(O2), suspects(O2,A)|C],C).
reln([suspected,weapons|T0],T0,O1,O2,[weapons(O2), suspects(O2,A)|C],C).
reln([suspected,characters|T0],T0,O1,O2,[characters(O2), suspects(O2,A)|C],C).
reln([does|T0],T0,O1,O2,[prop(O2,has,O1)|C],C).
reln([do|T0],T0,O1,O2,[prop(O2,has,O1)|C],C).

%ask(Q, A) is true if A is the answer to the question A.
%Q is given as a string, which is then converted to a list of lower case atoms.
ask(Q,A) :-
    string_lower(Q, QLowerCase),
    tokenize_atom(QLowerCase, QList),
    statement(QList,[],A,C,[]),
    prove_all(C).
%A question may also end in a question mark.
ask(Q,A) :-
    string_lower(Q, QLowerCase),
    tokenize_atom(QLowerCase, QList),
    statement(QList,[?],A,C,[]),
    prove_all(C).

% prove_all(L) proves all elements of L against the database
prove_all([]).
prove_all([H|T]) :-
    call(H),      % built-in Prolog predicate calls an atom
    prove_all(T).

%%Notebook Functionality

%nextQuestion(T,Q) is true if T is the type of the answer R, where R is the next question the program reccomends the player asks.
%   -If there are no possble answers, the type is 'error'
%   -If there is exactly one possible answer, the type is 'solution'
%   -If there are multiple answers, the type is 'question'
nextQuestion(error, [])     :-  possibleAnswers([]).
nextQuestion(solution, Q)     :-  possibleAnswers([Q|[]]).
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

%suspects(L, R) Is true if R is all of the possible suspects in list L.
suspects([], []).
suspects([H|T], [H|R]) :-  \+ prop(_, has, H),
                           suspects(T, R).
suspects([H|T], R) :-  prop(_, has, H),
                       suspects(T, R).

%add(P, C) returns true if card C exists, player P exists, C does not already belong to someone, and if the prop(P, has, C) is added to the Knowledge Base.
add(P, C) :- isCard(C),
             isPlayer(P),
             \+ prop(_,has,C),
             assertz(prop(P, has, C)).

%isCard(C) returns true if the card C exists.
isCard(C) :- characters(L),
             contains(C, L).
isCard(C) :- weapons(L),
             contains(C, L).
isCard(C) :- rooms(L),
             contains(C, L).

%isPlayer(P) returns true if P is a player.
isPlayer(P) :- players(L),
               contains(P, L).

%contains(E, L) returns true if E is an element of L.
contains(E, [E|_]).
contains(E, [_|T]) :- contains(E, T).

%% Knowledge Base %%

% The player represented by the program.
me(p1).
% The current room.
current_room(library).

% List of all the players.
players([p1, p2, bob, p4]).

% List of all the characters
characters([mrs_scarlett, colonel_mustard, mrs_white, reverend_green, mrs_peacock, professor_plum]).

% List of all the weapons
weapons([candlestick, dagger, lead_pipe, revolver, rope, spanner]).

% List of all the rooms
rooms([kitchen, ballroom, conservatory, dining_room, billiard_room, library, lounge, hall, study]).

%prop(player, has, card) means that 'player' has 'card' in their hand
prop(p1, has, lead_pipe).
prop(p1, has, dagger).
prop(p1, has, ballroom).
prop(p4, has, colonel_mustard).

%%Dictionary

%NOUNS

%'I' is a noun, it is the value of me.
noun([i | T],T,Name,C,C) :- me(Name).

%'move' or 'question' both refer to the result of nextQuestion.
noun([move | T],T,(Type,Move),C,C) :- 
    nextQuestion(Type,Move).
noun([question | T],T,(Type,Move),C,C) :- 
    nextQuestion(Type,Move).

%'card(s)' implies the answer is a card.
noun([cards | T],T,Ind,[isCard(Ind)|C],C).
noun([card | T],T,Ind,[isCard(Ind)|C],C).

%'character(s)' implies the answer is a character.
noun([characters | T],T,Ind,[characters(Chars), contains(Ind,Chars)|C],C).
noun([character | T],T,Ind,[characters(Chars), contains(Ind,Chars)|C],C).

%'weapon(s)' implies the answer is a weapon.
noun([weapons | T],T,Ind,[weapons(Weapons), contains(Ind,Weapons)|C],C).
noun([weapon | T],T,Ind,[weapons(Weapons), contains(Ind,Weapons)|C],C).

%'room(s)' implies the answer is a room.
noun([rooms | T],T,Ind,[rooms(Rooms), contains(Ind,Rooms)|C],C).
noun([room | T],T,Ind,[rooms(Rooms), contains(Ind,Rooms)|C],C).

%A card name is the name of a card, if it exists.
noun([Card | T],T,Card,C,C) :- isCard(Card).

%Some cards are formed of two words seperated by a '_'. e.g. mrs_scarlett.
noun([Card1, Card2 | T],T,Card,C,C) :-
    atom_concat(Card1, '_', R1),
    atom_concat(R1, Card2, Card),
    isCard(Card).

%A noun is a players name.
noun([Name | T],T,Name,C,C) :- isPlayer(Name).


%ADJECTIVES

%'next' can be ignored.
adj([next | T],T,_,C,C).
