problem([Head|[]],Head).
problem([Head,H|[]],Sum) :-
   member(X,[1,2,3,4]),
   ( X =:= 1 ->
     Sum is Head+H
    ; X =:= 2 ->
     Sum is Head-H
    ; X =:= 3 ->
     Sum is Head*H
	; X =:= 4 ->
	( H =\= 0 ->
     Sum is Head / H
    ; false )	 
    ).
problem([Head,H|[Y|Ys]],Sum) :-
   member(X,[1,2,3,4,5,6,7,8]),
   ( X =:= 1 ->
     problem([H|[Y|Ys]],Sumnew),
     Sum is Head+Sumnew
	; X =:= 2 ->
  	Z is Head + H ,
	problem([Z|[Y|Ys]],Sum)
    ; X =:= 3 ->
     problem([H|[Y|Ys]],Sumnew),
	 Sum is Head-Sumnew
	; X =:= 4 -> 
	Z is Head - H ,
	   problem([Z|[Y|Ys]],Sum)
    ; X =:= 5 ->
     problem([H|[Y|Ys]],Sumnew),
	 Sum is Head * Sumnew
	; X =:= 6 -> 
	Z is Head * H ,
	   problem([Z|[Y|Ys]],Sum) 
	; X =:= 7 ->
	 problem([H|[Y|Ys]],Sumnew),
	( Sumnew =\= 0 ->
     Sum is Head / Sumnew
    ; false )
    ; X =:= 8 -> 
	( H =\= 0 ->
     Z is Head / H,
	 problem([Z|[Y|Ys]],Sum)
    ; false )
    ).

opa(Ar,L) :-
  member(X,[1,10,100,1000,10000,100000,1000000,10000000,100000000,1000000000]),
  Q is div(Ar,X),
  ( Q=\=0 ->
  append([Q],K,L)
  ; false
  ),
  Z is mod(Ar,X),
  ( Z =\= 0 ->
    ( Z*10 < X -> 
    append([0],P,K),
    opa(Z,P)
	; opa(Z,K))
  ;	K=[]
  ).
  
bouzouk(Lista,X) :-
  problem(Lista,X),
  (X =:= 100 ->
  !
  ; X =:= 100.0 ->
  X is 100,
  !
  ; true
  ).  
  
keftes(Ar,X) :-
  opa(Ar,L),
  bouzouk(L,X),  
 (X =:= 100 ->
  !
  ; X =:= 100.0 ->
  !
  ; true
  ). 
  
check([],true).
check([Head|Tail],S):-
    ( Head=:= 100 ->
	 S=false
	; Head=:= 100.0 ->
	 S=false
	; check(Tail,S)
	).
	
karabouzouk(Ar,Ap) :-
  findall(X,keftes(Ar,X),L),
  check(L,Ap).
  
lucky_numbers([],[]).  
lucky_numbers([Head|Tail],L) :-  
    karabouzouk(Head,Ap),
	append([Ap],K,L),
	lucky_numbers(Tail,K).