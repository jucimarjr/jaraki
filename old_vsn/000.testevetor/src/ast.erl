%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% 			Eden ( edenstark@gmail.com )
%% 			Helder Cunha Batista ( hcb007@gmail.com )
%% 			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% 			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% 			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Gerar a arvore sintatica a java a partir de um codigo-fonte
%% Objetivo : Gerar os tokens java a partir de um codigo-fonte

-module(ast).
-export([get_java_ast/1, get_java_tokens/1]).

%%-----------------------------------------------------------------------------
%% Extrai a Java Abstract Syntax Tree de um arquivo .java
get_java_ast(JavaFileName) ->
	JavaTokens = get_java_tokens(JavaFileName),
	{ok, JavaAST} = jaraki_parser:parse(JavaTokens),
	JavaAST.

%%-----------------------------------------------------------------------------
%% Extrai a lista de Tokens de um arquivo .java
get_java_tokens(JavaFileName) ->
	{ok, FileContent} = file:read_file(JavaFileName),
	Program = binary_to_list(FileContent),
	{ok, JavaTokens, _EndLine} = jaraki_lexer:string(Program),
	JavaTokens.

