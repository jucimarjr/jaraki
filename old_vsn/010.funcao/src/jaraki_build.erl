%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% 			Eden ( edenstark@gmail.com )
%% 			Helder Cunha Batista ( hcb007@gmail.com )
%% 			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% 			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% 			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Gerar os analisadores lexico e sintatico e compilar o compilador

-module(jaraki_build).
-export([build/0]).

%%-----------------------------------------------------------------------------
%%Gera os analisadores lexico e sintatico e compila o compilador
build() ->
	leex:file(jaraki_lexer),
	yecc:file(jaraki_parser),
	compile:file(jaraki_lexer),
	compile:file(jaraki_parser),
	compile:file(gen_erl_code),
	compile:file(ast),
	compile:file(core),
	compile:file(jaraki),
	compile:file(jaraki_exception),
	compile:file(jaraki_identifier),
	compile:file(jaraki_utils),
	ok.
