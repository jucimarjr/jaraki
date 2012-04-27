%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% 			Eden ( edenstark@gmail.com )
%% 			Helder Cunha Batista ( hcb007@gmail.com )
%% 			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% 			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% 			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Array

-module(vector).
-export([new/1, get/1]).

new(ArrayValue) ->
	ArrayIndex = st:update_counter(array_index, 1),
	st:insert({array_dict, ArrayIndex}, ArrayValue).

get(ArrayIndex) ->
	Key = {array_dict, ArrayIndex},
	ArrayValue = st:lookup(Key),
	ArrayValue.
