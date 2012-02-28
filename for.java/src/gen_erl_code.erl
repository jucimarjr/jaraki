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
match_statement({Line, attribution,
			{var, VarName}, {var_value, VarValue}}) ->
	create_attribution(Line, VarName, VarValue);

%% Casa expressoes if( Bool_expr ) ...
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
		{for_end, End},
		{comp_op, CompOp}, 
		{inc_op, '++'}, 
		{for_body, Body}
	}
	) ->
	create_for(Line, VarType, VarName, CompOp, Start, End, Body);

%% TODO não esquecer de retirar esse tratamento de FOR pelamordedeus O.o
match_statement({Line, for, _, _, _, _, _, _, _}) ->
	ErrorMsg1 = "for deve ser no seguinte formato: ",
	ErrorMsg2 = ErrorMsg1 ++ "for( int i = Num; i < Num; i++ ) ...",
	%% io:format("~p\n\n", [Oi]),
	jaraki_exception:handle_error(ErrorMsg2).

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
	{ok, VarRecord} = jaraki_identifier:get_var(VarName),
	case VarRecord#var.counter of
		0 ->
			jaraki_exception:handle_error("Variable in expression never used");
		_ ->
			ok
	end,
	Counter = VarRecord#var.counter,
	ErlangName = "Var_" ++ VarRecord#var.java_name ++ integer_to_list(Counter),
	{var, Line, list_to_atom(ErlangName)}.

%%-----------------------------------------------------------------------------
%% casa expressoes/lista de expressoes dentro do IF,FOR,WHILE 
match_inner_stmt({block, StatementList}) ->
	lists:map(fun match_statement/1, StatementList);
match_inner_stmt(Statement) ->
	[match_statement(Statement)].

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
	Counter = VarRecord#var.counter + 1,
	ErlangName = "Var_" ++ VarRecord#var.java_name ++ integer_to_list(Counter),
	NewVarRecord = VarRecord#var{erl_name = ErlangName, counter = Counter},

	TransformedVarValue = match_attr_expr(VarValue),

	jaraki_identifier:set_var(VarName, NewVarRecord),

	{match, Line, {var, Line, list_to_atom(ErlangName)}, TransformedVarValue}.

%%-----------------------------------------------------------------------------
%% Cria o if
create_if(Line, Condition, IfExpr) ->
	TransformedCondition = match_attr_expr(Condition),
	TransformedIfExpr = match_inner_stmt(IfExpr),
	{'case', Line, TransformedCondition,
			[{clause, Line, [{atom, Line, true}], [], TransformedIfExpr},
			 {clause, Line, [{var, Line, false}], [],
			[{atom, Line, no_operation}]}]}.

create_if(Line, Condition, IfExpr, ElseExpr) ->
	TransformedCondition = match_attr_expr(Condition),
	TransformedIfExpr = match_inner_stmt(IfExpr),
	TransformedElseExpr = match_inner_stmt(ElseExpr),
	{'case', Line, TransformedCondition,
			[{clause, Line, [{atom, Line, true}], [], TransformedIfExpr},
			 {clause, Line, [{atom, Line, false}], [], TransformedElseExpr}]}.

%%-----------------------------------------------------------------------------
%% Cria o FOR
create_for(Line, VarType, VarName, CompOp, Start, End, Body) ->
	End2 =
	case End of
		{var, EndLine, EndName} ->
			{ok, EndRecord} = jaraki_identifier:get_var(EndName),
			EndErlangName = EndRecord#var.erl_name,
			case CompOp of
				'<' ->
					{op, EndLine, '-',
						{var, EndLine, list_to_atom(EndErlangName)},
						{integer, EndLine, 1}};
				'<=' ->
					{var, EndLine, list_to_atom(EndErlangName)}
			end;

		{integer, LineNum, EndNum} ->
			case CompOp of
				'<' ->
					{integer, LineNum, EndNum} = End,
					{integer, LineNum, EndNum-1};
				'<=' ->
					End
			end
	end,

	jaraki_identifier:insert(Line, VarType, VarName),
	TransformedBody = {block, Line, match_inner_stmt(Body)},

	{ok, VarRecord} = jaraki_identifier:get_var(VarName),
	ErlangName = VarRecord#var.erl_name,

	jaraki_identifier:remove(VarName),

	Sequence = {call, Line,
				{remote, Line, {atom, Line, lists}, {atom, Line, seq}},
				[Start, End2]},

	Generator = {generate, Line,
					{var, Line, list_to_atom(ErlangName)}, Sequence},
	{lc, Line, TransformedBody, [Generator]}.
