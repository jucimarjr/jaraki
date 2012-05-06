%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% 			Eden ( edenstark@gmail.com )
%% 			Helder Cunha Batista ( hcb007@gmail.com )
%% 			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% 			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% 			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Compilar arquivos java para a VM do Erlang 

-module(jaraki).
-export([compile/1, get_version/0]).

-include("../include/jaraki_define.hrl").

%%-----------------------------------------------------------------------------
%% Escreve o codigo em erlang a partir do java.
%% TODO: tratar múltiplos arquivos, ou seja, múltiplas classes
%% TODO: criar uma versão compile(JavaFileName,[options]) 
compile(JavaFileName) ->
	{_, _, StartTime} = now(),

	JavaAST = ast:get_java_ast(JavaFileName),
	ErlangModuleName= get_erl_modulename(JavaAST),
	ErlangFileName= get_erl_filename(ErlangModuleName),

	{ok, ErlangAST} = core:transform_jast_to_east(JavaAST, ErlangModuleName),
	create_erl_file(ErlangAST,ErlangFileName),
	
	{_, _, EndTime} = now(),
	ElapsedTime = EndTime - StartTime,
	io:format(
		"Compile time: ~p us (~p s)~n",
		[ElapsedTime,ElapsedTime/1000000]
	).

%%-----------------------------------------------------------------------------
%% Mostra a versao, autores e ano do Jaraki.
get_version() ->
	io:format("Jaraki - A Java compiler for Erlang VM ~n"),
	io:format("Version: ~p~n", [?VSN]),
	io:format("Team: ~p~n", [?TEAM]),
	io:format("Year: ~p~n", [?YEAR]).

%%-----------------------------------------------------------------------------
%% Extrai o nome do arquivo .erl a partir do java ast
get_erl_filename(ErlangModuleName) ->
	ErlangFileName = atom_to_list(ErlangModuleName) ++ ".erl",
	ErlangFileName.

%%-----------------------------------------------------------------------------
%% Extrai o nome do modulo erlang partir do java ast
get_erl_modulename(JavaAST) ->
	[{_Line, {class, JavaClassName}, _JavaClassBody}] = JavaAST,
	ErlangModuleName = 
		list_to_atom(
			string:to_lower(atom_to_list(JavaClassName))
		),
	ErlangModuleName.	

%%-----------------------------------------------------------------------------
%% Cria o arquivo .erl no sistema de arquivos
create_erl_file(ErlangAST, ErlangFileName) ->
	ErlangCode = erl_prettypr:format(erl_syntax:form_list(ErlangAST)),
	{ok, WriteDescriptor} = file:open(ErlangFileName, [raw, write]),
	file:write(WriteDescriptor, ErlangCode),
	file:close(WriteDescriptor).

