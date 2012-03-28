%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% 			Eden Freitas Ramos ( edenstark@gmail.com )
%% 			Helder Cunha Batista ( hcb007@gmail.com )
%% 			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% 			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% 			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Tratar as ocorrências de exceções

-module(jaraki_exception).
-compile(export_all).

handle_error(Line, Msg) ->
	throw({error, Msg, Line}).

%%-----------------------------------------------------------------------------
%% Casa expressoes matematicas a procura de variaveis para substituir seus nomes

%% TODO: verificar tipo do retorno da função!!
%%
%% check_var_type(Type, {function_call, {Line, FunctionName},
%%			{argument_list, ArgumentsList}}) ->
%%	 create_function_call(Line, FunctionName, ArgumentsList);
%% check_var_type(Type, {sqrt, Line, RightExp}) ->
%%	 do_check_var_type(Type, double);
check_var_type(Type, {op, Line, Op, RightExp}) ->
	{op, Line, Op, check_var_type(Type, RightExp)};
check_var_type(Type, {integer, Line, _Value}) ->
	match_type(Line, Type, integer);
check_var_type(Type, {float, Line, _Value}) ->
	match_type(Line, Type, float);
check_var_type(Type, {atom, Line, true}) ->
	match_type(Line, Type, boolean);
check_var_type(Type, {atom, Line, false}) ->
	match_type(Line, Type, boolean);
check_var_type(Type, {op, Line, Op, LeftExp, RightExp}) ->
	{op, Line, Op,
		check_var_type(Type, LeftExp),
		check_var_type(Type, RightExp)};

check_var_type(AttrVarType, {var, Line, VarName}) ->
	{ExprVarType, _Value} = st:get2(Line, st:get_scope(), VarName),
	match_type(Line, AttrVarType, ExprVarType).

match_type(_, int, int) -> ok;
match_type(_, float, int) -> ok;
match_type(Line, int, _) ->
	handle_error(Line, "Incompatible type being assigned");
match_type(Line, float, _) ->
	handle_error(Line, "Incompatible type being assigned").
