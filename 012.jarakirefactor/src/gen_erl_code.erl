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

%% transforma expressoes do tipo System.out.print( variavel ) em Erlang
match_statement({Line, print, {var, VarName}}) ->
	create_print_function(Line, print, var, VarName);

%% transforma expressoes System.out.println( variavel ) em Erlang
match_statement({Line, println, {var, VarName}}) ->
	create_print_function(Line, println, var, VarName);

%% transforma expressoes System.out.print( texto + identificador ) em Erlang
match_statement({Line, print, {text, Text}, {var, VarName}}) ->
	create_print_function(Line, print, text, Text, var, VarName);

%% transforma expressoes System.out.println( texto + identificador ) em Erlang
match_statement({Line, println, {text, Text}, {var, VarName}}) ->
	create_print_function(Line, println, text, Text, var, VarName);

%% transforma chanadas de funcoes em Erlang
match_statement( {function_call, {Line, FunctionName},
					{argument_list, ArgumentsList}}) ->
	create_function_call(Line, FunctionName, ArgumentsList);

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

%%casa expressoes do while
match_statement(
	{
		Line,
		while,
		{condition_expr, CondExpr},
		{while_body, Body}
	}
	) ->

	create_while(Line, CondExpr, Body);

%% casa expressoes do tipo ++
match_statement({inc_op, Line, IncOp, Variable}) ->
	create_inc_op(Line, IncOp, Variable);

%% casa expressões return;
match_statement({Line, return, Value}) ->
	match_attr_expr(Value).

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
match_attr_expr({function_call, {Line, FunctionName},
			{argument_list, ArgumentsList}}) ->
	create_function_call(Line, FunctionName, ArgumentsList);
match_attr_expr({integer, _Line, _Value} = Element) ->
	Element;
match_attr_expr({float, _Line, _Value} = Element) ->
	Element;
match_attr_expr({atom, _Line, true} = Element) ->
	Element;
match_attr_expr({atom, _Line, false} = Element) ->
	Element;
match_attr_expr({op, Line, Op, LeftExp, RightExp}) ->
	{op, Line, Op, match_attr_expr(LeftExp), match_attr_expr(RightExp)};
match_attr_expr({var, Line, VarName}) ->
	{call, Line, {remote, Line,
		{atom, Line, st},{atom, Line, get}},
			[{string, Line, atom_to_list(VarName)}]}.
%%-----------------------------------------------------------------------------
%% Cria o elemento da east para as funcoes de impressao do java
create_print_function(Line, text, Text) ->
	{call, Line, {remote, Line,
		{atom, Line, io}, {atom, Line, format}}, [{string, Line, Text}]}.

create_print_function(Line, print, var, VarName) ->
	VarAst = {call, Line, {remote, Line,
		{atom, Line, st},{atom, Line, get}},
			[{string, Line, atom_to_list(VarName)}]},

	{call, Line, {remote, Line,
		{atom, Line, io}, {atom, Line, format}},
		[{string, Line,"~p"},
			{cons, Line, VarAst, {nil, Line}}]};

create_print_function(Line, println, var, VarName) ->
	VarAst = {call, Line, {remote, Line,
		{atom, Line, st},{atom, Line, get}},
			[{string, Line, atom_to_list(VarName)}]},

	{call, Line, {remote, Line,
		{atom, Line, io}, {atom, Line, format}},
		[{string, Line,"~p~n"},
			{cons, Line, VarAst, {nil, Line}}]}.

create_print_function(Line, print, text, Text, var, VarName) ->
	VarAst = {call, Line, {remote, Line,
		{atom, Line, st},{atom, Line, get}},
			[{string, Line, atom_to_list(VarName)}]},

	{call, Line, {remote, Line,
		{atom, Line, io}, {atom, Line, format}},
		[{string, Line, Text ++ "~p"},
			{cons, Line, VarAst, {nil, Line}}]};

create_print_function(Line, println, text, Text, var, VarName) ->
	VarAst = {call, Line, {remote, Line,
		{atom, Line, st},{atom, Line, get}},
			[{string, Line, atom_to_list(VarName)}]},

	{call, Line, {remote, Line,
		{atom, Line, io}, {atom, Line, format}},
		[{string, Line, Text ++ "~p~n"},
			{cons, Line, VarAst, {nil, Line}}]}.

%%---------------------------------------------------------------------------%%

create_function_call(Line, FunctionName, ArgumentsList) ->
	TransformedArgumentList = lists:map(fun match_attr_expr/1, ArgumentsList),
	{call, Line, {atom, Line, FunctionName}, TransformedArgumentList}.


%%-----------------------------------------------------------------------------
%% Cria o elemento da east para atribuiçao de variaveis do java
create_attribution(Line, VarName, VarValue) ->
	TransformedVarValue = match_attr_expr(VarValue),
	JavaNameAst = {string, Line, atom_to_list(VarName)},
	{call, Line,
				{remote, Line, {atom, Line, st}, {atom, Line, insert}},
					[{tuple, Line, [JavaNameAst, TransformedVarValue]}]}.

%%-----------------------------------------------------------------------------
%% Cria a operacao de incremento ++
create_inc_op(Line, IncOp, {var, _VarLine, VarName}=VarAst) ->
		Inc =
			case IncOp of
				'++' -> '+';
				'--' ->	'-'
			end,

		VarValue = {op, Line, Inc,
						VarAst,
							{integer, Line,1}},
		create_attribution(Line, VarName, VarValue).


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
	InitAst = {call, Line,
		{remote, Line, {atom, Line, st}, {atom, Line, insert}},
		[{tuple, Line,
				[{string, Line, atom_to_list(VarName)},
					Start]}]},

	CondAst = {'fun', Line,	{clauses, [{clause, Line, [], [],
				[match_attr_expr(CondExpr)]}]}},

	IncAst = {'fun', Line, {clauses, [{clause, Line, [], [],
				[match_statement(IncExpr)]}]}},

	%% TODO verificar nome melhor para CoreBody
	CoreBody = match_inner_stmt(Body),

	BodyAst = {'fun', Line, {clauses, [{clause, Line, [], [], CoreBody}]}},

	ForAst = {call, Line, {atom, Line, for}, [CondAst, IncAst, BodyAst]},

	ForBlock = [InitAst, ForAst],

	{block, Line, lists:flatten(ForBlock)}.

create_while(Line, CondExpr, Body) ->

	CondAst = {'fun', Line,	{clauses, [{clause, Line, [], [],
			[match_attr_expr(CondExpr)]}]}},


	CoreBody = match_inner_stmt(Body),



	BodyAst = {'fun', Line, {clauses, [{clause, Line, [], [],
					CoreBody}]}},

	{call, Line, {atom, Line, while}, [CondAst, BodyAst]}.
