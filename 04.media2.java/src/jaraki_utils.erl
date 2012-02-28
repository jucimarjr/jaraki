%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% 			Eden ( edenstark@gmail.com )
%% 			Helder Cunha Batista ( hcb007@gmail.com )
%% 			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% 			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% 			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Utilitários para o compilador

-module(jaraki_utils).
-compile(export_all).

-include("../include/jaraki_define.hrl").

%%-----------------------------------------------------------------------------
%% Extrai a Erlang Abstract Syntax Tree de um arquivo .java
get_erl_ast(JavaFileName) ->
	JavaAST = jaraki:get_java_ast(JavaFileName),
	[{_Line, {class, ClassName}, _ClassBody}] = JavaAST,
	ModuleName = list_to_atom(string:to_lower(atom_to_list(ClassName))),
	ErlangAST = jaraki_core:transform_jast_to_east(JavaAST, ModuleName),
	ErlangAST.

%%-----------------------------------------------------------------------------
%% Imprime a árvore do java gerada análise sintática do compilador
print_java_ast(JavaFileName) ->
	io:format("Generating Syntax Analysis... "),

	JavaAST = jaraki:get_java_ast(JavaFileName),
	io:format("done!~n"),

	io:format("Jaraki Syntax Tree from ~p:~n", [JavaFileName]),
	io:format("~p~n", [JavaAST]).

%%-----------------------------------------------------------------------------
%% Imprime os tokens do java gerados pela análise léxica do compilador
print_tokens(JavaFileName) ->
	io:format("Generating Lexical Analysis... "),

	Tokens = jaraki:get_tokens(JavaFileName),
	io:format("done!~n"),

	io:format("Jaraki Tokens from ~p:~n", [JavaFileName]),
	io:format("~p~n", [Tokens]).

%%-----------------------------------------------------------------------------
%% Transforma o código erlang em Abstract Syntax Tree
print_erl_ast(JavaFileName) ->
	io:format("Generating Erlang Abstract Syntax Tree... "),

	ErlangAst = get_erl_ast(JavaFileName),
	io:format("done!~n"),

	io:format("Erlang Abstract Syntax Tree from ~p:~n", [JavaFileName]),
	io:format("~p~n", [ErlangAst]).

%%-----------------------------------------------------------------------------
%% Transforma o código erlang em Abstract Syntax Tree
print_erl_ast_from_erlang(ErlangFileName) ->
	io:format("Generating Erlang Abstract Syntax Tree from Erlang... "),

	ErlangAst = 
		case epp:parse_file(ErlangFileName, [], []) of
			{ok, Tree} -> Tree;
			Error -> io:format("~p", [Error])
		end,
	io:format("done!~n"),

	io:format("Erlang Abstract Syntax Tree from ~p:~n", [ErlangFileName]),
	io:format("~p~n", [ErlangAst]).