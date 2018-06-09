danger(File,X) :-
    open(File, read, Stream),
    read_line(Stream, [N, M]),
    read_segs(Stream, M, Combos),
	numlist(1,N,Z),
	reverse(Z,W),
	findall(X,fundercats(X,T,Z,W),L),
    problem(Combos,L,X),
    close(Stream).

read_segs(Stream, M, Combos) :-
    ( M > 0 ->
	Combos = [Combo|Rest],
        read_line(Stream, [K|Combo]),
	length(Combo, K), %% just an assertion for for extra safety 
        M1 is M - 1,
        read_segs(Stream, M1, Rest)
    ; M =:= 0 ->
	Combos = []
    ).

read_line(Stream, List) :-
    read_line_to_codes(Stream, Line),
    atom_codes(A, Line),
    atomic_list_concat(As, ' ', A),
    maplist(atom_number, As, List).

fundercats(X,N,Z,W) :-
length1(X,N,W),
subseq(X,Z).

length1(L,N,Z) :- 
member(N,Z),
length(L,N).

subseq([], []).
subseq([Item | RestX], [Item | RestY]) :-
subseq(RestX, RestY).
subseq(X, [_ | RestY]) :-
subseq(X, RestY).
	
notsubseq(_,[]).   
notsubseq(X,[Head|Tail]) :-
    \+ subseq(Head,X),
	notsubseq(X,Tail).
	
problem(Combos,L,X):-
   member(X,L),
   notsubseq(X,Combos).
