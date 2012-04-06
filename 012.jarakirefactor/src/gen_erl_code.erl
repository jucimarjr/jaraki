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
-import(gen_ast,
	[
		function/4, var/2, atom/2, call/3, rcall/4, 'case'/3, clause/4, 
		'fun'/2, string/2, tuple/2, atom/2
	]).
-include("../include/jaraki_define.hrl").

%%-----------------------------------------------------------------------------
%% transformacoes de expressoes em java para erlang
%% apenas uma unica expressao
match_statement({var_declaration, VarType, VarList}) ->
	create_declaration(var_declaration, VarType, VarList);

%% Instanciação do Scanner é ignorado no parser
match_statement(no_operation) ->
	no_operation;

%% transforma expressoes do tipo System.out.print em Erlang
match_statement({Line, print, Content}) ->
	create_print_function(Line, print, Content);

%% transforma expressoes System.out.println em Erlang
match_statement({Line, println, Content}) ->
	 create_print_function(Line, println, Content);

%% transforma chamadas de funcoes em Erlang
match_statement({function_call, {Line, FunctionName},
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
		{for_init, {var_type, VarType},	{var_name, VarName}},
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
	{block, Line,
      		[{match, Line, var(Line,'Return'), match_attr_expr(Value)},
		rcall(Line, st, get_old_stack, [atom(Line, st:get_scope())]),
       		var(Line,'Return')]
	}.

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
match_attr_expr({sqrt, Line, RightExp}) ->
	rcall(Line, math, sqrt, [match_attr_expr(RightExp)]);
match_attr_expr({next_int, Line, VarScanner})->
	create_function_scanner(next_int, Line, VarScanner);
match_attr_expr({next_float, Line, VarScanner})->
	create_function_scanner(next_float, Line, VarScanner);
match_attr_expr({next_line, Line, VarScanner})->
	create_function_scanner(next_line, Line, VarScanner);
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
	st:get2(Line, st:get_scope(), VarName),
	rcall(Line, st, get_value,
		[atom(Line, st:get_scope()), string(Line, VarName)]).

create_declaration(var_declaration, {var_type, {VarLine, _VarType}},
						{var_list, VarList}) ->
	VarAstList = create_declaration_list(VarLine, VarList, []),
	case VarAstList of
		[] ->
			no_operation;
		_ ->
			{block, VarLine, VarAstList}
	end.

create_declaration_list(_VarLine, [], VarAstList) ->
	lists:reverse(VarAstList, []);

create_declaration_list(VarLine, [H| Rest], VarAstList) ->
	{{var, VarName}, {var_value, VarValue}} = H,
	case VarValue of
		undefined ->
				create_declaration_list(VarLine, Rest, VarAstList);

		{array_initializer, ArrayElementsList} ->
			ArrayAst = create_array_attribution(VarLine,
							 VarName, ArrayElementsList),
				create_declaration_list(VarLine, Rest, [ArrayAst| VarAstList]);

		_ -> VarAst = create_attribution(VarLine, VarName, VarValue),
					create_declaration_list(VarLine, Rest, [VarAst| VarAstList])
	end.

%-------------------------------------------------------------------------------
% Cria elemento da east para Scanner
% VarScanner é o nome da variável instanciada no scanner
create_function_scanner(next_int, Line, _VarScanner) ->
	 Prompt = string(Line, '>'),
	 ConsoleContent = string(Line, '~d'),
	rcall(Line, io, fread, [Prompt, ConsoleContent]);
create_function_scanner(next_float, Line, _VarScanner) ->
	 Prompt = string(Line, '>'),
	 ConsoleContent = string(Line, '~f'),
    rcall(Line, io, fread, [Prompt, ConsoleContent]);
create_function_scanner(next_line, Line, _VarScanner) ->
	 Prompt = string(Line, '>'),
	 ConsoleContent = string(Line, '~s'),
    rcall(Line, io, fread, [Prompt, ConsoleContent]).

 %%-----------------------------------------------------------------------------
 %% Cria o elemento da east para as funcoes de impressao do java
create_print_function(Line, print, Content) ->
	 PrintText = print_text(Content, Line, [], print),
	 PrintContent = print_list(Content, Line),

	 rcall(Line, io, format, [PrintText, PrintContent]);

create_print_function(Line, println, Content) ->

	PrintText = print_text(Content, Line, [], println),
	PrintContent = print_list(Content, Line),

	rcall(Line, io, format, [PrintText, PrintContent]).

print_text([], Line, Text, print) ->
	string(Line, Text);
print_text([], Line, Text, println) ->
	string(Line, Text ++ "~n");
print_text([Head | L], Line, Text, _print) ->
	{Type, _, PrintElement} = Head,
	case Type of
		identifier ->
		Value = st:get2(Line, st:get_scope(), PrintElement),
		{TypeId, _VarValue} = Value,
		case TypeId of
		    int ->
			print_text(L, Line, Text ++ "~p", _print);
		    float ->
			print_text(L, Line, Text ++ "~f", _print);
		    _ ->
			print_text(L, Line, Text ++ "~s", _print)
		end;
		text ->
			print_text(L, Line, Text ++ "~s", _print)
	end.

print_list([], Line) ->
	{nil, Line};
print_list([Element|L], Line) ->
	{Type, _, PrintElement} = Element,
	case Type of
	identifier ->
		Identifier = rcall(Line, st, get_value, [atom(Line, st:get_scope()),
				string(Line, PrintElement)]),
		{cons, Line, Identifier, print_list(L, Line)};
	text ->
		{cons, Line, string(Line, PrintElement), print_list(L, Line)}
end.

%%---------------------------------------------------------------------------%%

create_function_call(Line, FunctionName, ArgumentsList) ->
	TransformedArgumentList =
		lists:map(fun match_attr_expr/1, ArgumentsList),
	FunctionCall = call(Line, FunctionName, TransformedArgumentList),
	Fun = 'fun'(Line, [clause(Line,[],[], [FunctionCall])]),
	rcall(Line, st, return_function, 
		[Fun, atom(Line, FunctionName), 
			create_list(TransformedArgumentList, Line)]).

create_list([], Line) ->
	{nil, Line};
create_list([Element| Rest], Line) ->
	{cons, Line, Element, create_list(Rest, Line)}.

%%-----------------------------------------------------------------------------
%% Cria o elemento da east para atribuiçao de variaveis do java
create_attribution(Line, VarName, VarValue) ->
	{Type, _Value} = st:get2(Line, st:get_scope(), VarName),	
	jaraki_exception:check_var_type(Type, VarValue),

	TransformedVarValue = match_attr_expr(VarValue),
	JavaNameAst = string(Line, VarName),

	TypeAst = atom(Line, Type),
	ScopeAst = atom(Line, st:get_scope()),

	rcall(Line, st, put_value, [
				tuple(Line, [ScopeAst, JavaNameAst]),
				tuple(Line, [TypeAst, TransformedVarValue])]).

%% Transforma os elementos do array - vet = {1, 2 ,3}
create_array_values(_Line, _VarName, _Type, [], ArrayElementsAst, _Index) ->
	lists:reverse(ArrayElementsAst, []);

create_array_values(Line , VarName, Type, [H| Rest], ArrayElementsAst, Index) ->
	{array_element, ElementArray} =  H,

	{Type, _Value} = st:get2(Line, st:get_scope(), VarName),
	%jaraki_exception:check_var_type(Type, VarValue),
	JavaNameAst = string(Line, VarName),
	TypeAst = atom(Line, Type),
	ScopeAst = atom(Line, st:get_scope()),


	ArrayGetAst = rcall(Line, st, get_value, [ScopeAst, JavaNameAst]),

	ArraySetAst = rcall(Line, array, set, [{integer, Line, Index},
		{integer, Line, ElementArray}, ArrayGetAst]),

	ElementAst = rcall(Line, st, put_value, [
				tuple(Line, [ScopeAst, JavaNameAst]),
				tuple(Line, [TypeAst, ArraySetAst])]),

	create_array_values(Line, VarName, Type, Rest,
						[ElementAst|ArrayElementsAst], Index+1).

%%Array inicializado
create_array_attribution(Line, VarName, [{array_element, ElementArray} |
					RestArray]) ->
	{Type, _Value} = st:get2(Line, st:get_scope(), VarName),
	%jaraki_exception:check_var_type(Type, VarValue),
	JavaNameAst = string(Line, VarName),
	TypeAst = atom(Line, Type),
	ScopeAst = atom(Line, st:get_scope()),

%% Usado para o primeiro elemento do array initializer
	ArrayNew = rcall(Line, array, new, []),

	HeadSetAst = rcall(Line, array, set, [{integer, Line, 0},
								{integer, Line, ElementArray}, ArrayNew]),

	ArrayHeadAst = rcall(Line, st, put_value, [
				tuple(Line, [ScopeAst, JavaNameAst]),
				tuple(Line, [TypeAst, HeadSetAst])]),

	ArrayRestAst = create_array_values(Line, VarName, Type, RestArray, [], 1),

	{block, Line, lists:flatten([ArrayHeadAst, ArrayRestAst])}.

%%-----------------------------------------------------------------------------
%% Cia a operacao de in	cremento ++
create_inc_op(Line, IncOp, {var, _VarLine, VarName} = VarAst) ->
		Inc =
			case IncOp of
				'++' -> '+';
				'--' ->	'-'
			end,

		VarValue = {op, Line, Inc, VarAst, {integer, Line, 1}},
		create_attribution(Line, VarName, VarValue).

%%-----------------------------------------------------------------------------
%% Cria o if
create_if(Line, Condition, IfExpr) ->
	TransformedCondition = match_attr_expr(Condition),
	TransformedIfExpr = match_inner_stmt(IfExpr),
	'case'(Line, TransformedCondition, [
		clause(Line, [atom(Line, true)], [], TransformedIfExpr),
		clause(Line, [atom(Line, false)], [], [atom(Line, no_operation)])
	]).

create_if(Line, Condition, IfExpr, ElseExpr) ->
	TransformedCondition = match_attr_expr(Condition),
	TransformedIfExpr = match_inner_stmt(IfExpr),
	TransformedElseExpr = match_inner_stmt(ElseExpr),
	'case'(Line, TransformedCondition,[
		clause(Line, [atom(Line, true)], [], TransformedIfExpr),
		clause(Line, [atom(Line, false)], [], TransformedElseExpr)
	]).

%%-----------------------------------------------------------------------------
%% Cria o FOR
create_for(Line, VarType, VarName, Start, CondExpr, IncExpr, Body) ->
	JavaNameAst = string(Line, VarName),
	TypeAst = atom(Line, VarType),
	ScopeAst = {atom, Line, st:get_scope()},
	InitAst = rcall(Line, st, put_value,[
			tuple(Line, [ScopeAst, JavaNameAst]), 
			tuple(Line, [TypeAst, Start])]),

	st:put_value({st:get_scope(), VarName}, {VarType, undefined}),

	CondAst = 'fun'(Line, [clause(Line, [], [], [match_attr_expr(CondExpr)])]),
	IncAst = 'fun'(Line, [clause(Line, [], [], [match_statement(IncExpr)])]),
	CoreBody = match_inner_stmt(Body),
	BodyAst = 'fun'(Line, [clause(Line, [], [], CoreBody)]),
	ForAst = call(Line, for, [CondAst, IncAst, BodyAst]),
	EndAst = rcall(Line, st, delete, [ScopeAst, JavaNameAst]),

	st:delete(st:get_scope(), VarName),

	ForBlock = [InitAst, ForAst, EndAst],
	{block, Line, lists:flatten(ForBlock)}.

create_while(Line, CondExpr, Body) ->

	CondAst = 'fun'(Line, [clause(Line, [], [], [match_attr_expr(CondExpr)])]),
	CoreBody = match_inner_stmt(Body),
	BodyAst = 'fun'(Line, [clause(Line, [], [], CoreBody)]),
	call(Line, while, [CondAst, BodyAst]).
