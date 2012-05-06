%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%%			Eden ( edenstark@gmail.com )
%%			Helder Cunha Batista ( hcb007@gmail.com )
%%			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%%			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%%			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Transforma instrucoes Java em instrucoes Erlang

-module(gen_erl_code).
-compile(export_all).
-include("../include/jaraki_define.hrl").

%%-----------------------------------------------------------------------------
%% transformacoes de expressoes em java para erlang
%% apenas uma unica expressao

%% transforma expressoes do tipo System.out.print( texto ) em Erlang
match_statement({Line, print, {text, Text}}) ->
	create_print_function(Line, text, Text);

%% transforma expressoes System.out.println( texto ) em Erlang
match_statement({Line, println, {text, Text}}) ->
	create_print_function(Line, text, Text ++ "~n");

%% transforma expressoes do tipo System.out.print( texto ) em Erlang
match_statement({Line, print, {var, VarName}}) ->
	create_print_function(Line, print, var, VarName);

%% transforma expressoes System.out.println( texto ) em Erlang
match_statement({Line, println, {var, VarName}}) ->
	create_print_function(Line, println, var, VarName);

%% Casa expressoes do tipo varivel = valor
match_statement(
	{
		Line, 
		attribution,
		{var, VarName},
		{var_value, VarValue}}
	) ->
	create_attribution(Line, VarName, VarValue);

%% Casa expressoes if-then
match_statement(
	{
		Line,
		'if',
		{bool_expr, Condition},
		{if_expr, IfExpr}
	}
	) ->
	create_if(Line, Condition, IfExpr);

%% casa expressoes if-then-else
match_statement(
	{
		Line,
		'if',
		{bool_expr, Condition}, 
		{if_expr, IfExpr}, 
		{else_expr, ElseExpr}
	}
	) ->
	create_if(Line, Condition, IfExpr, ElseExpr);

%% casa expressoes for
match_statement(
	{
		Line,
		for,
		{for_init, {var_type, VarType},	{var_name, VarName} },
		{for_start, Start},
		{condition_expr, CondExpr},
		{inc_expr, IncExpr},
		{for_body, Body}
	}
	) ->
	create_for(Line, VarType, VarName, Start, CondExpr, IncExpr, Body);

%% casa expressoes do tipo ++
match_statement({inc_op, Line, IncOp, Variable}) ->
	create_inc_op(Line, IncOp, Variable).

%%-----------------------------------------------------------------------------
%% casa expressoes/lista de expressoes dentro do IF,FOR,WHILE 
match_inner_stmt({block, StatementList}) ->
	lists:map(fun match_statement/1, StatementList);
match_inner_stmt(Statement) ->
	[match_statement(Statement)].

%%-----------------------------------------------------------------------------
%% Casa expressoes matematicas a procura de variaveis para substituir seus nomes
match_attr_expr({op, Line, Op, RightExp}=UnaryOp) ->
	{op, Line, Op, match_attr_expr(RightExp)};
match_attr_expr({integer, _Line, _Value} = Element) ->
	Element;
match_attr_expr({float, _Line, _Value} = Element) ->
	Element;
match_attr_expr({op, Line, Op, LeftExp, RightExp}) ->
	{op, Line, Op, match_attr_expr(LeftExp), match_attr_expr(RightExp)};
match_attr_expr({var, Line, VarName}) ->
	case  get(loop) of
		false ->
			{ok, VarRecord} = jaraki_identifier:get_var(VarName),
			case VarRecord#var.counter of
				0 ->
					ErrorMsg = "Variable in expression never used",
					jaraki_exception:handle_error(ErrorMsg);
				_ ->
					ok
			end,
			Counter = VarRecord#var.counter,
			JavaName = VarRecord#var.java_name,
			ErlangName = "Var_" ++ JavaName	++ integer_to_list(Counter),
			{var, Line, list_to_atom(ErlangName)};

		true ->
			{ok, VarRecord} = jaraki_identifier:get_var(VarName),
			JavaName =  VarRecord#var.java_name,
			{call, Line, {atom, Line, get}, [{string, Line, JavaName}]}
	end.
