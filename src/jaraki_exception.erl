%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%%			Eden Freitas Ramos ( edenstark@gmail.com )
%%			Helder Cunha Batista ( hcb007@gmail.com )
%%			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%%			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%%			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Tratar as ocorrências de exceções

-module(jaraki_exception).
-compile(export_all).

handle_error(Line, Code) ->
	st:put_error(Line, Code),
	error.

get_error_text(1)  -> "Variable not declared";
get_error_text(2)  -> "Variable already declared";
get_error_text(3)  -> "Incompatible variable assignment type";
get_error_text(4)  -> "The unique argument of the \"main method\""
						 "is not String[]";
get_error_text(5)  -> "The main method modifiers should be \"public static\"";
get_error_text(6)  -> "Cannot call a non-static method from a static context";
get_error_text(7)  -> "Calling method of non-existing class";
get_error_text(8)  -> "Calling static method on a nonstatic way";
get_error_text(9)  -> "Calling a non-existing method or incompatible method "
						"parameters";
get_error_text(10) -> "Non-static variable a cannot be referenced "
						"from a static context";
get_error_text(11) -> "Field not declared";
get_error_text(12) -> "Non-static variable \"this\" cannot be referenced from "
						"a static context";
get_error_text(13) -> "Unexpected type on method call!";

%-------------------------------------------------------------------------------
%% Erros de Pacotes TODO: Traduzir os textos para o ingles
get_error_text(14) -> "Diretorio inexistente";
get_error_text(15) -> "O aquivo nao consta no diretorio";
get_error_text(16) -> "Diretorio sem permissao de acesso";

get_error_text(17) -> "The operator cannot be applied to String".

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
check_var_type(_Type, {function_call, _ClassTuple, _MethodTuple, _ArgsTuple}) ->
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
check_var_type(_Type, {read, _Line, _VarFileReader}) ->
	%% match_type(Type, int);
	ok;
check_var_type(_Type, {next_int, _Line, _VarName, _RandomValue}) ->
	%% match_type(Type, int);
	ok;

%% TODO: verificar retorno do new, polimorfismo, etc...
%% construtor PADRÃO
check_var_type(_Type, {new, object, {class, _Line, _Type2}}) ->
	ok;
%% construtor NOVO
check_var_type(_Type, {new, object, {class, _, _Type2, _ArgumemtsJast}}) ->
	ok;

check_var_type(Type, {field_access, {Line, ObjectVarName, FieldName}}) ->
	Scope = st:get_scope(),

	case ObjectVarName of
		this   -> {ClassName, _} = Scope;
		_Other -> {ClassName, _VarValue} = st:get2(Line, Scope, ObjectVarName)
	end,

	case st:exist_field(ClassName, FieldName) of
		true ->
			{FieldType, _Modifiers} = st:get_field_info(ClassName, FieldName),
			match_type(Line, Type, FieldType);

		false ->
			handle_error(Line, 11),
			error
	end;

check_var_type(Type, {op, Line, Op, RightExp}) ->
	{op, Line, Op, check_var_type(Type, RightExp)};

check_var_type(Type, {integer, Line, _Value})-> match_type(Line, Type, integer);
check_var_type(Type, {float, Line, _Value})  -> match_type(Line, Type, float);
check_var_type(Type, {atom, Line, true})     -> match_type(Line, Type, boolean);
check_var_type(Type, {random, Line, _Value}) -> match_type(Line, Type, random);
check_var_type(Type, {scanner, Line, _Value})-> match_type(Line, Type, scanner);
check_var_type(Type, {file_reader, Line, _Value})-> match_type(Line, Type, file_reader);
check_var_type(Type, {atom, Line, false})    -> match_type(Line, Type, boolean);
check_var_type(Type, {text, Line, _String})  -> match_type(Line, Type, text);
check_var_type(Type, {singles_quotes, Line, _Char}) -> 
	match_type(Line, Type, singles_quotes);
check_var_type(Type, {length, Line, _VarLength}) ->
	match_type(Line, Type, integer);

check_var_type(Type, {op, Line, Op, LeftExp, RightExp}) ->
	{op, Line, Op,
		check_var_type(Type, LeftExp),
		check_var_type(Type, RightExp)};

%% checa o tipo de variáveis, sendo que se ela não tiver sido declarada o erro
%% é gerado em uma análise já realizada no gen_erl_code
check_var_type(AttrVarType, {var, Line, VarName}) ->
	Scope = st:get_scope(),
	VarContext = helpers:get_variable_context(Scope, VarName),

	case VarContext of
		{error, _}  -> error;

		{ok, local} ->
			{ExprVarType, _} = st:get2(Line, st:get_scope(), VarName),
			match_type(Line, AttrVarType, ExprVarType);

		{ok, object} ->
			{ScopeClass, _} = Scope,
			{ExprVarType, _} = st:get_field_info(ScopeClass, VarName),
			match_type(Line, AttrVarType, ExprVarType)
	end;

check_var_type(AttrArrayType, {{var, Line, ArrayName}, {index, _ArrayIndex}}) ->
	{{array, ExprVarType}, _Value} = st:get2(Line, st:get_scope(), ArrayName),
	match_type(Line, AttrArrayType, ExprVarType);

check_var_type(AttrArrayType, {{var, Line, ArrayName},
				{index, {row, _}, {column, _}}}) ->
	{{matrix, ExprVarType}, _Value} = st:get2(Line, st:get_scope(), ArrayName),
	match_type(Line, AttrArrayType, ExprVarType).

match_type(_, 'String', text)    -> ok;
match_type(_, int,      integer) -> ok;
match_type(_, long,     integer) -> ok;
match_type(_, double,   integer) -> ok;
match_type(_, float,    int)     -> ok;
match_type(_, float,    integer) -> ok;
match_type(_, random,    _)      -> ok;
match_type(_, scanner,   _)      -> ok;
match_type(_, file_reader,   _)      -> ok;
match_type(_, char, singles_quotes) -> ok;
match_type(_, Type,     Type)    -> ok;

match_type(Line, _, _) ->
	handle_error(Line, 3).
