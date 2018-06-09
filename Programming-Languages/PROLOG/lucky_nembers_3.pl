move([X,T,Y,Z,K,W,R,I,G,O,P,A], 49 ,[Y,T,W,X,K,Z,R,I,G,O,P,A] ). 
move([T,X,K,Y,Z,R,W,I,G,O,P,A], 50 ,[T,Y,K,W,X,R,Z,I,G,O,P,A]).
move([T,K,R,I,G,X,O,Y,Z,P,W,A], 51 , [T,K,R,I,G,Y,O,W,X,P,Z,A]).
move([T,K,R,I,G,O,X,P,Y,Z,A,W], 52 , [T,K,R,I,G,O,Y,P,W,X,A,Z]).

prin([],0).
prin([H|T],X) :-
prin(T,Xnew),
X is Xnew*10+H.

opapas([98,103,98,71,103,71,71,114,71,121,114,121],_).
opapas(Config,[Move|Moves]) :-
    move(Config, Move, NextConfig),
	opapas(NextConfig,Moves).
	
diapragmateysi(Symbol,Y) :-	
string_to_list(Symbol,O),
length(Y,N), 
opapas(O,Y), 
!.