%%-----------------------------------------------------------------------------
%% Cria o elemento da east para as funcoes de impressao do java
create_print_function(Line, text, Text) ->
	{call, Line, {remote, Line,
		{atom, Line, io}, {atom, Line, format}}, [{string, Line, Text}]}.

create_print_function(Line, print, var, VarName) ->
	{ok, VarRecord} = jaraki_identifier:get_var(VarName),
	ErlangName = VarRecord#var.erl_name,
	{call, Line, {remote, Line,
		{atom, Line, io}, {atom, Line, format}},
		[{string, Line,"~p"},
			{cons, Line, {var, Line, list_to_atom(ErlangName)}, {nil, Line}}]};

create_print_function(Line, println, var, VarName) ->
	{ok, VarRecord} = jaraki_identifier:get_var(VarName),
	ErlangName = VarRecord#var.erl_name,
	{call, Line, {remote, Line,
		{atom, Line, io}, {atom, Line, format}},
		[{string, Line,"~p~n"},
			{cons, Line, {var, Line, list_to_atom(ErlangName)}, {nil, Line}}]}.

%%-----------------------------------------------------------------------------
%% Cria o elemento da east para atribuiçao de variaveis do java
create_attribution(Line, VarName, VarValue) ->
	{ok, VarRecord} = jaraki_identifier:get_var(VarName),
	NewCounter = VarRecord#var.counter + 1,
	JavaName = VarRecord#var.java_name,
	ErlangName = "Var_" ++ JavaName ++ integer_to_list(NewCounter),
	NewVarRecord = VarRecord#var{erl_name = ErlangName, counter = NewCounter},

	TransformedVarValue = match_attr_expr(VarValue),

	jaraki_identifier:set_var(VarName, NewVarRecord),

	ErlangVar = {var, Line, list_to_atom(ErlangName)},
	JavaNameAst = {string, Line, JavaName},

	PutAst = {call, Line, {atom, Line, put},[JavaNameAst, ErlangVar]},
	MatchAst  = {match, Line, ErlangVar, TransformedVarValue},

	{block, Line, [MatchAst, PutAst]}.
%%-----------------------------------------------------------------------------
%% Cria a operacao de incremento ++
create_inc_op(Line, IncOp, {var, _VarLine, VarName}) ->
	{ok, VarRecord} = jaraki_identifier:get_var(VarName),
	JavaName = VarRecord#var.java_name,

	case get(loop) of
		true ->
			VarAst = {string, Line, JavaName},
			GetAst = {call, Line, {atom, Line, get}, [VarAst]},

			{call, Line, {atom, Line, put},
				[VarAst, {op, Line, '+', GetAst, {integer, Line, 1}}]};

		false ->
			ok
	end.


%%-----------------------------------------------------------------------------
%% Cria o if
create_if(Line, Condition, IfExpr) ->
	TransformedCondition = match_attr_expr(Condition),
	TransformedIfExpr = match_inner_stmt(IfExpr),
	{
		'case',
		Line,
		TransformedCondition,
		[
			{ clause, Line, [{atom, Line, true}], [], TransformedIfExpr	},
			{
				clause,
				Line,
				[{var, Line, false}],
				[],
				[{atom, Line, no_operation}]
			}
		]
	}.

create_if(Line, Condition, IfExpr, ElseExpr) ->
	TransformedCondition = match_attr_expr(Condition),
	TransformedIfExpr = match_inner_stmt(IfExpr),
	TransformedElseExpr = match_inner_stmt(ElseExpr),
	{
		'case',
		Line,
		TransformedCondition,
		[
			{clause, Line, [{atom, Line, true}], [], TransformedIfExpr},
			{clause, Line, [{atom, Line, false}], [], TransformedElseExpr}
		]
	}.

%%-----------------------------------------------------------------------------
%% Cria o FOR
create_for(Line, VarType, VarName, Start, CondExpr, IncExpr, Body) ->
	put(loop, true),

	jaraki_identifier:insert(Line, VarType, VarName),

