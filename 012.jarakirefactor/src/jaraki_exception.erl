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

handle_error(Line, Code) ->
	st:put_error(Line, Code),
	error.

get_error_text(1) -> "Variable not declared";
get_error_text(2) -> "Variable already declared";
get_error_text(3) -> "Incompatible variable assignment type";
get_error_text(4) -> "The unique argument of the \"main method\""
					"is not String[]".

print_errors([]) ->
	io:format("\n");
print_errors([ {Line, Code} | Rest ]) ->
	io:format("Line: #~p - ~s\n", [Line, get_error_text(Code)]),
	print_errors(Rest).

%%-----------------------------------------------------------------------------
%% Casa expressoes matematicas a procura de variaveis para substituir seus nomes

%% TODO: verificar tipo do retorno da função!!
%%
check_var_type(_Type, {function_call, {_Line, _FunctionName}, _ArgsTuple}) ->
	%% create_function_call(Line, FunctionName, ArgumentsList);
	ok;
check_var_type(_Type, {sqrt, _Line, _RightExp}) ->
	%% match_type(Type, double);
	ok;
check_var_type(_Type, {next_int, _Line, _VarScanner}) ->
	%% match_type(Type, int);
	ok;
check_var_type(_Type, {next_float, _Line, _VarScanner}) ->
	%% match_type(Type, float);
	ok;
check_var_type(_Type, {next_line, _Line, _VarScanner}) ->
	%% match_type(Type, String);
	ok;
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
	match_type(Line, AttrVarType, ExprVarType);

check_var_type(AttrArrayType, {{var, Line, ArrayName}, {index, _ArrayIndex}}) ->
	{{array, ExprVarType}, _Value} = st:get2(Line, st:get_scope(), ArrayName),
	match_type(Line, AttrArrayType, ExprVarType).


match_type(_, int, integer) -> ok;
match_type(_, long, integer) -> ok;
match_type(_, double, integer) -> ok;
match_type(_, float, int) -> ok;
match_type(_, float, integer) -> ok;
match_type(_, Type, Type) -> ok;
match_type(Line, _, _) ->
	handle_error(Line, 3).
