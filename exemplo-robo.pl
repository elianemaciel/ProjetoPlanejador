
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exemplo: Planejamento de um robo
% % % % % % WARPLAN -  STRIPS

add(  onfloor,  climboff( _ )  ).
add(  at( robot, P ),  goto1( P, _ )  ).
add(  nextto( robot, X ),  goto2( X, _ )  ).
add(  nextto( X, Y ),  pushto( X, Y, _ )  ).
add(  nextto( Y, X ),  pushto( X, Y, _ )  ).
add(  status( S, on ),  turnon( S )  ).
add(  on( robot, B ),  climbon( B )  ).
%add(  inroom( robot,  R2 ),  gothrough( D, R1, R2 )  ).
add(  inroom( robot,  R2 ),  gothrough( _, _, R2 )  ).
del(  at( X, _ ),  U  )    :-    moved( X, U  ).
del(  nextto( Z, robot ),  U  )  :-  !,  del( nextto( robot, Z ),  U ).
del(  nextto( robot,  X ),  pushto( X, _, _ )  )    :-    !,   fail.
del(  nextto( robot,  B ),  climbon( B )  )    :-    !,   fail.
del(  nextto( robot,  B ),  climboff( B )  )    :-    !,   fail.
del(  nextto( X, _ ),  U  )    :-    moved(  X,  U  ).
del(  nextto( _, X ),  U  )    :-    moved(  X,  U  ).
del(  on( X, _ ),  U  )   :-   moved(  X,  U  ).
del(  onfloor,  climbon( _ )  ).
del(  inroom( robot, _ ),  gothrough( _, _, _ )  ).
%del(  inroom( robot, Z ),  gothrough( D, R1, R2 )  ).
del(  status( S, _ ),  turnon( S )  ).

moved(  robot,  goto1( _, _ )  ).
moved(  robot,  goto2( _, _ )  ).
%moved(  robot,  goto1( P, R )  ).
%moved(  robot,  goto2( X, R )  ).
moved(  robot,  pushto( _, _, _ )  ).
moved(  X,  pushto( X, _, _ )  ).
moved(  robot,  climbon( _ )  ).
moved(  robot,  climboff( _ )  ).
moved(  robot,  gothrough( _, _, _)  ).
%moved(  robot,  gothrough( D, R1, R2)  ).
can(  goto1( P, R ),
        locinroom( P, R )  &  inroom( robot, R )  &  onfloor  ).
can(  goto2( X, R ),
        inroom( X, R )  &  inroom( robot, R )  &  onfloor  ).
can(  turnon( lightswitch(S) ),
        on( robot, box(1) )  &  nextto( box(1), lightswitch(S) )  ).
can(  pushto( X, Y, R ),
        pushable( X )  &  inroom( Y, R )  &  inroom( X, R )  &
        nextto( robot, X )  &  onfloor  ).
can(  gothrough( D, R1, R2 ),
        connects( D, R1, R2 )  &  inroom( robot, R1 )  &
        nextto( robot, D )  &  onfloor  ).
can(  climboff( box(B) ),  on( robot, box(B) )  ).
can(  climbon( box(B) ),  nextto( robot, box(B) )  &  onfloor  ).

always(  inroom( D, R1 )  )    :-    always(  connects( D, R1, _ )  ).
always(  connects( D, R2, R1 )  )    :-    connects1(  D, R1, R2  ).
always(  connects( D, R1, R2 )  )    :-    connects1(  D, R1, R2  ).
always(  pushable( box(_) )  ).
always(  locinroom( point(N), room(1) )  )    :-    range(  N, 1, 5  ).
always(  locinroom( point(6), room(4) )  ).
always(  inroom( lightswitch(1), room(1) )  ).
always(  at( lightswitch(1), point(4) )  ).

connects1(  door(N), room(N), room(5)  )    :-    range(  N, 1, 4  ).

range(  M, M, _  ).
range(  M, L, N  )    :-
        L  <  N,    L1  is  L + 1,    range(  M, L1, N  ).

imposs(  at( X, Y )  &  at( X, Z )  &  notequal( Y, Z )  ).

given(  strips1,  at( box(N), point(N) )  )   :-   range(  N, 1, 3  ).
given(  strips1,  at( robot, point(5) )  ).
given(  strips1,  inroom( box(N), room(1) )  )  :-  range(  N, 1, 3  ).
given(  strips1,  onfloor  ).
given(  strips1,  status( lightswitch(1), off )  ).
given(  strips1,  inroom( robot, room(1) )  ).

% A few tests.
teste1:-   plans( at( robot, point(5) ),  strips1 ).
teste2:-   plans( at( robot, point(4) ),  strips1 ).
teste3:-   plans( status( lightswitch(1), on ),  strips1 ).
teste4:-   plans( at(robot, point(6) ),  strips1 ).
teste5:-   plans( nextto( box(1), box(2) ) &
           nextto( box(3), box(2) ),  strips1 ).



