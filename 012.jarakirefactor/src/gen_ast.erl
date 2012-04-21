%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% 			Eden ( edenstark@gmail.com )
%% 			Helder Cunha Batista ( hcb007@gmail.com )
%% 			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% 			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% 			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Encapsular a geração dos nós da AST no formato abstrato do Erlang

-module(gen_ast).
-compile(export_all).

function(Line, Name, Parameters, ErlangFunctionBody) ->
	{function, Line, Name, length(Parameters), ErlangFunctionBody}.

var(Line, Name) when is_list(Name)-> {var, Line, list_to_atom(Name)};
var(Line, Name) when is_atom(Name) -> {var, Line, Name}.

atom(Line, Name) when is_atom(Name) ->
	{atom, Line, Name};
atom(Line, Name) when is_list(Name) ->
	{atom, Line, list_to_atom(Name)}.

call(Line, FunctionName, Arguments) ->
	{call, Line, atom(Line, FunctionName), Arguments}.

rcall(Line, ModuleName, FunctionName, Arguments) ->
	{call, Line,
		{remote, Line, atom(Line, ModuleName), atom(Line, FunctionName)},
		Arguments}.

'case'(Line, Condiction, Patterns) ->
	{'case', Line, Condiction, Patterns}.

clause(Line, Pattern, Guard, Body)->
	{clause, Line, Pattern, Guard, Body}.

'fun'(Line, Clauses) ->
	{'fun', Line, {clauses, Clauses}}.

tuple(Line, Arguments) ->
	{tuple, Line, Arguments}.

string(Line, String) when is_atom(String) ->
	{string, Line, atom_to_list(String)};
string(Line, String) when is_list(String) ->
	{string, Line, String}.

type_to_ast(Line, {array, PrimitiveType}) ->
	tuple(Line,	[atom(Line, array),	atom(Line, PrimitiveType)]);
type_to_ast(Line, PrimitiveType) ->
	atom(Line, PrimitiveType).

check_int({array, _PrimitiveType}) ->
	other_type;
check_int(PrimitiveType) ->
	case PrimitiveType of
		int -> ok;
		_ -> other_type
	end.
