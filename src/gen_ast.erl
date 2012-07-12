%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%%			Eden ( edenstark@gmail.com )
%%			Helder Cunha Batista ( hcb007@gmail.com )
%%			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%%			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%%			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Encapsular a geração dos nós da AST no formato abstrato do Erlang

-module(gen_ast).
-compile(export_all).

function(Line, Name, ParametersLength, ErlangFunctionBody) ->
	{function, Line, Name, ParametersLength, ErlangFunctionBody}.

var(Line, Name) when is_list(Name)-> {var, Line, list_to_atom(Name)};
var(Line, Name) when is_atom(Name) -> {var, Line, Name}.

atom(Line, Name) when is_atom(Name) ->
	{atom, Line, Name};
atom(Line, Name) when is_list(Name) ->
	{atom, Line, list_to_atom(Name)};
atom(Line, Name) when is_tuple(Name) ->
	ElementsList = tuple_to_list(Name),
	ElementsAstList =
		lists:map(fun(Element) -> atom(Line, Element) end, ElementsList),
	tuple(Line, ElementsAstList).

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

type_to_ast(Line, {matrix, PrimitiveType}) ->
	tuple(Line,	[atom(Line, matrix),	atom(Line, PrimitiveType)]);

type_to_ast(Line, PrimitiveType) ->
	atom(Line, PrimitiveType).

check_int({array, _PrimitiveType}) ->
	other_type;

check_int({matrix, _PrimitiveType}) ->
	other_type;
check_int(PrimitiveType) ->
	case PrimitiveType of
		int -> ok;
		_ -> other_type
	end.

integer(Line, Value) -> {integer, Line, Value}.
float(Line, Value) -> {float, Line, Value}.

list(Line, [])               -> {nil, Line};
list(Line, [Element | Rest]) -> {cons, Line, Element, list(Line, Rest)}.

%%---------------------------------------------------------------------------%%
%% gen_ast complexos para OO

field_access_var(Line, VarName) ->
	ObjectIDAst = var(Line, "ObjectID"),
	FieldNameAst = atom(Line, VarName),
	GetParameters = [ObjectIDAst, FieldNameAst],
	rcall(Line, oo_lib, get_attribute, GetParameters).

field_refVar(Line, Scope, ObjectVarName, FieldName) ->
	ScopeAst = atom(Line, Scope),
	ObjectVarNameAst = string(Line, ObjectVarName),
	ObjectIDAst = rcall(Line, st,get_value, [ScopeAst, ObjectVarNameAst]),

	FieldNameAst = atom(Line, FieldName),
	FieldParameters = [ObjectIDAst, FieldNameAst],
	rcall(Line, oo_lib, get_attribute, FieldParameters).
