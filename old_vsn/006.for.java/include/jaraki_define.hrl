%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% 			Eden ( edenstark@gmail.com )
%% 			Helder Cunha Batista ( hcb007@gmail.com )
%% 			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% 			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% 			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Mostrar versão, equipe, ano e definição de record

-define(VSN, 0.005).
-define(TEAM, ['uea_ludus@googlegroups.com', 'Jucimar Jr', 'Daniel Henrique', 'Eden', 'Helder Batista', 'Josiane Rodrigues', 'Lidia Lizziane', 'Rodrigo Bernardino']).
-define(YEAR, 2012).

%% Esse record define uma variavel, usado na analise semantica
%%  campos:
%%    java_name  -  nome que aparece no codigo em java   (nomeVariavel)
%%    erl_name   -  nome como ficara no codigo em erlang (V_nomeVariavel)
%%    type       -  tipo da variavel (int, float, etc)
%%    value      -  valor atual da variavel
%%    counter    -  quantas vezes a variavel foi utilizada, o numero de counter
%%                  é acrescido ao nome da variavel no codigo gerado
%%                  (V_nomeVariavel1)

-record( var, { java_name, erl_name, type, value, counter = 0 } ).
