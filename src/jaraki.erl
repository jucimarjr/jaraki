%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%%			Eden ( edenstark@gmail.com )
%%			Helder Cunha Batista ( hcb007@gmail.com )
%%			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%%			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%%			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Compilar arquivos java para a VM do Erlang

-module(jaraki).
-export([compile/1, get_version/0]).

-include("../include/jaraki_define.hrl").

%%-----------------------------------------------------------------------------
%% Interface com o usuario final. Compila 1 arquivo java, gera o .erl e o .beam
compile({beam,JavaFileName}) ->
	{_, _, StartTime} = now(),

	[ErlangFile] = get_erl_file_list([JavaFileName]),
%	ErlangFile = get_erl_file(JavaFileName),

	erl_tidy:file(ErlangFile,[{backups,false}]),

	compile:file(ErlangFile),

	{_, _, EndTime} = now(),
	ElapsedTime = EndTime - StartTime,
	io:format(
		"~p -> ~p [ Compile time: ~p us (~p s) ]~n",
		[
			filename:basename(JavaFileName),
			ErlangFile,
			ElapsedTime,
			ElapsedTime/1000000
		]
	);

%%-----------------------------------------------------------------------------
%% Interface com o usuario final. Compila vários arquivos java dependentes
compile(JavaFileNameList) ->
	{_, _, StartTime} = now(),

	ErlangFileList = get_erl_file_list(JavaFileNameList),
	{_, _, EndTime} = now(),
	ElapsedTime = EndTime - StartTime,
	io:format(
		"~p -> ~p [ Compile time: ~p us (~p s) ]~n",
		[[filename:basename(JavaFileName) || JavaFileName <- JavaFileNameList],
			ErlangFileList,
			ElapsedTime, ElapsedTime/1000000]
	).

%%-----------------------------------------------------------------------------
%% gera vários arquivos .erl de vários .java
get_erl_file_list(JavaFileNameList) ->
	JavaASTList = lists:map(fun ast:get_java_ast/1, JavaFileNameList),
	ClassesInfo = lists:map(fun ast:get_class_info/1, JavaASTList),

	get_erl_file_list(JavaASTList, ClassesInfo, []).

get_erl_file_list([], _, ErlangFileList) ->
	lists:reverse(ErlangFileList, []);
get_erl_file_list([JavaAST | Rest], ClassesInfo, ErlangFileList) ->
	ErlangModuleName= get_erl_modulename(JavaAST),

	ErlangFileName= get_erl_filename(ErlangModuleName),

	{ok, ErlangAST} =
		core:transform_jast_to_east(JavaAST, ErlangModuleName, ClassesInfo),

	create_erl_file(ErlangAST,ErlangFileName),

	get_erl_file_list(Rest, ClassesInfo, [ErlangFileName | ErlangFileList]).

%%-----------------------------------------------------------------------------
%% gera um arquivo .erl de um .java
%% FUNÇÃO OBSOLETA, falta atualizar dependências
%% get_erl_file(JavaFileName) ->
%% 	JavaAST = ast:get_java_ast(JavaFileName),

%% 	ErlangModuleName= get_erl_modulename(JavaAST),

%% 	ErlangFileName= get_erl_filename(ErlangModuleName),

%% 	JavaAST = ast:get_java_ast(JavaFileName),
%% 	ClassInfo = ast:get_class_info(JavaAST),

%% 	{ok, ErlangAST} =
%% 		core:transform_jast_to_east(JavaAST, ErlangModuleName, [ClassInfo]),
%% 	create_erl_file(ErlangAST,ErlangFileName),

%% 	ErlangFileName.

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
	atom_to_list(ErlangModuleName) ++ ".erl".

%%-----------------------------------------------------------------------------
%% Extrai o nome do modulo erlang partir do java ast
%% o nome do modulo eh o nome da classe
get_erl_modulename(JavaAST) ->
	case JavaAST of
		[{_Line1, _PackageName, {class_list, [{class, ClassData}]}}] ->
			{_Line2, {name, JavaClassName}, {body, _JavaClassBody}} = ClassData,
			list_to_atom(string:to_lower(atom_to_list(JavaClassName)));
		[{class, ClassData}] ->
			{_Line3, {name, JavaClassName}, {body, _JavaClassBody}} = ClassData,
			list_to_atom(string:to_lower(atom_to_list(JavaClassName)))
	end.


%%-----------------------------------------------------------------------------
%% Cria o arquivo .erl no sistema de arquivos
create_erl_file(ErlangAST, ErlangFileName) ->
	ErlangCode = erl_prettypr:format(erl_syntax:form_list(ErlangAST)),
	{ok, WriteDescriptor} = file:open(ErlangFileName, [raw, write]),
	file:write(WriteDescriptor, ErlangCode),
	file:close(WriteDescriptor).
