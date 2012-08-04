%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%%			Eden Freitas Ramos ( edenstark@gmail.com )
%%			Helder Cunha Batista ( hcb007@gmail.com )
%%			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%%			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%%			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Funções auxiliares usadas em diferentes partes da semântica

-module(helpers).
-export([get_variable_context/2, get_arg_type_list/1, remove_nop/1]).

%%-----------------------------------------------------------------------------
%% remove todas as ocorrências de no_operation de uma lista
remove_nop(ErlangStmtList) ->
	[Element ||
			Element <- ErlangStmtList,
			Element =/= no_operation
	].


%%-----------------------------------------------------------------------------
%% Ao usar uma variável, determina se está sendo feito referência a uma variável
%% local (do método) ou do objeto
%%
%% TODO: a próxima função poderia ir e um módulo separado (tree_helpers)
get_variable_context(Scope, VarName) ->
	{ScopeClass, ScopeMethod} = Scope,

	IsDeclaredVar  = st:is_declared_var(Scope, VarName),
	IsStaticMethod = st:is_static_method(ScopeClass, ScopeMethod),
	ExistField     = st:exist_field(ScopeClass, VarName),

	case IsDeclaredVar of
		true  -> {ok, local};
		false ->
			case IsStaticMethod of
				true ->
					case ExistField of
						true  -> {error, 10};
						false -> {error, 1}
					end;

				false ->
					case ExistField of
						true  -> {ok, object};
						false -> {error, 1}
					end
			end
	end.

%%-----------------------------------------------------------------------------
%% gera lista de tipos a partir de uma lista de parâmetros no estilo da jast
get_arg_type_list(ArgumentsList) ->
	get_arg_type_list(ArgumentsList, []).

get_arg_type_list([], ArgTypeList) ->
	lists:reverse(ArgTypeList, []);

get_arg_type_list([Argument | Rest], ArgTypeList) ->
	case get_arg_type(Argument) of
		{error, ErrorNumber} -> {error, ErrorNumber};

		Type ->
			get_arg_type_list(Rest, [Type| ArgTypeList])
	end.

get_arg_type({var, Line, VarName}) ->
	Scope = st:get_scope(),
	{ScopeClass, _} = Scope,
	VarContext = get_variable_context(Scope, VarName),

	case VarContext of
		{error, _ErrorNumber} -> VarContext;

		{ok, local} ->
			{VarType, _} = st:get2(Line, Scope, VarName),
			VarType;

		{ok, object} ->
			{VarType, _} = st:get_field_info(ScopeClass, VarName),
			VarType
	end;

get_arg_type({{var, Line,ArrayName}, {index, {row, _}, {column, _}}}) ->
	Scope = st:get_scope(),
	case st:is_declared_var(Scope, ArrayName) of
		false -> {error, 1};
		true ->
			{{matrix, VarType}, _} = st:get2(Line, Scope, ArrayName),
			VarType
	end;

get_arg_type({text, _,_}) -> 'String';
get_arg_type({integer, _,_}) -> int;
get_arg_type({long, _,_}) -> long;
get_arg_type({double, _,_}) -> double;
get_arg_type({float, _,_}) -> float;
get_arg_type({length, _,_}) -> int;
get_arg_type({atom, _, true}) -> boolean;
get_arg_type({atom, _, false}) -> boolean;
get_arg_type({Type, _,_}) when is_atom(Type) -> Type;

get_arg_type({op, _, _, Expr}) -> get_arg_type(Expr);

%% se for uma expressão, busca tipo de "maior grau"
%% se encontrar um float na expressão, o resultado é float
%% se encontrar um double e não tiver float, resultado será double
%% se encontrar um long e não tiver float nem double, resultado será long
%% se não encontrar nenhum long, double ou float, será int
get_arg_type({op, _, _, LeftExpr, RightExpr}) ->
	LeftExprType  = get_arg_type(LeftExpr),
	RightExprType = get_arg_type(RightExpr),
	match_op_type(LeftExprType, RightExprType);

get_arg_type(_OtherType) -> {error, 13}.

match_op_type(float, _)  -> float;
match_op_type(_, float)  -> float;
match_op_type(double, _) -> double;
match_op_type(_, double) -> double;
match_op_type(long, _)   -> long;
match_op_type(_, long)   -> long;
match_op_type(int, _)    -> int;
match_op_type(_, int)    -> int.
