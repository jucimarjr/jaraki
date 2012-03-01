%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% 			Eden ( edenstark@gmail.com )
%% 			Helder Cunha Batista ( hcb007@gmail.com )
%% 			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% 			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% 			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : ...

-module(loop).
-export([for/4, while/2]).

%%-----------------------------------------------------------------------------
%% O loop for
for(ConditionFun, IncFun, BodyFun, Dict) ->
	case ConditionFun(Dict) of
		true ->
			io:format("~p", [Dict]),				
			D1 = BodyFun(Dict),
			D2 = IncFun(D1),
			for(ConditionFun, IncFun, BodyFun, D2);
		false ->
			ok
	end.

while(ConditionFun, BodyFun) ->
	case ConditionFun() of
		true ->
			BodyFun(),
			while(ConditionFun, BodyFun);

		false ->
			ok
	end.