%% TODO talvez colocar esse incremento numa funcao, pois esta igual no create
%%       attribution
	{ok, VarRecord} = jaraki_identifier:get_var(VarName),
	NewCounter = VarRecord#var.counter + 1,
	JavaName = VarRecord#var.java_name,
	ErlangName = "Var_" ++ JavaName ++ integer_to_list(NewCounter),
	NewVarRecord = VarRecord#var{erl_name = ErlangName, counter = NewCounter},
	jaraki_identifier:set_var(VarName, NewVarRecord),
%% ------------------------------

	InitAst = {call, Line, {atom, Line + 1, put},
				[{string, Line, atom_to_list(VarName)}, Start]},

	CondAst = {'fun', Line,	{clauses, [{clause, Line, [], [],
				[match_attr_expr(CondExpr)]}]}},

	IncAst = {'fun', Line, {clauses, [{clause, Line, [], [],
				[match_statement(IncExpr)]}]}},

	StartBodyAst = create_inner_vars(Line),
	%% TODO verificar nome melhor para CoreBody
	put(loop, false),
	CoreBody = match_inner_stmt(Body),
	put(loop, true),
	EndBodyAst   = update_inner_vars(Line),

	BodyAst = {'fun', Line, {clauses, [{clause, Line, [], [],
				lists:flatten([
					StartBodyAst,
					CoreBody,
					EndBodyAst])
				}]}},

	ForAst = {call, Line, {atom, Line, for}, [CondAst, IncAst, BodyAst]},

	put(loop, false),

	jaraki_identifier:remove(VarName),

	RemoveForVariable = {call, Line, {atom, Line, erase},
							[{string, Line, atom_to_list(VarName)}]},
	UpdateVariables = create_inner_vars(Line),
	ForBlock = [InitAst, ForAst, RemoveForVariable, UpdateVariables],

	{block, Line, lists:flatten(ForBlock)}.

%%-----------------------------------------------------------------------------
%% cria as variaveis que estao dentro do FOR
%% TODO: verificar nome melhor
create_inner_vars(Line) ->
	VarsList = jaraki_identifier:get_all_vars(),
	create_inner_vars(Line, VarsList, []).

create_inner_vars(_, [], VarAttrList) -> VarAttrList;
create_inner_vars(Line, [ {loop,_} | Rest ], VarAttrList) ->
	create_inner_vars(Line, Rest, VarAttrList);
create_inner_vars(Line, [Var | Rest], VarAttrList) ->
	{{vars, VarName}, VarRecord} = Var,

	JavaName   = VarRecord#var.java_name,

%% TODO talvez colocar esse incremento numa funcao, pois esta igual no create
%%       attribution e no create for
	NewCounter = VarRecord#var.counter + 1,
	ErlangName = "Var_" ++ JavaName ++ integer_to_list(NewCounter),
	NewVarRecord = VarRecord#var{erl_name = ErlangName, counter = NewCounter},
	jaraki_identifier:set_var(VarName, NewVarRecord),
%% ---------------------------------

	GetAst = {call, Line, {atom, Line, get}, [{string, Line, JavaName}]},

	VarAttr = {match, Line, {var, Line, list_to_atom(ErlangName)}, GetAst},
	create_inner_vars(Line, Rest, [VarAttr | VarAttrList]).

%%-----------------------------------------------------------------------------
%% TODO: verificar nome melhor
update_inner_vars(Line) ->
	VarList = jaraki_identifier:get_all_vars(),
	update_inner_vars(Line, VarList, []).

update_inner_vars(_, [], VarUpdtList) -> VarUpdtList;
update_inner_vars(Line, [ {loop,_} | Rest ], VarUpdtList) ->
	update_inner_vars(Line, Rest, VarUpdtList);
update_inner_vars(Line, [Var | Rest], VarUpdtList) ->
	{_Key, VarRecord} = Var,

	ErlangName = VarRecord#var.erl_name,
	JavaName   = VarRecord#var.java_name,

	VarUpdt = {call, Line, {atom, Line, put},
		[{string, Line, JavaName}, {var, Line, list_to_atom(ErlangName)}]},
	update_inner_vars(Line, Rest, [VarUpdt | VarUpdtList]).
