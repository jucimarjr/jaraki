%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% Aluno  : Eden ( edenstark@gmail.com )
%% Aluno  : Helder Cunha Batista ( hcb007@gmail.com )
%% Aluno  : Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% Aluno  : Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% Aluno  : Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Gerar os analisadores lexico e sintatico e compilar o compilador

-module(jaraki_build).

-vsn(0.004).
-author('uea_ludus@googlegroups.com').

-export([build/0]).

%%-----------------------------------------------------------------------------
%% Gera os analisadores lexico e sintatico e compila o compilador
build() ->
	leex:file(jaraki_lexer),
	yecc:file(jaraki_parser),
	compile:file(jaraki_lexer),
	compile:file(jaraki_parser),
	compile:file(jaraki_tree),
	compile:file(jaraki_compile, debug_info),
	ok.
