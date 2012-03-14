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

%% transforma expressoes do tipo System.out.print em Erlang
match_statement({Line, print, Content}) ->
	create_print_function(Line, print, Content);

%% transforma expressoes System.out.println em Erlang
match_statement({Line, println, Content}) ->
	 create_print_function(Line, println, Content);


%% transforma chamadas de funcoes em Erlang
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
match_statement({_Line, return, Value}) ->
	match_attr_expr(Value).

%%-----------------------------------------------------------------------------
%% casa expressoes/lista de expressoes dentro do IF,FOR,WHILE 
match_inner_stmt({block, StatementList}) ->
	lists:map(fun match_statement/1, StatementList);
match_inner_stmt(Statement) ->
	[match_statement(Statement)].

%%-----------------------------------------------------------------------------
%% Casa expressoes matematicas a procura de variaveis para substituir seus nomes

match_attr_expr({op, Line, Op, RightExp}) ->
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
			[{atom, Line, st:get_scope()},
				{string, Line, atom_to_list(VarName)}]}.

%%-----------------------------------------------------------------------------
%% Cria o elemento da east para as funcoes de impressao do java
create_print_function(Line, print, Content) ->

	PrintText = print_test(Content, Line, [], print),
	PrintContent = print_list(Content, Line),

	{call, Line, {remote, Line,
		{atom, Line, io}, {atom, Line, format}}, 
		[PrintText, PrintContent]};

create_print_function(Line, println, Content) ->

	PrintText = print_test(Content, Line, [], println),
	PrintContent = print_list(Content, Line),

	{call, Line, {remote, Line,
		{atom, Line, io}, {atom, Line, format}}, 
		[PrintText, PrintContent]}.

print_test([], Line, Text, print) ->
	{string, Line, Text};
print_test([], Line, Text, println) ->
	{string, Line, Text ++ "~n"};
print_test([Head | L], Line, Text, _print) ->
	{Type, _, _PrintElement} = Head,
	case Type of
		identifier ->
			print_test(L, Line, Text ++ "~p", _print);
		text ->
			print_test(L, Line, Text ++ "~s", _print)
	end.

print_list([], Line) ->
	{nil, Line};
print_list([Element|L], Line) ->
	{Type, _, PrintElement} = Element,
	case Type of
	 identifier ->
	   Identifier = {call, Line, {remote, Line,
			{atom, Line, st},{atom, Line, get}},
				[{atom, Line, st:get_scope()}, 
				{string, Line, atom_to_list(PrintElement)}]},
			{cons, Line, Identifier, print_list(L, Line)};
	text ->
		{cons, Line, {string, Line, PrintElement}, print_list(L, Line)}
end.

%%---------------------------------------------------------------------------%%

create_function_call(Line, FunctionName, ArgumentsList) ->
	TransformedArgumentList = 
		lists:map(fun match_attr_expr/1, ArgumentsList),
	{call, Line, {atom, Line, FunctionName}, TransformedArgumentList}.

%%-----------------------------------------------------------------------------
%% Cria o elemento da east para atribuiçao de variaveis do java
create_attribution(Line, VarName, VarValue) ->
	TransformedVarValue = match_attr_expr(VarValue),
	JavaNameAst = {string, Line, atom_to_list(VarName)},
	
	{Type, _Value} = st:get2(st:get_scope(), VarName),	
	TypeAst = {atom, Line, Type},
	ScopeAst = {atom, Line, st:get_scope()},
	
	{call, Line, {remote, Line, {atom, Line, st}, {atom, Line, put}},
			[{tuple, Line, [ScopeAst, JavaNameAst]}, {tuple, Line, 
			[TypeAst, TransformedVarValue]}]}.

%%-----------------------------------------------------------------------------
%% Cria a operacao de incremento ++
create_inc_op(Line, IncOp, {var, _VarLine, VarName} = VarAst) ->
		Inc =
			case IncOp of
				'++' -> '+';
				'--' ->	'-'
			end,

		VarValue = {op, Line, Inc, VarAst, {integer, Line,1}},
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
		[{ clause, Line, [{atom, Line, true}], [], TransformedIfExpr},
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
	{'case', Line, TransformedCondition,
	[
		{clause, Line, [{atom, Line, true}], [], TransformedIfExpr},
		{clause, Line, [{atom, Line, false}], [], TransformedElseExpr}
	]
	}.

%%-----------------------------------------------------------------------------
%% Cria o FOR
create_for(Line, VarType, VarName, Start, CondExpr, IncExpr, Body) ->
	
	JavaNameAst = {string, Line, atom_to_list(VarName)},
	TypeAst = {atom, Line, VarType},
	ScopeAst = {atom, Line, st:get_scope()},
	InitAst = {call, Line, {remote, Line, {atom, Line, st}, 
			{atom, Line, put}},
			[{tuple, Line, [ScopeAst, JavaNameAst]}, {tuple, Line, 
			[TypeAst, Start]}]},

	st:put({st:get_scope(), VarName}, {VarType, undefined}),

	CondAst = {'fun', Line,	{clauses, [{clause, Line, [], [],
				[match_attr_expr(CondExpr)]}]}},

	IncAst = {'fun', Line, {clauses, [{clause, Line, [], [],
				[match_statement(IncExpr)]}]}},

	%% TODO verificar nome melhor para CoreBody
	CoreBody = match_inner_stmt(Body),

	BodyAst = {'fun', Line, {clauses, [{clause, Line, [], [], CoreBody}]}},

	ForAst = {call, Line, {atom, Line, for}, [CondAst, IncAst, BodyAst]},

	EndAst = {call, Line, {remote, Line, {atom, Line, st}, 
			{atom, Line, delete}},
			[ScopeAst, JavaNameAst]},

	st:delete(st:get_scope(), VarName),

	ForBlock = [InitAst, ForAst, EndAst],

	{block, Line, lists:flatten(ForBlock)}.

create_while(Line, CondExpr, Body) ->

	CondAst = {'fun', Line,	{clauses, [{clause, Line, [], [],
			[match_attr_expr(CondExpr)]}]}},

	CoreBody = match_inner_stmt(Body),

	BodyAst = {'fun', Line, {clauses, [{clause, Line, [], [],
					CoreBody}]}},

	{call, Line, {atom, Line, while}, [CondAst, BodyAst]}.
