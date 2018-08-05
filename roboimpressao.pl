% Autor: Carine Webber
% Disciplina:IA
% UCS - CCET

% Robo de impress�o que realiza as seguintes opera��es:
%1) trocarToner(X,Y) : um robo(X) troca o toner da m�quina(Y). A m�quina deve estar sem
%toner, o rob� deve estar na m�quina com o toner novo.
%2) inserirPapel(X,Y,N) : o rob�(X) coloca n folhas de papel na m�quina(Y). O rob� deve estar na
%m�quina com as n folhas. Assume que a m�quina aceita qualquer quantidade de papel.
%3)fazerCopia(X,Y,N) : faz uma c�pia, utilizando uma folha de papel. O rob�(X) deve estar na
%m�quina(Y) que possui toner e tem pelo menos N folhas de papel.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exemplo: Planejamento de um robo
% % % % % % WARPLAN -  STRIPS

% predicado add/2
% add(fato_que_deve_ser_adicionado,a��o_executada).

% predicado del/2
% del(fato_que_deve_ser_deletado,a��o_executada).
%

% predicado can/2
% can(a��o,lista_de_pre-condicoes_separadas_por_&)

% predicado always/1
% always(fato_sempre_verdadeiro).

% predicado given/1
% given(fato_estado_inicial).

given(impressao,local(robo1,impressora_laser)).
given(impressao,local(robo2,impressora_hp)).
given(impressao,semToner(impressora_laser)).
given(impressao,semToner(impressora_hp)).
given(impressao,comPapel(impressora_laser,incompleto)).
given(impressao,comPapel(impressora_hp,completo)).
given(impressao,disponivel(impressora_hp)).

can(trocarToner(R,I),local(R,I)&robo(R)&maquina(I)&semToner(I)).
add(comToner(I),trocarToner(_,I)).
del(semToner(I),trocarToner(_,I)).

can(inserirPapel(R,I), local(R,I)&robo(R)&maquina(I)&comPapel(I,incompleto)).
add(comPapel(I,completo),inserirPapel(_,I)).
add(disponivel(I),inserirPapel(_,I)).
del(comPapel(I,incompleto),inserirPapel(_,I)).

can(fazerCopia(R,I,F), local(R,I)&robo(R)&maquina(I)&comToner(I)&comPapel(I,completo)).
add(comPapel(I,incompleto),fazerCopia(_,I,_)).
add(impressao(R,I,F),fazerCopia(R,I,F)).
del(comPapel(I,_),fazerCopia(R,I,F)).
del(disponivel(I), fazerCopia(_,I,_)).

imposs(local( X, Y )  &  local( X, Z )  &  notequal( Y, Z )  ).

always(robo(robo1)).
always(robo(robo2)).
always(maquina(impressora_laser)).
always(maquina(impressora_hp)).

exerc1:-
    plans(comToner(impressora_laser),impressao).

exerc2:-
    plans(comToner(impressora_laser)&comToner(impressora_hp),impressao).

exerc3 :-
    plans(comPapel(impressora_laser,completo),impressao).

exerc4 :-
    plans(comPapel(impressora_laser,completo)&comPapel(impressora_hp,completo),impressao).

exerc5 :-
    plans(disponivel(impressora_laser),impressao).

exerc6 :-
    plans(impressao(robo1,impressora_laser,100),impressao).

exerc7 :-
    plans(impressao(R1,impressora_laser,100)&impressao(R2,impressora_hp,200),impressao).
    
exerc8 :-
    plans(comToner(impressora_laser)&impressao(R2,impressora_hp,123),impressao).

