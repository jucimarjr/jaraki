%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% 			Eden ( edenstark@gmail.com )
%% 			Helder Cunha Batista ( hcb007@gmail.com )
%% 			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% 			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% 			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : 

-module(jaraki_core).
-compile(export_all).
-include("../include/jaraki_define.hrl").

%%-----------------------------------------------------------------------------
%% Converte o jast em east.
%%   jast -> arvore sintatica do java.
%%   east -> arvore sintatica do erlang.
%% TODO: tratar múltiplos arquivos, ou seja, múltiplas classes

transform_jast_to_east(JavaAST, ModuleName) ->
	ErlangAST = lists:map(fun(Class) -> transform_class(Class) end, JavaAST),
	create_module(ModuleName, ErlangAST).

%%-----------------------------------------------------------------------------
%% Converte a classe do java em modulo erlang.
%% TODO: Tratar atributos ("variáveis globais") da classe...
transform_class(Class) ->
	{_Line, _ClassName, {class_body, ClassBody}} = Class,
	lists:map(fun(Method) -> transform_method(Method) end, ClassBody).

%%-----------------------------------------------------------------------------
%% Converte o metodo java em funcao erlang.
%% TODO: Tratar metodos genericos...
transform_method({Line, {method, 'main'}, Arguments, 
					{method_body, MethodBody}} = Method) ->
		[{_Line, {class_identifier, ArgClass}, _ArgName}] = Arguments,
		case ArgClass of
			'String' ->
						ok;
			_ ->
				jaraki_exception:handle_error("The args of the \"main method\" is not String")
		end,

		TransformedMethodBody =
			transform_method_body(Line, MethodBody, Arguments),
		{function, Line, 'main', length(Arguments), TransformedMethodBody};
transform_method(_) ->
	jaraki_exception:handle_error("The method defined is not a \"main method\"").

%%-----------------------------------------------------------------------------
%% Converte o corpo do metodo java em funcao erlang.
%% TODO: Verificar melhor forma de detectar "{nil, Line}".
transform_method_body(Line, MethodBody, ArgumentsList) ->
	TransformedArgumentsList =
		[{var, Line, ArgName} || 
			{Line, _ClassIdentifier, {argument, ArgName}} <- ArgumentsList],

	MapFun = fun({VarLine, var_declaration, Type, Name}) ->
						jaraki_identifier:insert(VarLine, Type, Name);
					 (Expression) ->
						match_expression(Expression)
				  end,
	TransformedExpressions = lists:map( MapFun, MethodBody ),
	TransformedExpressions2 =
		[Element || Element <- TransformedExpressions,
											Element =/= no_operation],
	[{clause, Line, TransformedArgumentsList, [], TransformedExpressions2}].

%%-----------------------------------------------------------------------------
%% transformacoes de expressoes em java para erlang

%% transforma expressoes do tipo System.out.print( texto ) em Erlang
match_expression({Line, print, {text, Text}}) ->
	create_print_function(Line, text, Text);

%% transforma expressoes System.out.println( texto ) em Erlang
match_expression({Line, println, {text, Text}}) ->
	create_print_function(Line, text, Text ++ "~n");

%% transforma expressoes do tipo System.out.print( texto ) em Erlang
match_expression({Line, print, {var, VarName}}) ->
	create_print_function(Line, print, var, VarName);

%% transforma expressoes System.out.println( texto ) em Erlang
match_expression({Line, println, {var, VarName}}) ->
	create_print_function(Line, println, var, VarName);

%% Casa expressoes do tipo varivel = valor
match_expression({Line, attribution,
			{var, VarName}, {var_value, VarValue}}) ->
	create_attribution(Line, VarName, VarValue).

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
	{ok, VarRecord} = jaraki_identifier:get_var
(VarName),

	Counter = VarRecord#var.counter + 1,
	ErlangName = "Var_" ++ VarRecord#var.java_name ++ integer_to_list(Counter),
	NewVarRecord = VarRecord#var{erl_name = ErlangName, counter = Counter},

	Transformed_VarValue = match_attr_expr(VarValue),

	jaraki_identifier:set_var(VarName, NewVarRecord),

	{match, Line, {var, Line, list_to_atom(ErlangName)}, Transformed_VarValue}.

%%-----------------------------------------------------------------------------
%% Cria o modulo a partir do east.
create_module(Name, ErlangAST) ->
	[{attribute, 1, module, Name},
		{attribute,1,compile,export_all}] ++ hd(ErlangAST)
		++ [{eof, 1}].

