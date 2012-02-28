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
-compile(export_all).

-include("../include/jaraki_define.hrl").

%%-----------------------------------------------------------------------------
%% Escreve o codigo em erlang a partir do java.
%% TODO: tratar múltiplos arquivos, ou seja, múltiplas classes
%% TODO: criar uma versão compile(JavaFileName,[options]) 
compile(JavaFileName) ->
	JavaAST = get_java_ast(JavaFileName),
	[{_Line, {class, ClassName}, _ClassBody}] = JavaAST,
	ModuleName = list_to_atom(string:to_lower(atom_to_list(ClassName))),
	ErlangFileName = atom_to_list(ModuleName) ++ ".erl",

	ErlangAST = jaraki_core:transform_jast_to_east(JavaAST, ModuleName),
	ErlangCode = erl_prettypr:format(erl_syntax:form_list(ErlangAST)),

	{ok, WriteDescriptor} = file:open(ErlangFileName, [raw, write]),
	file:write(WriteDescriptor, ErlangCode),
	file:close(WriteDescriptor).

%%-----------------------------------------------------------------------------
%% Extrai a Java Abstract Syntax Tree de um arquivo .java
get_java_ast(JavaFileName) ->
	Tokens = get_tokens(JavaFileName),
	{ok, JavaAST} = jaraki_parser:parse(Tokens),
	JavaAST.

%%-----------------------------------------------------------------------------
%% Extrai a lista de Tokens de um arquivo .java
get_tokens(JavaFileName) ->
	{ok, FileContent} = file:read_file(JavaFileName),
	Program = binary_to_list(FileContent),
	{ok, Tokens, _EndLine} = jaraki_lexer:string(Program),
	Tokens.

%%-----------------------------------------------------------------------------
%% Mostra a versao, autores e ano do Jaraki.
get_version() ->
	io:format("Jaraki - A Java compiler for Erlang VM ~n"),
	io:format("Version: ~p~n", [?VSN]),
	io:format("Team: ~p~n", [?TEAM]),
	io:format("Year: ~p~n", [?YEAR]).
