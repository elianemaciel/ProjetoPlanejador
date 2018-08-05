% Autor: Eliane Maciel
% Disciplina:IA
% UCS - CCET
% Trabalho de Planejamento


% PLANEJAMENTO UTILIZANDO O ALGORITMO POP
% Simulação de Coleta de Lixo na CODECA
% Objetivo: simular a coleta de lixo da cidade pelos caminhões da CODECA. Modele um
% problema de planejamento para representar a coleta de lixo dos caminhões da
% CODECA. Você deve representar áreas da cidade (selecione uma região, um bairro),
% posicione contêineres de lixo orgânico e seletivo (vazios ou cheios de lixo) e caminhões
% para os dois tipos de lixo (agentes do planejamento). Os caminhões devem ser capazes
% de se deslocar e recolher lixo das lixeiras que estiverem cheias. Uma vez que um
% caminhão tenha recolhido todo o lixo ele deve retornar a garagem. Você pode
% adicionar outras opções, tais como caminhões de lixo que lavam os contêineres sujos
% de tempos em tempos.
% Modele o ambiente físico contendo quadras, contêineres e casas, onde moram as
% pessoas que depositam o lixo nos contêineres (objetos do sistema). Os agentes do
% sistema são pró-ativos e possuem estados que indicam as atividades nas quais estão
% engajados:
% – caminhão coletor orgânico: coleta lixo e retorna para a garagem para esvaziar o
% compactador quando estiver cheio;
% – caminhão coletor reciclável: coleta lixo reciclável e retorna para a garagem para
% esvaziar o compactador quando estiver cheio;
% – caminhão lava contêineres: lava os contêineres quando estiverem sujos ou
% contaminados com algum produto ou resíduo;


% predicado add/2
% add(fato_que_deve_ser_adicionado,ação_executada).

% predicado del/2
% del(fato_que_deve_ser_deletado,ação_executada).
%

% predicado can/2
% can(ação,lista_de_pre-condicoes_separadas_por_&)

% predicado always/1
% always(fato_sempre_verdadeiro).

% predicado given/1
% given(fato_estado_inicial).


given(conteiner, temConteiner(container1, area_a)).
given(conteiner, temConteiner(container2, area_b)).
given(conteiner, temConteiner(container3, area_c)).
given(conteiner, temConteiner(container4, area_d)).

given(conteiner, conteinerCheio(container4)).
given(conteiner, conteinerCheio(container3)).
given(conteiner, conteinerCheio(container1)).

given(caminhao, posicao(caminhao1, area_g)).
given(caminhao, posicao(caminhao2, area_g)).

given(caminhao, caminhaoVazio(caminhao1)).
given(caminhao, caminhaoVazio(caminhao2)).


can(recolherLixo(R,I), posicao(R,I)&temConteiner(C, I)&containerCheio(C)).
add(containerVazio(C), encheCaminhao(R)).
del(caminhaoVazio(R),conteinerCheio(C)).

can(voltarGaragem(R), encheCaminhao(R)).
add(posicao(R, area_g), caminhaoVazio(R)).
del(encheCaminhao(R)).

    