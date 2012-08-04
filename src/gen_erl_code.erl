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
		'fun'/2, string/2, tuple/2, atom/2, string/2, list/2
	]).
-include("../include/jaraki_define.hrl").

%%-----------------------------------------------------------------------------
%% transformacoes de expressoes em java para erlang
%% apenas uma unica expressao
match_statement({var_declaration, VarType, VarList}) ->
	create_declaration(var_declaration, VarType, VarList);

%% Instanciação do Scanner e Random é ignorado no parser
match_statement(no_operation) ->
	no_operation;

%% Casa expressões do tipo identifier.write()
match_statement({write, Line, VarName, WriteText}) ->
	create_function_object_class(write, Line, VarName, WriteText);

%% Casa expressões do tipo identifier.close()
match_statement({close, Line, CloseFile}) ->
	create_function_object_class(close, Line, CloseFile);

%% transforma expressoes do tipo System.out.print em Erlang
match_statement({Line, print, Content}) ->
	create_print_function(Line, print, Content);

%% transforma expressoes System.out.println em Erlang
match_statement({Line, println, Content}) ->
	 create_print_function(Line, println, Content);

%% transforma chamadas de funcoes em Erlang funcao()
match_statement({function_call, {Line, FunctionName},
					{argument_list, ArgumentsList}}) ->
	create_function_call(Line, FunctionName, ArgumentsList);

%% chamada a métodos estáticos ou não owner.funcao()
match_statement({function_call,
					{owner, Line, OwnerName},
					{method, Line, FunctionName},
					{argument_list, ArgumentsList}}) ->
	create_function_call(Line, OwnerName, FunctionName, ArgumentsList);

%% Casa expressoes do tipo varivel = valor
match_statement(
	{
		Line,
		attribution,
		{var, VarName},
		{var_value, VarValue}}
	) ->
	case VarValue of
			{new, array, {type, ArrayType}, {index,
						{row, RowLength}, {column, ColumnLength} }} ->
			create_array(Line, VarName, ArrayType,
								RowLength, ColumnLength);
			{new, array, {type, ArrayType}, {index, ArrayLength}} ->
					create_array(Line, VarName, ArrayType, ArrayLength);
			_ -> create_attribution(Line, VarName, VarValue)
	end;

%% Casa expressoes do tipo array = valor
match_statement(
	{	Line,
		array_attribution,
		{{var, ArrayName},
		{index, ArrayIndex}},
		{var_value, ArrayValue}
	}) ->
	create_attribution(Line, ArrayName, ArrayIndex, ArrayValue);

%%casa expressoes do tipo matriz = valor
match_statement(
	{	Line,
		array_attribution,
		{{var, MatrixName},
		{index,
			{row, RowIndex},
			{column, ColumnIndex}}},
		{var_value, Value}
	}) ->
	create_attribution(Line, MatrixName, RowIndex, ColumnIndex, Value);

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
		rcall(Line, st, get_old_stack, [gen_ast:scope(Line, st:get_scope())]),
		var(Line,'Return')]
	}.

%%-----------------------------------------------------------------------------
%% casa expressoes/lista de expressoes dentro do IF,FOR,WHILE
match_inner_stmt({block, Line, StatementList}) ->
	match_inner_stmt(Line, StatementList, [], []);

match_inner_stmt(Statement) ->
	[match_statement(Statement)].

match_inner_stmt(Line, [], DeclaredVars, AstStatementList) ->
	Scope = st:get_scope(),
	RemoveDeclaredVarsAst = create_undeclare_vars(Line, DeclaredVars, Scope),
	lists:reverse(AstStatementList, RemoveDeclaredVarsAst);

match_inner_stmt(Line,[{var_declaration, _,_}=Stmt| Rest], Vars, AstStmtList) ->
	{_, {var_type, {VarLine, VarType}}, {var_list, VarList}} = Stmt,

	Scope = st:get_scope(),
	st:insert_var_list(VarLine, Scope, VarList, VarType),
	VarDeclarationAst = match_statement(Stmt),

	NewVars = VarList ++ Vars,
	match_inner_stmt(Line, Rest, NewVars, [VarDeclarationAst | AstStmtList]);

match_inner_stmt(Line, [Statement | Rest], DeclaredVars, AstStmtList) ->
	StatementAst = match_statement(Statement),
	match_inner_stmt(Line, Rest, DeclaredVars, [StatementAst | AstStmtList]).

%%-----------------------------------------------------------------------------
%% Casa expressoes matematicas a procura de variaveis para substituir seus nomes

match_attr_expr({op, Line, Op, RightExp}) ->
	{op, Line, Op, match_attr_expr(RightExp)};
