%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WARPLAN-algorithm
% Disciplina IA I - UCS


:- op(700,xfy,&).
:- op(650,yfx,=>).

% Problem solver entry: Generation and output of a plan

plans(C,_) :-
        inconsistent(C,true), !, nl,
        write('impossible'), nl, nl.

plans(C,T) :-
        plan(C,true,T,T1), nl,
        output(T1), !, nl, nl.
plans( _, _ )   :-
   write( 'Cannot do this.' ), nl.


output(Xs => X) :-
        !, output1(Xs),
        write(X),
        write('.'), nl.

output1(Xs => X) :-
        !, output1(Xs),
        write(X),
        write(';'), nl.

output1(X) :-
        !, write(X),
        write(';'), nl.


% Entry point to the main recursive loop

plan(X&C,P,T,T2) :-
        !, solve(X,P,T,P1,T1), 
        plan(C,P1,T1,T2).

plan(X,P,T,T1) :-
        solve(X,P,T,_,T1).

% Ways of solving a goal

solve(X,P,T,P,T) :- always(X).
solve(not_equal(X,Y),P,T,P,T) :- not_equal(X,Y).
solve(X,P,T,P1,T) :-
        holds(X,T),
        and(X,P,P1).

solve(X,P,T,X&P,T1) :-
        add(X,U),
        achieve(X,U,P,T,T1).

% Methods of achieving an action
%   By extension

achieve(_,U,P,T,T1=>U) :-
        preserves(U,P),
        can(U,C),
        \+ (inconsistent(C,P)),
        plan(C,P,T,T1),
        preserves(U,P).

%   By insertion

achieve(X,U,P,T=>V,T1=>V) :-
        preserved(X,V),
        retrace(P,V,P1),
        achieve(X,U,P1,T,T1),
        preserved(X,V).

% Check if a fact holds in a certain state

holds(X,_=>V) :-
        add(X,V).

holds(X,T=>V) :-
        !, preserved(X,V),
        holds(X,T),
        preserved(X,V).

holds(X,T) :-
        given(T,X).

% Prove that an action preserves a fact

preserves(U,X&C) :-
        preserved(X,U),
        preserves(U,C).

preserves(_,true).

preserved(X,V) :- check(pres(X,V)).
pres(X,V):- mkground(X&V), \+ del(X,V).


% Retracing a goal already achieved

retrace(P,V,P2) :-
        can(V,C),
        retrace(P,V,C,P1),
        append(C,P1,P2).

retrace(X&P,V,C,P1) :-
        add(Y,V),
        equiv(X,Y), !,
        retrace(P,V,C,P1).

retrace(X&P,V,C,P1) :-
        elem(Y,C),
        equiv(X,Y), !,
        retrace(P,V,C,P1).

retrace(X&P,V,C,X&P1) :-
        retrace(P,V,C,P1).

retrace(true,_,_,true).

% Consistency with a goal already achieved

inconsistent(C,P) :-
   mkground(C&P),
        imposs(S),
        check(intersect(C,S)),
        implied(S,C&P), !.


% Utility routines

and(X,P,P) :-
        elem(Y,P),
        equiv(X,Y), !.
and(X,P,X&P).

append(X&C,P,X&P1) :-
        !, append(C,P,P1).
append(X,P,X&P).

elem(X,Y&_) :-
        elem(X,Y).
elem(X,_&C) :-
        !, elem(X,C).
elem(X,X).

implied(S1&S2,C) :-
        !, implied(S1,C),
        implied(S2,C).
implied(X,C) :-
        elem(X,C).
implied(not_equal(X,Y),_) :-
        not_equal(X,Y).

intersect(S1,S2) :-
        elem(X,S1),
        elem(X,S2).

not_equal(X,Y) :-
        \+ (X=Y),
        \+ (X='$VAR'(_)),
        \+ (Y='$VAR'(_)).

mkground(X):- numbervars(X,0,_).

check(X):- \+ (\+ X).

equiv(X,Y) :-
        \+ (nonequiv(X,Y)).

nonequiv(X,Y) :-
        numbervars(X&Y,0,_),
        X=Y, !, fail.

nonequiv(_,_).

