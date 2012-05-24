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
%% Compila vários códigos em Jaraki dependentes e gera .erl's correspondentes
compile(JavaFileNameList) ->
	case catch(jaraki:compile(JavaFileNameList)) of
		{'EXIT', Reason} ->
			io:format("*******ERROR!~n"),
			io:format("***Reason:~n~p", [Reason]);
		{error, Errors} ->
			io:format("*******ERROR!~n"),
			io:format("***Reasons:\n"),
			jaraki_exception:print_errors(Errors);
		ok ->
			ok;
		X ->
			io:format("*******UNEXPECTED ERROR!~n"),
			io:format("***Reason:~n~p", [X])
	end.

%%-----------------------------------------------------------------------------
%% Extrai a Erlang Abstract Syntax Tree de um arquivo .java
get_erl_ast(JavaFileName) ->
	JavaAST = ast:get_java_ast(JavaFileName),
	[{_Line, {class, ClassName}, _ClassBody}] = JavaAST,
	ModuleName = list_to_atom(string:to_lower(atom_to_list(ClassName))),
	core:transform_jast_to_east(JavaAST, ModuleName, []).

%%-----------------------------------------------------------------------------
%% Imprime a árvore do java gerada análise sintática do compilador
print_java_ast(JavaFileName) ->
	io:format("Generating Syntax Analysis... "),

	case catch(ast:get_java_ast(JavaFileName)) of
		{'EXIT', Reason} ->
			io:format("*******ERROR!~n"),
			io:format("***Reason:~n~p", [Reason]);
		JavaAST ->
			io:format("done!~n"),

			io:format("Jaraki Syntax Tree from ~p:~n", [JavaFileName]),
			io:format("~p~n", [JavaAST])
	end.

%%-----------------------------------------------------------------------------
%% Imprime os tokens do java gerados pela análise léxica do compilador
print_tokens(JavaFileName) ->
	io:format("Generating Lexical Analysis... "),

	Tokens = ast:get_java_tokens(JavaFileName),
	io:format("done!~n"),

	io:format("Jaraki Tokens from ~p:~n", [JavaFileName]),
	io:format("~p~n", [Tokens]).

%%-----------------------------------------------------------------------------
%% Transforma o código erlang em Abstract Syntax Tree
print_erl_ast(JavaFileName) ->
	io:format("Generating Erlang Abstract Syntax Tree... "),

	case catch(get_erl_ast(JavaFileName)) of
		{ok, ErlangAST} ->
			io:format("done!~n"),

			io:format("Erlang Abstract Syntax Tree from ~p:~n", [JavaFileName]),
			io:format("~p~n", [ErlangAST]);

		{'EXIT', Reason} ->
			io:format("*******ERROR!~n"),
			io:format("***Reason:~n~p", [Reason])
	end.

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

%%-----------------------------------------------------------------------------
%% calcula o tempo de execução de uma funcao em microssegundos
get_runtime(Module, Func, N )->
	{ElapsedTime, R} = timer:tc(Module, Func, [N]),
	io:format("~p(~p): ~p [~p us] [~p s] ~n",[Func, N, R, ElapsedTime, ElapsedTime/1000000]).

get_runtime(Module, Func )->
	{ElapsedTime, R} = timer:tc(Module, Func, []),
	io:format("~p(~p): [~p us] [~p s] ~n",[Func, R, ElapsedTime, ElapsedTime/1000000]).