match_attr_expr({function_call, {Line, FunctionName},
			{argument_list, ArgumentsList}}) ->
	create_function_call(Line, FunctionName, ArgumentsList);

%% criação de objetos
%% construtor padrão
match_attr_expr({new, object, {class, _Line, ClassName}}) ->
	ClassName2 = list_to_atom(string:to_lower(atom_to_list(ClassName))),
	rcall(0, ClassName2, '__constructor__', []);

%% construtor definido pelo usuário
match_attr_expr({new, object, {class, Line, ClassName, ArgumentsJast}}) ->
	{arguments, ArgumentsList} = ArgumentsJast,
	ClassName2 = list_to_atom(string:to_lower(atom_to_list(ClassName))),

	case helpers:get_arg_type_list(ArgumentsList) of
		{error, ErrorNumber} ->
			jaraki_exception:handle_error(Line, ErrorNumber),
			no_operation;

		ArgTypeList ->
			case st:exist_constructor(ClassName2, ArgTypeList) of
				false ->
					jaraki_exception:handle_error(Line, 9),
					no_operation;

				true ->
					ArgAstList_temp1 = [match_attr_expr(V) || V<-ArgumentsList],
					ArgumentAstList = gen_ast:function_call_args(
									  Line, ArgAstList_temp1, ArgTypeList),

					_Modificador = st:get_constr_info(ClassName, ArgTypeList),

					FunctionName = '__constructor__',
					rcall(Line, ClassName2, FunctionName, ArgumentAstList)
			end
	end;

%% chamada a métodos estáticos
match_attr_expr({function_call,
					{class, Line, ClassName},
					{method, Line, FunctionName},
					{argument_list, ArgumentsList}}) ->
	create_function_call(Line, ClassName, FunctionName, ArgumentsList);

match_attr_expr({sqrt, Line, RightExp}) ->
	rcall(Line, math, sqrt, [match_attr_expr(RightExp)]);
match_attr_expr({next_int, Line, VarName})->
	create_function_object_class(next_int, Line, VarName);
match_attr_expr({next_float, Line, VarName})->
	create_function_object_class(next_float, Line, VarName);
match_attr_expr({next_line, Line, VarName})->
	create_function_object_class(next_line, Line, VarName);
match_attr_expr({next_int, Line, VarName, Value})->
	create_function_object_class(next_int, Line, VarName, Value);

%%Cria ast para atribuições com FileReader
match_attr_expr({read, Line, VarName})->
	create_function_object_class(read, Line, VarName);

match_attr_expr({length, Line, VarLength})->
	ScopeAst = gen_ast:scope(Line, st:get_scope()),
	ArrayGetAst = rcall(Line, st, get_value,[ScopeAst,
			string(Line, VarLength)]),
	rcall(Line, vector, size_vector, [ArrayGetAst]);

match_attr_expr({field_access, FieldInfo}) ->
	{Line, ObjectVarName, FieldName} = FieldInfo,
	Scope = st:get_scope(),
	case ObjectVarName of
		this ->
			gen_ast:field_access_var(Line, FieldName);

		_ ->
			gen_ast:field_refVar(Line, Scope, ObjectVarName, FieldName)
	end;

match_attr_expr({integer, _Line, _Value} = Element) ->
	Element;
match_attr_expr({float, _Line, _Value} = Element) ->
	Element;
match_attr_expr({atom, _Line, true} = Element) ->
	Element;
match_attr_expr({atom, _Line, false} = Element) ->
	Element;
match_attr_expr({text, Line, String}) ->
	{string, Line, String};
match_attr_expr({singles_quotes, Line, Char}) ->
	{char, Line, Char};
match_attr_expr({op, Line, Op, LeftExp, RightExp}) ->
	{op, Line, Op, match_attr_expr(LeftExp), match_attr_expr(RightExp)};

match_attr_expr({var, Line, VarName}) ->
	Scope = st:get_scope(),
	ScopeAst = gen_ast:scope(Line, st:get_scope()),

	VarContext = helpers:get_variable_context(Scope, VarName),

	case VarContext of
		{error, ErrorNumber} ->
			jaraki_exception:handle_error(Line, ErrorNumber),
			no_operation;

		{ok, local} ->
			GetParamAst = [ScopeAst, string(Line, VarName)],
			rcall(Line, st, get_value, GetParamAst);

		{ok, object} ->
			gen_ast:field_access_var(Line, VarName)
	end;

match_attr_expr({{var, Line, VarName}, {index, ArrayIndex}}) ->
	st:get2(Line, st:get_scope(), VarName),
	IndexAst = match_attr_expr(ArrayIndex),
	ScopeAst = gen_ast:scope(Line, st:get_scope()),

	ArrayGetAst = rcall(Line, st, get_value,[ScopeAst,
				string(Line, VarName)]),
	rcall(Line, vector, access_vector, [IndexAst, ArrayGetAst]);
