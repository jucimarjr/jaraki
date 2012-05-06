%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% 			Eden ( edenstark@gmail.com )
%% 			Helder Cunha Batista ( hcb007@gmail.com )
%% 			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% 			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% 			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Manipular a tabela de simbolos

-module(jaraki_identifier).
-compile(export_all).
-include("../include/jaraki_define.hrl").

%%-----------------------------------------------------------------------------
%% Insere uma lista de variaveis na tabela de simbolos - dicionario do processo
%% TODO: verificar se jah existe variavel
insert_var_list(Line, Type, [{identifier, Name} | []]) ->
	insert( Line, Type, Name);
insert_var_list( Line, Type, [{identifier, Name} | Rest]) ->
	insert( Line, Type, Name),
	insert_var_list(Line, Type, Rest).

%%-----------------------------------------------------------------------------
%% Transforma uma variavel java em variavel erlang e na tabela de simbolos
%% TODO: verificar se jah existe variavel
insert(Line, Type, Name) ->
	ListName = atom_to_list(Name),
	JavaName = ListName,
	ErlangName = "Var_" ++ ListName,
	VarRecord = #var{java_name = JavaName, erl_name = ErlangName, type = Type},
	set_var(Name, VarRecord),
	no_operation.

%%-----------------------------------------------------------------------------
%% remove uma variavel na tabela de simbolos - dicionario do processo
remove(VarName) ->
	erase({vars, VarName, get(scope)}).

%%-----------------------------------------------------------------------------
%% Insere variavel na tabela de simbolos - dicionario do processo
%% TODO: verificar se jah existe variavel
set_var(VarName, NewVarRecord) ->
	put({vars, VarName, get(scope)}, NewVarRecord).

%%-----------------------------------------------------------------------------
%% retorna o valor de uma variavel da tabela de simbolos
get_var(VarName) ->
	case get({vars, VarName, get(scope)}) of
		undefined ->
			jaraki_exception:handle_error("Variable not declared");
		VarRecord ->
			{ok, VarRecord}
	end.

%%-----------------------------------------------------------------------------
%% retorna todas as variaveis da tabela de simbolos
get_all_vars() ->
	get().
