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

%% lista de parâmetros da definição de uma função
function_args_list(Line, ParametersList) ->
	function_args_list(Line, ParametersList, []).

function_args_list(_, [], ParametersListAst) ->
	lists:reverse(ParametersListAst, []);

function_args_list(Line, ParametersList, ParametersListAst) ->
	[{ParamLine, TypeJast, ParamJast} | Rest] = ParametersList,
	{var_type, {_TypeLine, Type}} = TypeJast,
	{parameter, ParamName} = ParamJast,
	VarAst = var(ParamLine,"V_" ++ atom_to_list(ParamName)),
	ParamAst = tuple(Line, [atom(Line, Type), VarAst]),
	function_args_list(Line, Rest, [ParamAst | ParametersListAst]).

%% lista de parâmetros da chamada de função
%% acrescenta o tipo ao valor: fazendo f(1) virar f({integer, 1})
%%
%% assume que ArgumentsList são variáveis ou literais (números, string)
function_call_args(Line, ArgumentAstList, ArgTypeList) ->
	ArgTypeAstList = [atom(Line, X) || X <- ArgTypeList],
	FinalArgList = lists:zip(ArgTypeAstList, ArgumentAstList),
	[tuple(Line, X) || X <- FinalArgList].

%% gera lista de parâmetros em uma declaração de função a partir da lista de
%% tipos, usado na criação dos métodos da super classe
%% nomes dos parâmetros: V_0, V_1, V_2...
function_args_list2(Line, ArgsTypeList) ->
	function_args_list2(Line, ArgsTypeList, [], 0).

function_args_list2(_, [], ArgAstList, _) ->
	lists:reverse(ArgAstList, []);
function_args_list2(Line, [ArgType | Rest], ArgAstList, N) ->
	VarAst = var(Line, "V_" ++ [N + 48]),
	ArgAst = tuple(Line, [atom(Line, ArgType), VarAst]),
	function_args_list2(Line, Rest, [ArgAst |ArgAstList], N+1).

%%---------------------------------------------------------------------------%%
%% Declaração dos parâmetros da função na st
init_args(Line, ParametersList) ->
	init_args(Line, ParametersList, []).

init_args(_, [], ParametersAstList) ->
	lists:reverse(ParametersAstList, []);

init_args(Line, [Parameter | ParametersList], ParametersAstList) ->
	ScopeAst = gen_ast:scope(Line, st:get_scope()),

	{_, {var_type, {_, InitArgType}}, {parameter, InitArgName}} = Parameter,

	ParameterAst =
		rcall(Line, st, put_value, [
			tuple(Line,	[ScopeAst, string(Line, InitArgName)]),
				tuple(Line,
					[gen_ast:type_to_ast(Line, InitArgType),
					 var(Line, "V_" ++ atom_to_list(InitArgName))])]),
	init_args(Line, ParametersList, [ParameterAst | ParametersAstList]).

%%---------------------------------------------------------------------------%%

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

tuple(Line, Arguments) when is_tuple(Arguments) ->
	ArgumentsList = tuple_to_list(Arguments),
	{tuple, Line, ArgumentsList};

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

match(Line, LeftExpAst, RightExpAst) ->
	{match, Line, LeftExpAst, RightExpAst}.

scope(Line, {ClassName, {MethodName, Parameters}}) ->
	ClassNameAst = atom(Line, ClassName),
	MethodNameAst = atom(Line, MethodName),
	ParametersAstList = [atom(Line, Element) || Element <- Parameters],
	ParametersListAst = list(Line, ParametersAstList),
	ScopeMethodAst = tuple(Line, [MethodNameAst, ParametersListAst]),
	tuple(Line, [ClassNameAst, ScopeMethodAst]).

%%---------------------------------------------------------------------------%%
%% gen_ast complexos para OO

field_access_var(Line, VarName) ->
	ObjectIDAst = var(Line, "ObjectID"),
	FieldNameAst = atom(Line, VarName),
	GetParameters = [ObjectIDAst, FieldNameAst],
	rcall(Line, oo_lib, get_attribute, GetParameters).

field_refVar(Line, Scope, ObjectVarName, FieldName) ->
	ObjectIDAst = objectID(Line, Scope, ObjectVarName),

	FieldNameAst = atom(Line, FieldName),
	FieldParameters = [ObjectIDAst, FieldNameAst],
	rcall(Line, oo_lib, get_attribute, FieldParameters).

update_field_1(Line, VarName, TypeAst, NewVarValue) ->
	ObjectIDAst = objectID(Line, this),
	FieldNameAst = atom(Line, VarName),
	VarParamAst = tuple(Line, [FieldNameAst, TypeAst, NewVarValue]),
	rcall(Line, oo_lib, update_attribute, [ObjectIDAst, VarParamAst]).

objectID(Line, this) -> var(Line, "ObjectID").

objectID(Line, _, this) -> var(Line, "ObjectID");
objectID(Line, Scope, ObjectVarName) ->
	ScopeAst = scope(Line, Scope),
	ObjectVarNameAst = string(Line, ObjectVarName),
	rcall(Line, st,get_value, [ScopeAst, ObjectVarNameAst]).

%%-----------------------------------------------------------------------------
%% cria a lista de campos no formato AST para o construtor padrão da classe
create_field_list(FieldInfoList) ->
	FieldAstList = lists:map(fun create_field/1, FieldInfoList),
	list(0, FieldAstList).

%%-----------------------------------------------------------------------------
%% cria a AST de um campo do construtor padrão da classe
create_field({Name, {Type, _Modifiers}}) ->
	NameAst = atom(0, Name),
	TypeAst = atom(0, Type),
	ValueAst =
		case Type of
			float    -> float(0, 0.0);
			int      -> integer(0, 0);
			long     -> integer(0, 0);
			double   -> integer(0, 0);
			boolean  -> atom(0, false);
			_RefType -> atom(0, undefined)
		end,
	tuple(0, [NameAst, TypeAst, ValueAst]).

%%-----------------------------------------------------------------------------
%% novo obbjeto usando oo_lib
new_object(Line, ClassName) ->
	ClassNameAst = atom(Line, ClassName),

	%% TODO: tratar superclasses
	SuperClassesAst = {nil, Line},

	FieldsInfoList = st:get_all_fields_info(ClassName),
	FieldsListAst = gen_ast:create_field_list(FieldsInfoList),

	ArgumentsAstList = [ClassNameAst, SuperClassesAst, FieldsListAst],
	rcall(Line, oo_lib, new, ArgumentsAstList).