match_attr_expr({{var, Line, VarName},
					{index, {row, RowIndex}, {column, ColumnIndex}}}) ->
	st:get2(Line, st:get_scope(), VarName),
	ScopeAst = gen_ast:scope(Line, st:get_scope()),

	RowAst = match_attr_expr(RowIndex),
	ColumnAst = match_attr_expr(ColumnIndex),
	MatrixGetAst = rcall(Line, st, get_value,[ScopeAst,
				string(Line, VarName)]),
	rcall(Line, matrix, access_matrix, [RowAst, ColumnAst, MatrixGetAst]).

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
			ArrayAst = create_array_initializer(VarLine,
							 VarName, ArrayElementsList),
				create_declaration_list(VarLine, Rest, [ArrayAst| VarAstList]);

		{new, array, {type, ArrayType}, {index,
						{row, RowLength}, {column, ColumnLength} }} ->
			ArrayAst = create_array(VarLine, VarName, ArrayType,
												RowLength, ColumnLength),
				create_declaration_list(VarLine, Rest, [ArrayAst| VarAstList]);


		{new, array, {type, ArrayType}, {index, ArrayLength}} ->
			ArrayAst = create_array(VarLine, VarName, ArrayType, ArrayLength),
				create_declaration_list(VarLine, Rest, [ArrayAst| VarAstList]);

		{new, object, {type, ClassType}} ->
			case ClassType of
				% ignora caso seja Scanner ou Random
				{_Line, 'Scanner'} ->
					create_declaration_list(VarLine, Rest, VarAstList);
				{_Line, 'Random'} ->
					create_declaration_list(VarLine, Rest, VarAstList);
				_ObjectType ->
					% NewObjAst = create_object(VarLine,....
					ok
			end;

		{new, object, {type, _ClassType}, {file_reader, File}} ->
				FileAst = create_attribution(new_read, VarName, VarLine, File),
				create_declaration_list(VarLine, Rest, [FileAst | VarAstList]);

		{new, object, {type, _ClassType}, {file_writer, File}} ->
				FileAst = create_attribution(new_write, VarName, VarLine, File),
				create_declaration_list(VarLine, Rest, [FileAst | VarAstList]);

		_ ->
			VarAst = create_attribution(VarLine, VarName, VarValue),
			create_declaration_list(VarLine, Rest, [VarAst| VarAstList])
	end.




%-------------------------------------------------------------------------------
% Cria elemento da east para Scanner, Random e FileReader
create_function_object_class(next_int, Line, VarName) ->
	{Type, _VarValue} = st:get2(Line, st:get_scope(), VarName),

	case Type of
	   'Scanner' ->
		  Prompt = string(Line, '>'),
		  ConsoleContent = string(Line, '~d'),
		  rcall(Line, io, fread, [Prompt, ConsoleContent]);
	  'Random' ->
		  call(Line, function_random, [])
	end;

create_function_object_class(next_float, Line, VarName) ->
	{Type, _VarValue} = st:get2(Line, st:get_scope(), VarName),

	case Type of
	   'Scanner' ->
		Prompt = string(Line, '>'),
		ConsoleContent = string(Line, '~f'),
		rcall(Line, io, fread, [Prompt, ConsoleContent]);
	  'Random' ->
		  call(Line, function_random, [])
	end;

create_function_object_class(next_line, Line, VarName) ->
	{Type, _VarValue} = st:get2(Line, st:get_scope(), VarName),

	case Type of
	   'Scanner' ->
		Prompt = string(Line, '>'),
		ConsoleContent = string(Line, '~f'),
		rcall(Line, io, fread, [Prompt, ConsoleContent]);
		'Random' ->
		no_operation
	end;

create_function_object_class(read, Line, VarName) ->
	{Type, _VarValue} = st:get2(Line, st:get_scope(), VarName),
	ScopeAst = gen_ast:scope(Line, st:get_scope()),

	case Type of
	   'Scanner' ->
			no_operation;
		'Random' ->
			no_operation;
		'FileReader' ->
			Read = atom(Line, read),
			Value = {integer, Line, 1},
			Var = rcall(Line, st, get_value, [ScopeAst,
						string(Line, VarName)]),

			call(Line, function_file, [Read, Var, Value])
	end;

create_function_object_class(close, Line, CloseFile) ->
	ScopeAst = gen_ast:scope(Line, st:get_scope()),

		CloseFile2 = rcall(Line, st, get_value, [ScopeAst,
					string(Line, CloseFile)]),


		call(Line, function_file, [CloseFile2]).


create_function_object_class(write, Line, VarName, WriteText) ->
%	{Type, _VarValue} = st:get2(Line, st:get_scope(), VarName),
	ScopeAst = gen_ast:scope(Line, st:get_scope()),

		{write_text, WriteText2} = WriteText,
		Write = atom(Line, write),
		VarNew = rcall(Line, st, get_value, [ScopeAst,
					string(Line, VarName)]),

		VarWrite = rcall(Line, st, get_value, [ScopeAst,
					string(Line, WriteText2)]),

		call(Line, function_file, [Write, VarNew, VarWrite]);


create_function_object_class(next_int, Line, VarName, RandomValue) ->
	{Type, _VarValue} = st:get2(Line, st:get_scope(), VarName),

	case Type of
	   'Scanner' ->
			no_operation;
		'Random' ->
			ObjectType = atom(Line, next_int),
			call(Line, function_random, [ObjectType, RandomValue])
	end.

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
	case get_print_format(Line, Head) of
		no_operation ->
			no_operation;
		PrintFormat ->
			print_text(L, Line, Text ++ PrintFormat, _print)
	end.

get_print_format(Line, {identifier, _, PrintElement}) ->
	Scope = st:get_scope(),
	VarContext = helpers:get_variable_context(Scope, PrintElement),

	case VarContext of
		{error, ErrorNum} -> jaraki_exception:handle_error(Line, ErrorNum);

		{ok, local} ->
			{TypeId, _VarValue} = st:get2(Line, st:get_scope(), PrintElement),
			match_format_type(TypeId);

		{ok, object} ->
			{ScopeClass, _} = Scope,
			{TypeId, _Modifiers} = st:get_field_info(ScopeClass, PrintElement),
			match_format_type(TypeId)
	end;

get_print_format(Line, {{var, _, PrintElement}, _ArrayIndex}) ->
	case st:get2(Line, st:get_scope(), PrintElement) of
		{{array, TypeId}, _VarValue} ->
			match_format_type(TypeId);

		{{matrix, TypeId}, _VarValue} ->
			match_format_type(TypeId);

		_ -> no_operation
	end;

get_print_format(Line, {field_access, ObjectVarName, FieldName}) ->
	case st:get2(Line, st:get_scope(), ObjectVarName) of
		{ClassName, _VarValue} ->
			{TypeId, _Modifiers} = st:get_field_info(ClassName, FieldName),
			match_format_type(TypeId);

		_ -> no_operation
	end;

get_print_format(_, {text, _, _}) -> "~s".

match_format_type(int)		-> "~p";
match_format_type(long)		-> "~p";
match_format_type(float)	-> "~f";
match_format_type(double)	-> "~f";
match_format_type(char)		-> "~c";
match_format_type(_)		-> "~s".

print_list([], Line) ->
	{nil, Line};
print_list([Element|L], Line) ->
	Scope = st:get_scope(),
	ScopeAst = gen_ast:scope(Line, st:get_scope()),

	case Element of
		{field_access, ObjectVarName, FieldName} ->
			FieldAst=gen_ast:field_refVar(Line,Scope,ObjectVarName, FieldName),
			{cons, Line, FieldAst, print_list(L, Line)};

		{{var, _, PrintElement}, {index, ArrayIndex} } ->
			IndexGetAst = match_attr_expr(ArrayIndex),

			ValueGetAst = rcall(Line, st, get_value,[ScopeAst,
				string(Line, PrintElement)]),
			VectorAst = rcall(Line, vector,access_vector,
							[IndexGetAst, ValueGetAst]),
			{cons, Line, VectorAst, print_list(L, Line)};

		{{var,_, PrintElement},
					{index, {row, RowIndex}, {column, ColumnIndex}}} ->
			RowAst = match_attr_expr(RowIndex),
			ColumnAst = match_attr_expr(ColumnIndex),
			ValueGetAst = rcall(Line, st, get_value,[ScopeAst,
				string(Line, PrintElement)]),
			MatrixAst = rcall(Line, matrix, access_matrix,
							[RowAst, ColumnAst, ValueGetAst]),
			{cons, Line, MatrixAst, print_list(L, Line)};

		 {identifier, _, PrintElement} ->
			VarContext = helpers:get_variable_context(Scope, PrintElement),

			case VarContext of
				{error, ErrorNum} ->
					jaraki_exception:handle_error(Line, ErrorNum);

				{ok, local} ->
					GetParamAst=[ScopeAst, string(Line, PrintElement)],
					VariableAst = rcall(Line, st, get_value, GetParamAst),
					{cons, Line, VariableAst, print_list(L, Line)};

				{ok, object} ->
					VariableAst = gen_ast:field_access_var(Line, PrintElement),
					{cons, Line, VariableAst, print_list(L, Line)}
			end;

		 {text, _, PrintElement} ->
			{cons, Line, string(Line, PrintElement), print_list(L, Line)}
	end.
%%---------------------------------------------------------------------------%%
%% TODO: checar se método existe na classe atual (this, primeiro caso) ou
%%       se existe na classe referida pelo Class.Method()
%%       deve compilar a classe dependente antes
%%       se houver dependência A <-> B, checar código todo antes de compilar!

create_function_call(Line, FunctionName, ArgumentsList) ->
	{ScopeClass, _ScopeMethod} = st:get_scope(),

	ArgumentAstList_temp1 = [match_attr_expr(V) || V <- ArgumentsList],

	case helpers:get_arg_type_list(ArgumentsList) of
		{error, ErrorNumber} ->
			jaraki_exception:handle_error(Line, ErrorNumber),
			no_operation;

		ArgTypeList ->
			MethodKey = {FunctionName, ArgTypeList},
			case st:exist_method(ScopeClass, MethodKey) of
				false ->
					jaraki_exception:handle_error(Line, 9),
					no_operation;

				true ->
					ArgumentAstList = gen_ast:function_call_args(
									  Line, ArgumentAstList_temp1, ArgTypeList),
					{ClassName, _Method} = st:get_scope(),
			%%io:format("~p\n~p\n~p\n\n", [get(), FunctionName, ArgTypeList]),
					{TypeReturn, _Modificadores} =
						st:get_method_info(
							ClassName, {FunctionName, ArgTypeList}),

					FunctionCall = call(Line, FunctionName, ArgumentAstList),
					Fun = 'fun'(Line, [clause(Line,[],[], [FunctionCall])]),
			%io:format("~p~n~n",[TypeReturn]),
					case TypeReturn of
						void -> FunctionCall;
						{array, void} -> FunctionCall;
						{matrix, void} -> FunctionCall;
						_OtherType -> rcall(Line, st, return_function,
										[Fun, atom(Line, FunctionName),
										list(Line, ArgumentAstList)])
					end
			end
	end.

%% Chamada do tipo Owner.Metodo()
%% TODO tratar Parameters, lista de parametros
create_function_call(Line, Owner, FunctionName, ArgumentsList) ->
	case st:is_declared_var(st:get_scope(), Owner) of
		true ->
			create_object_method_call(Line, Owner, FunctionName, ArgumentsList);
		false ->
			create_static_method_call(Line, Owner, FunctionName, ArgumentsList)
	end.

create_object_method_call(Line, ObjVarName, FunctionName, ArgumentList) ->
	Scope = st:get_scope(),

	{ClassName, _VarValue} = st:get2(Line, Scope, ObjVarName),

	ArgTypeList = helpers:get_arg_type_list(ArgumentList),
	MethodKey = {FunctionName, ArgTypeList},

	Check =
		case st:exist_method(ClassName, MethodKey) of
			true ->
				case st:is_static_method(ClassName, MethodKey) of
					true -> jaraki_exception:handle_error(Line, 8);
					false -> ok
				end;
			false -> jaraki_exception:handle_error(Line, 9)
		end,

	case Check of
		error -> no_operation;
		ok ->
			ObjectIDAst = gen_ast:objectID(Line, st:get_scope(), ObjVarName),

			ObjectClassAst = rcall(Line, oo_lib, get_class, [ObjectIDAst]),

			ArgTypeList = helpers:get_arg_type_list(ArgumentList),
			ArgumentAstList1 = [match_attr_expr(V) || V <- ArgumentList],
			ArgumentAstList2 =
				gen_ast:function_call_args(Line, ArgumentAstList1, ArgTypeList),
			ArgumentAstList = [ObjectIDAst] ++ ArgumentAstList2,

			ArgumentListAst = list(Line, ArgumentAstList),

			FunctionNameAst = atom(Line, FunctionName),

			ApplyArguments = [ObjectClassAst, FunctionNameAst, ArgumentListAst],
			rcall(Line, erlang, apply, ApplyArguments)
	end.

create_static_method_call(Line, ClassName, FunctionName, ArgumentsList) ->
	Scope = st:get_scope(),

	ArgTypeList = helpers:get_arg_type_list(Scope, ArgumentsList),
	MethodKey = {FunctionName, ArgTypeList},

	Check =
		case st:exist_class(ClassName) of
			true ->
				case st:exist_method(ClassName, MethodKey) of
					true ->
						case st:is_static_method(ClassName, MethodKey) of
							true  -> ok;
							false -> jaraki_exception:handle_error(Line, 6)
						end;

					false ->
						jaraki_exception:handle_error(Line, 9)
				end;

			false ->
				jaraki_exception:handle_error(Line, 7)
		 end,

	case Check of
		error -> no_operation;
		ok ->
			ClassName2 = list_to_atom(string:to_lower(atom_to_list(ClassName))),

			ArgTypeList = helpers:get_arg_type_list(ArgumentsList),
			ArgumentAstList1 = [match_attr_expr(V) || V <- ArgumentsList],
			ArgumentAstList =
				gen_ast:function_call_args(Line, ArgumentAstList1, ArgTypeList),

			FunctionCall= rcall(Line, ClassName2,FunctionName, ArgumentAstList),
			Fun = 'fun'(Line, [clause(Line, [], [], [FunctionCall])]),
			rcall(Line, st, return_function,
				[Fun, atom(Line, FunctionName), list(Line, ArgumentAstList)])
	end.

%%-----------------------------------------------------------------------------
%% Cria o elemento da east para atribuiçao de campos de um objeto
%% TODO: detecção de erro como:
%%			variável não declarada (que contém o objectID)
%%			não existente (campos não declarados na classe)
create_attribution(Line, {field_attribution, FieldInfoJast}, VarValue) ->
	{ObjectVarName, FieldName} = FieldInfoJast,
	Scope = st:get_scope(),

	ObjectIDAst = gen_ast:objectID(Line, Scope, ObjectVarName),

	case ObjectVarName of
		this ->
			{ClassName2, _} = Scope;
		_ ->
			{ClassName, _VarValue} = st:get2(Line, Scope, ObjectVarName),
			ClassName2 = list_to_atom(string:to_lower(atom_to_list(ClassName)))
	end,

	{FieldType, _Modifiers} = st:get_field_info(ClassName2, FieldName),
	FieldTypeAst = gen_ast:type_to_ast(Line, FieldType),

	jaraki_exception:check_var_type(FieldType, VarValue),

	VarValueAst  = match_attr_expr(VarValue),
	FieldNameAst = atom(Line, FieldName),
	FieldTypeAst = atom(Line, FieldType),
	FieldAst     = tuple(Line, [FieldNameAst, FieldTypeAst, VarValueAst]),

	rcall(Line, oo_lib, update_attribute, [ObjectIDAst, FieldAst]);

%%-----------------------------------------------------------------------------
%% Cria o elemento da east para atribuiçao de variaveis do java
create_attribution(Line, VarName, VarValue) ->
	Scope = st:get_scope(),

	VarContext = helpers:get_variable_context(Scope, VarName),

	case VarContext of
		{error, ErrorNumber} ->
			jaraki_exception:handle_error(Line, ErrorNumber),
			no_operation;

		{ok, VarContext2} ->
			Type =
				case VarContext2 of
					local  -> element(1, st:get2(Line, Scope, VarName));
					object ->
						{ClassName, _} = Scope,
						element(1, st:get_field_info(ClassName, VarName))
				end,

			TypeAst = gen_ast:type_to_ast(Line, Type),
			jaraki_exception:check_var_type(Type, VarValue),
			VarValueAst = match_attr_expr(VarValue),
			CheckInt = gen_ast:check_int(Type),
			NewVarValueAst =
				case CheckInt of
					other_type -> VarValueAst;
					_ -> call(Line, trunc, [VarValueAst])
				end,

			case VarContext2 of
				local ->
					JavaNameAst = string(Line, VarName),
					ScopeAst = gen_ast:scope(Line, st:get_scope()),
					rcall(Line, st, put_value, [
						tuple(Line, [ScopeAst, JavaNameAst]),
						tuple(Line, [TypeAst, NewVarValueAst])]);

				object ->
					gen_ast:update_field_1(Line, VarName,TypeAst,NewVarValueAst)
			end
	end.

%% Cria elemento east para instanciacao do FileReader
create_attribution(new_read, VarName, VarLine, File) ->
	New = atom(VarLine, new),
	Read = atom(VarLine, read),
	FileRead = string(VarLine, File),
	FunctionFile = call(VarLine, function_file, [New, FileRead, Read]),

	{Type, _VarValue} = st:get2(VarLine, st:get_scope(), VarName),
	ScopeAst = gen_ast:scope(VarLine, st:get_scope()),

	JavaNameAst = string(VarLine, VarName),
	TypeAst = gen_ast:type_to_ast(VarLine, Type),

	rcall(VarLine, st, put_value, [tuple(VarLine, [ScopeAst, JavaNameAst]),
		tuple(VarLine, [TypeAst, FunctionFile])]);

%% Cria elemento east para instanciacao do FileWriter
create_attribution(new_write, VarName, VarLine, File) ->

	FileWrite = string(VarLine, File),

	{Type, _VarValue} = st:get2(VarLine, st:get_scope(), VarName),
	ScopeAst = gen_ast:scope(VarLine, st:get_scope()),

	JavaNameAst = string(VarLine, VarName),
	TypeAst = gen_ast:type_to_ast(VarLine, Type),

	rcall(VarLine, st, put_value, [tuple(VarLine, [ScopeAst, JavaNameAst]),
		tuple(VarLine, [TypeAst, FileWrite])]);


%%------------------------------------------------------------------------------
%% Cria elemento da east para atribuicao de array
create_attribution(Line, ArrayName, ArrayIndex, VarValue) ->
	case st:get2(Line, st:get_scope(), ArrayName) of
		{{array, PrimitiveType} = Type, _Value} ->
			jaraki_exception:check_var_type(PrimitiveType, VarValue),
			TransformedVarValue = match_attr_expr(VarValue),
			JavaNameAst = string(Line, ArrayName),
			TypeAst = gen_ast:type_to_ast(Line, Type),
			ScopeAst = gen_ast:scope(Line, st:get_scope()),
			IndexAst = match_attr_expr(ArrayIndex),
			ArrayGetAst = rcall(Line, st, get_value, [ScopeAst, JavaNameAst]),
			VectorAst = rcall(Line, vector, set_vector, [IndexAst,
					TransformedVarValue, ArrayGetAst]),
			rcall(Line, st, put_value, [
				tuple(Line, [ScopeAst, JavaNameAst]),
				tuple(Line, [TypeAst, VectorAst])]);
		_ -> no_operation
	end.

%% Cria elemento east para atribuicao de matrix
%% TODO: Verificar Tipo - Mudar para matrix
create_attribution(Line, MatrixName, RowIndex, ColumnIndex, VarValue) ->
		case st:get2(Line, st:get_scope(), MatrixName) of
		{{matrix, PrimitiveType} = Type, _Value} ->
			jaraki_exception:check_var_type(PrimitiveType, VarValue),
			TransformedVarValue = match_attr_expr(VarValue),
			JavaNameAst = string(Line, MatrixName),
			TypeAst = gen_ast:type_to_ast(Line, Type),
			ScopeAst = gen_ast:scope(Line, st:get_scope()),
			RowAst = match_attr_expr(RowIndex),
			ColumnAst = match_attr_expr(ColumnIndex),
			ArrayGetAst = rcall(Line, st, get_value, [ScopeAst, JavaNameAst]),
			MatrixAst = rcall(Line, matrix, set_matrix, [RowAst, ColumnAst,
					TransformedVarValue, ArrayGetAst]),
			rcall(Line, st, put_value, [
				tuple(Line, [ScopeAst, JavaNameAst]),
				tuple(Line, [TypeAst, MatrixAst])]);
		_ -> no_operation
	end.

%% Transforma os elementos do array - vet = {valor1, valor2}
create_array_values(Line, [{array_element, Value} | []]) ->
	{cons, Line, {integer, Line, Value}, {nil, Line}};

create_array_values(Line,
						[{array_element, Value} | Rest]) ->
	Lists =  {cons, Line, {integer, Line, Value},
				create_array_values(Line, Rest)},
	Lists.

create_array_from_list(Line, ArrayValues) ->
	ElementsArrayAst = create_array_values(Line, ArrayValues),
	rcall(Line, array, from_list, [ElementsArrayAst]).

%% Transforma os elementos da matrix -ex.:  mat = {{1, 2}, {1, 1}}

create_matrix_values(Line, [{matrix_element, Value} | [] ]) ->
	{cons, Line,  create_array_from_list(Line, Value),
					{nil, Line}};
create_matrix_values(Line, [{matrix_element, Value} | Rest ]) ->
	MatrixValue =  {cons, Line, create_array_from_list(Line, Value),
						create_matrix_values(Line, Rest)},
	MatrixValue.


create_matrix_from_list(Line, ArrayValues) ->
	ElementsArrayAst = create_matrix_values(Line, ArrayValues),
	rcall(Line, array, from_list, [ElementsArrayAst]).


%% ------------------------------------------------------------------
%% Inicializador de array
create_array_initializer(Line, VarName, ArrayValues) ->
	{Type, _Value} = st:get2(Line, st:get_scope(), VarName),
	%jaraki_exception:check_var_type(Type, VarName),
	JavaNameAst = string(Line, VarName),
	TypeAst = gen_ast:type_to_ast(Line, Type),
	ScopeAst = gen_ast:scope(Line, st:get_scope()),

	case ArrayValues of
		[{array_element, _} | _] ->
				ModuleName = vector,
				FunctionName = new,
				ArrayFromListAst = create_array_from_list(Line,  ArrayValues);
		[{matrix_element, _} | _] ->
				ModuleName = matrix,
				FunctionName = new_matrix	,
				ArrayFromListAst =  create_matrix_from_list(Line, ArrayValues)
	end,

	ArrayModuleAst = rcall(Line, ModuleName, FunctionName, [ArrayFromListAst]),
	ArrayAst = rcall(Line, st, put_value, [
	tuple(Line, [ScopeAst, JavaNameAst]),
	tuple(Line, [TypeAst, ArrayModuleAst])]),
	{block, Line, [ArrayAst]}.

%%-----------------------------------------------------------------------------
%% Cria a expressão de criação de array
create_array(Line, VarName, {_L, Type}, ArrayLength) ->
	jaraki_exception:check_var_type(Type, {{var, Line, VarName},
						{index, ArrayLength}}),
	JavaNameAst = string(Line, VarName),
	TypeAst = gen_ast:type_to_ast(Line, Type),
	ScopeAst = gen_ast:scope(Line, st:get_scope()),
	IndexAst = match_attr_expr(ArrayLength),
	%%Usado para a instanciação do array, cria um tamanho fixo

	VectorAst = rcall(Line, vector, new_vector, [IndexAst]),

	rcall(Line, st, put_value, [
		tuple(Line, [ScopeAst, JavaNameAst]),
			tuple(Line, [TypeAst, VectorAst])]).

%%-----------------------------------------------------------------------------
%% Cria a expressão de criação de matriz
create_array(Line, VarName, {_L, Type}, RowLength, ColumnLength) ->
	%jaraki_exception:check_var_type(Type, {var, VarLine, VarName}),
	JavaNameAst = string(Line, VarName),
	TypeAst = gen_ast:type_to_ast(Line, Type),
	ScopeAst = gen_ast:scope(Line, st:get_scope()),
	RowAst = match_attr_expr(RowLength),
	ColumnAst = match_attr_expr(ColumnLength),
	%%Usado para a instanciação do array, cria um tamanho fixo
	MatrixAst = rcall(Line, matrix, creation_matrix, [RowAst, ColumnAst]),

	rcall(Line, st, put_value, [
		tuple(Line, [ScopeAst, JavaNameAst]),
			tuple(Line, [TypeAst, MatrixAst])]).

%%-----------------------------------------------------------------------------
%% Cria a operacao de incremento ++
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
	TypeAst = gen_ast:type_to_ast(Line, VarType),
	Scope = st:get_scope(),
	ScopeAst = gen_ast:scope(Line, Scope),
	InitAst = rcall(Line, st, put_value,[
				tuple(Line, [ScopeAst, JavaNameAst]),
				tuple(Line, [TypeAst, match_attr_expr(Start)])]),

	st:	get_declared(Line, Scope, VarName, VarType, undefined),
	%st:put_value({Scope, VarName}, {VarType, undefined}),

	CondAst	= 'fun'(Line, [clause(Line, [], [], [match_attr_expr(CondExpr)])]),
	IncAst	= 'fun'(Line, [clause(Line, [], [], [match_statement(IncExpr)])]),

	CoreBody = match_inner_stmt(Body),

	BodyAst	= 'fun'(Line, [clause(Line, [], [], CoreBody)]),

	ForAst	= call(Line, for, [CondAst, IncAst, BodyAst]),

	st:delete(Scope, VarName),
	UndeclareIncrementAst = rcall(Line, st, delete, [ScopeAst, JavaNameAst]),

	ForBlock = [InitAst, ForAst, UndeclareIncrementAst],

	{block, Line, lists:flatten(ForBlock)}.

create_while(Line, CondExpr, Body) ->

	CondAst = 'fun'(Line, [clause(Line, [], [], [match_attr_expr(CondExpr)])]),
	CoreBody = match_inner_stmt(Body),
	BodyAst = 'fun'(Line, [clause(Line, [], [], CoreBody)]),
	call(Line, while, [CondAst, BodyAst]).

create_undeclare_vars(Line, VarList, Scope) ->
	create_undeclare_vars(Line, VarList, Scope, []).

create_undeclare_vars(_Line, [], _Scope, UndeclareVarsAst) ->
	lists:reverse([], UndeclareVarsAst);
create_undeclare_vars(Line, [Var | Rest], Scope, UndeclareVarsAst) ->
	{{var, VarName}, _VarValue} = Var,
	st:delete(Scope, VarName),
	ScopeAst = gen_ast:scope(Line, st:get_scope()),

	UndeclareAst = rcall(Line, st, delete, [ScopeAst, string(Line, VarName)]),

	create_undeclare_vars(Line, Rest, Scope, [UndeclareAst | UndeclareVarsAst]).
