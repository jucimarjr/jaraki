%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% 			Eden ( edenstark@gmail.com )
%% 			Helder Cunha Batista ( hcb007@gmail.com )
%% 			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% 			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% 			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : ...

-module(control).
-export([for/4]).

%%-----------------------------------------------------------------------------
%% O loop for
for(InitFun, ConditionFun, IncFun, BodyFun) ->
	InitFun(),
	for_core(ConditionFun, IncFun, BodyFun).

for_core(ConditionFun, IncFun, BodyFun) ->
	case ConditionFun() of
		true ->
			BodyFun(),
			IncFun(),
			for_core(ConditionFun, IncFun, BodyFun);
		false ->
			finish_for
	end.
