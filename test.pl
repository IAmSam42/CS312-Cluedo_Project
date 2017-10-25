/*	
********** Test Class **********


	returns the list of characters/weapons/rooms
?- characters(C).
?- weapons(W).
?- rooms(R).


	isCard? 
	EXPECTED =
		mrs_white,candlestick,study = true
		notACard = false
?- isCard(mrs_white).
?- isCard(candlestick).
?- isCard(study).
?- isCard(notACard).


	add card to local database (add mrs_white to p2)
	check if p2 has mrs_white
	EXPECTED = p2
?- add(p2,mrs_white).
?- ask("who has mrs white",A).


	A is a list of triples of all possible solutions
	B returns the first triple of the current_room
?- possibleAnswers(A),chooseQuestion(A,B).


	A is the list of triples of all possible solutions
	EXPECTED T = question
	where T can either be a solution or question
	Q reutnrs the first triple of the current_room
?- possibleAnswers(A),nextQuestion(T,Q).


**USES DUPLICATE LISTS 
	where T has 1 question left -> solution
		where T returns solution
	EXPECTED T = question
?- possibleAnswers(A),nextQuestion(T,Q).
?- ask("p1 has the study",A).
	EXPECTED T = solution
	Q = (mrs_scarlett, candlestick, study)
?- possibleAnswers(A),nextQuestion(T,Q).


	no possible answers -> error 
	EXPECTED T = error 
?- ask("p1 has the candlestick",A).
?- possibleAnswers(A),nextQuestion(T,Q).


********** Natural Language Interface Tests **********


	only a noun phrase (valid card?)
	EXPECTED = true
?- ask("the dagger",A).
	EXPECTED = false.
?- ask("the notacard",A).


	change current_room after ask()
	"I am/Im in the x"
	Default = x (currently set to library)
	EXPECTED = default
?- current_room(R).
	1. I am case
	EXPECTED = study
?- ask("I am in the study",A).
?- current_room(R).
	2. Im case
	EXPECTED = ballroom
?- ask("Im in the ballroom",A).
?- current_room(R).


	"who has card x" (from knowledge base)
	EXPECTED = p1.
?- ask("who has the dagger",A).
	EXPECTED = p4.
?- ask("who has colonel mustard",A).


	distributing cards locally
	"x has the y" 
		revolver card 
	EXPECTED = error/NULL
?- ask("who has the revolver",A).
	EXPECTED = p2
?- ask("p2 has the revolver",A).
?- ask("who has the revolver",A).


	"I have the x"
	EXPECTED = p1
?- ask("I have the candlestick",A).
?- ask("who has the candlestick",A).	


	Move suggestion "what is my next move"
	EXPECTED = a triple from the current room
?- current_room(A).
?- ask("what is my next move",A).


	Move suggestion using shortened noun form "question/move"
	EXPECTED = a triple fron the current room
?- ask(question,A).
?- ask(move,A).


	Suspected characters/weapons/rooms (things not known in knowledge base)
	EXPECTED = \+ Col Mustard
?- add(p2,colonel_mustard).
?- ask("what are the suspected characters",A).
	EXPECTED = \+ lead_pipe,dagger
?- add(p1,lead_pipe).
?- add(p1,dagger).
?- ask("what are the suspected weapons",A).
	EXPECTED = \+ current_room()
?- ask("what are the suspected rooms",A).
	Suspects after adding to knowledge base
?- ask("p2 has the candlestick",A.
?- ask("p2 has the revolver",A).
	EXPECTED A = rope, spanner
?- ask("what are the suspected weapons",A).


	"what cards does x have"
	EXPECTED = lead_pipe, dagger, ballroom
?- add(p1,lead_pipe).
?- add(p1,dagger).
?- add(p1,ballroom).
?- ask("what cards does p1 have",A).
	Adding to knowledge base
	EXPECTED = lead_pipe, dagger, ballroom, candlestick, study
?- ask("p1 has the candlestick",A).
?- ask("I have the study",A).
?- ask("what cards does p1 have",A).


	***NOUNS***


	"i" 	*must be lowercase i
	EXPECTED = me = p1
-? ask(i,A).


	"cards/card"
	EXPECTED = all cards from chars,weapons,rooms
-? ask(cards,A).
-? ask(card,A).


	"characters/character"
	EXPECTED = all character cards
-? ask(characters,A).
-? ask(character,A).


	"weapons/weapon"
	EXPECTED = all weapon cards
-? ask(weapons,A).
-? ask(weapon,A).


	"rooms/room"
	EXPECTED = all room cards 
-? ask(rooms,A).
-? ask(room,A).



*/