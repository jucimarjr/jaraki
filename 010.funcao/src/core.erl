%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%%			Eden ( edenstark@gmail.com )
%%			Helder Cunha Batista ( hcb007@gmail.com )
%%			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%%			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%%			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Transforma instrucoes Java em instrucoes Erlang

-module(core).
-export([transform_jast_to_east/2]).
-include("../include/jaraki_define.hrl").

%%-----------------------------------------------------------------------------
%% Converte o jast em east.
%%   jast -> arvore sintatica do java.
%%   east -> arvore sintatica do erlang.
%% TODO: tratar múltiplos arquivos, ou seja, múltiplas classes
transform_jast_to_east(JavaAST, ErlangModuleName) ->
	ErlangModuleBody =
		lists:map(
			fun(JavaClass) -> get_erl_body(JavaClass) end,
			JavaAST
		),
	ErlangModule = create_module(ErlangModuleName, ErlangModuleBody),
	{ok, ErlangModule}.


%%-----------------------------------------------------------------------------
%% Extrai o corpo do modulo erlang a partir de uma classe java
%% TODO: Tratar atributos ("variáveis globais") da classe...
get_erl_body(JavaClass) ->
	{_Line, _JavaClassName, {class_body, JavaClassBody}} = JavaClass,

	put(loop, false),
	lists:map(
		fun(JavaMethod) -> get_erl_function(JavaMethod) end,
		JavaClassBody
	).

%%-----------------------------------------------------------------------------
%% Extrai uma funcao erl de um metodo java
%% ISSUE: funciona apenas pro main()
%% TODO: Tratar metodos genericos...
get_erl_function({Line, {method, 'main'}, Parameters,
					{block, JavaMethodBody}} = JavaMethod) ->
	
	[{_Line, {var_type, {_Line, ArgClass}}, _ArgName}] = Parameters,

	case ArgClass of
		'String' ->
			ok;
		_ ->
			jaraki_exception:handle_error(
				"The args of the \"main method\" is not String")
	end,
	put(scope, 'main'),
	ErlangFunctionBody = 
		get_erl_function_body(Line, JavaMethodBody, Parameters),
	{function, Line, 'main', length(Parameters), ErlangFunctionBody};

get_erl_function({Line, {method, FunctionIdentifier}, Parameters,
					{block, JavaMethodBody}} = JavaMethod) ->
	
	put(scope, FunctionIdentifier),
	ErlangFunctionBody = 
		get_erl_function_body(Line, JavaMethodBody, Parameters),
	{function, Line, FunctionIdentifier, length(Parameters), ErlangFunctionBody}.

%%-----------------------------------------------------------------------------
%% Converte o corpo do metodo java em funcao erlang.
%% TODO: Verificar melhor forma de detectar "{nil, Line}".
%% TODO: Declarar variável em qualquer lugar (mover o fun)
get_erl_function_body(Line, JavaMethodBody, ParametersList) ->
	ErlangArgsList =
		[
			{var, ParamLine,
				list_to_atom("Var_" ++ atom_to_list(ParamName) ++ "1")} ||
			{ParamLine, _ClassIdentifier, {parameter, ParamName}} <- 
				ParametersList
		],
	MappedParamsFun = 
		fun ({VarLine, {var_type, {_Line, VarType}},{parameter, VarName}}) ->
			jaraki_identifier:insert(VarLine, VarType, VarName),

			{ok, VarRecord} = jaraki_identifier:get_var(VarName),
			NewCounter = VarRecord#var.counter + 1,
			JavaName = VarRecord#var.java_name,
			ErlangName = "Var_" ++ JavaName ++ integer_to_list(NewCounter),
			NewVarRecord = VarRecord#var{erl_name = ErlangName, counter = NewCounter},

			jaraki_identifier:set_var(VarName, NewVarRecord)
		end,
	lists:map( MappedParamsFun, ParametersList ),

	MappedErlangFun =
		fun(
			{var_declaration, 
				{var_type,{VarLine, VarType}},
				{var_list, VarList}
			}
		) ->	
			jaraki_identifier:insert_var_list(VarLine, VarType, 
								VarList);
		(Statement) -> 
			gen_erl_code:match_statement(Statement)
		end,

	InitEts = [{call, Line,
			{remote, Line, 
				{atom, Line, st}, {atom, Line, new}},[]}],

	ErlangStmtTemp1 = lists:map(MappedErlangFun, JavaMethodBody),
	ErlangStmtTemp2 = [
			Element || 
			Element <- ErlangStmtTemp1, 
			Element =/= no_operation
			],
	ErlangStmt = InitEts ++ ErlangStmtTemp2,
	
	[{clause, Line, ErlangArgsList, [], ErlangStmt}].

%%-----------------------------------------------------------------------------
%% Cria o modulo a partir do east.
create_module(Name, ErlangAST) ->
	[ { attribute, 1, module, Name },{ attribute, 2, compile, export_all },
			{attribute, 3, import, {loop, [{for, 3}, {while, 2}]}}]
	++ hd(ErlangAST) ++ [ { eof, 1 }].
