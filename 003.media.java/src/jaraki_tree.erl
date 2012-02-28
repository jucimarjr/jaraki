%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% Aluno  : Eden ( edenstark@gmail.com )
%% Aluno  : Helder Cunha Batista ( hcb007@gmail.com )
%% Aluno  : Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% Aluno  : Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% Aluno  : Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Gerar os analisadores lexico e sintatico e compilar o compilador

-module(jaraki_tree).

-vsn(0.004).
-author('uea_ludus@googlegroups.com').

-compile(export_all).

%%-----------------------------------------------------------------------------
%%Gera a arvore sintatica do compilador
get_tree(Name) ->
	{ok, Content} = file:read_file(Name),
	Program = binary_to_list(Content),
	{ok, Tokens, _EndLine} = jaraki_lexer:string(Program),
	{ok, Tree} = jaraki_parser:parse(Tokens),
	Tree.
