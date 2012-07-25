%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%%			Eden ( edenstark@gmail.com )
%%			Helder Cunha Batista ( hcb007@gmail.com )
%%			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%%			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%%			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : ...

-module(file_lib).
-export([function_file/3, function_file/1]).


function_file(Par1, Par2, Par3) ->
	case Par1 of
		new ->
			{ok, File} = file:open(Par2, Par3),
			File;
		read ->
			{ok, Read} = file:read(Par2, Par3),
			Read;
		write -> 
			file:write_file(Par2, Par3)
	end.

function_file(File) ->
	file:close(File).

