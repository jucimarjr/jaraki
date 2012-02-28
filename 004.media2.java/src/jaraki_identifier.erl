%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% 			Eden ( edenstark@gmail.com )
%% 			Helder Cunha Batista ( hcb007@gmail.com )
%% 			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% 			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% 			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : 

-module(jaraki_identifier).
-compile(export_all).
-include("../include/jaraki_define.hrl").

%%-----------------------------------------------------------------------------
%% Insere variavel na tabela de simbolos - dicionario do processo
insert( Line, {var_type, Type}, {identifier, Name} ) ->
	VarRecord = #var{java_name = atom_to_list(Name), type = Type},
	set_var(Name, VarRecord),
	no_operation.

set_var(VarName, NewVarRecord) ->
	put({vars, VarName}, NewVarRecord).

get_var(VarName) ->
	case get({vars, VarName}) of
		undefined ->
			jaraki_exception:handle_error("Variable not declared");
		VarRecord ->
			{ok, VarRecord}
	end.

