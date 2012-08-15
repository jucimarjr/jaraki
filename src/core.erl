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
-export([transform_jast_to_east/3]).
-import(gen_ast,
	[
		function/4, var/2, atom/2, call/3, rcall/4, 'case'/3, clause/4,
		'fun'/2, string/2, tuple/2, atom/2, integer/2, float/2, list/2
	]).
-include("../include/jaraki_define.hrl").

%%-----------------------------------------------------------------------------
%% Converte o jast em east.
%%   jast -> arvore sintatica do java.
%%   east -> arvore sintatica do erlang.
%% TODO: tratar múltiplos arquivos, ou seja, múltiplas classes
transform_jast_to_east(JavaAST, ErlangModuleName, ClassesInfo) ->
	io:format("core: compilando \"~p\"...\n", [ErlangModuleName]),

	st:new(),
	st:insert_classes_info(ClassesInfo),

	ErlangModuleBody = [get_erl_body(JavaClass)|| JavaClass <- JavaAST],

	%% TODO: declare_static_fields()
	DefaultConstructor = create_default_constructor(ErlangModuleName),
	ParentMethods      = create_all_parent_methods(ErlangModuleName),
	OOFuns = [DefaultConstructor] ++ ParentMethods,

	ErlangModule = create_module(ErlangModuleName, ErlangModuleBody, OOFuns),

	case st:get_errors() of
		[] ->
			st:destroy(),
			{ok, ErlangModule};
		Errors ->
			st:destroy(),
			throw({error, Errors})
	end.

%%-----------------------------------------------------------------------------
%% Extrai o corpo do modulo erlang a partir de uma classe java
get_erl_body(JavaClass) ->
	case JavaClass of
		{_Line1, _PackageName, {class_list, [{class, ClassData}]}} ->
			{_Line2, NameJast, ParentJast, BodyJast} = ClassData,
			{name, ClassName}     = NameJast,
			{parent, _ParentName}  = ParentJast,
			{body, JavaClassBody} = BodyJast,

			match_erl_member(ClassName, JavaClassBody);

		{class, ClassData} ->
			{_Line, NameJast, ParentJast, BodyJast} = ClassData,
			{name, ClassName}     = NameJast,
			{parent, _ParentName}  = ParentJast,
			{body, JavaClassBody} = BodyJast,

			match_erl_member(ClassName, JavaClassBody)
	end.

%%-----------------------------------------------------------------------------
%% Extrai um campo ou funcao da classe
%% Observação: campos são tratados em outro momento da análise
match_erl_member(ClassName, JavaClassBody) ->
	match_erl_member(ClassName, JavaClassBody, []).

%% ---------------
match_erl_member(_ClassName, [], ErlangModuleBody) ->
	lists:reverse(ErlangModuleBody, []);

match_erl_member(ClassName, [Member | Rest], ErlangModuleBody) ->
	case Member of
		{var_declaration, _VarType, _VarList} ->
			match_erl_member(ClassName, Rest, ErlangModuleBody);

		{method, MethodData} ->
			TransformedMethod = get_erl_function(ClassName, MethodData),
			NewErlangModuleBody = [TransformedMethod | ErlangModuleBody],
			match_erl_member(ClassName, Rest, NewErlangModuleBody);

		{constructor, ConstructorData} ->
			ConstructorAst = create_constructor(ClassName, ConstructorData),
			NewErlangModuleBody = [ConstructorAst | ErlangModuleBody],
			match_erl_member(ClassName, Rest, NewErlangModuleBody)
	end.

%%-----------------------------------------------------------------------------
%% Extrai uma funcao erl de um metodo java
%% ISSUE: funciona apenas para métodos públicos
%% TODO: tratar visibilidade dos métodos quando trabalhar com POO.

get_erl_function(ClassName, MethodData) ->
	{_, _, {name, MethodName}, _, _, _} = MethodData,

	case MethodName of
		main -> get_erl_function(main, ClassName, MethodData);
		_Other -> get_erl_function(other_method, ClassName, MethodData)
	end.

%% TODO: trocar o put(type_method, TypeName) por buscar oo na st!
get_erl_function(other_method, ClassName, MethodData) ->
	{Line, _Return, MethodNameJast, _Modifiers, Parameters, Block} = MethodData,

	{block, _BlockLine, JavaMethodBody} = Block,
	%{return, {_TypeLine, TypeName}} = Return,
	{name, MethodName} = MethodNameJast,

	ParametersTypeList = [Type || {_, {var_type, {_, Type}}, _} <- Parameters],
	st:put_scope({ClassName, {MethodName, ParametersTypeList}}),
	%put(type_method, TypeName),

	{ArgumentsLength, ErlangFunctionBody} =
		get_erl_function_body(Line, JavaMethodBody, Parameters),

	function(Line, MethodName, ArgumentsLength, ErlangFunctionBody);

%%% tem que saber qual a classe pq se for chamada de método de objeto,
%%  precisa saber quais os campos que são acessíveis, para saber qual código
%% transformado botar
%%
%% se for método de classe, static, é preciso saber qual a classe para dar
%% acesso as atributos static!!!

%% TODO: verificar quando retorno não é void!!
%% TODO: verificar se é static!!
get_erl_function(main, ClassName, MethodData) ->
	{Line, _Return, _MethodName, Modifiers, Parameters, Block} = MethodData,

	{block, _BlockLine, JavaMethodBody} = Block,
	[{_Line, {var_type, {_Line, ArgClass}}, _ArgName}] = Parameters,

	case ArgClass of
		{array, 'String'} ->
			ok;
		_ ->
			jaraki_exception:handle_error(Line, 4)
	end,
	case Modifiers of
		{modifiers, [public, static]} -> ok;
		_                -> jaraki_exception:handle_error(Line, 5)
	end,

	ParametersTypeList = [Type || {_, {var_type, {_, Type}}, _} <- Parameters],
	st:put_scope({ClassName, {main, ParametersTypeList}}),

	{ArgumentsLength, ErlangFunctionBody} =
		get_erl_function_body(Line, JavaMethodBody, Parameters),

	function(Line, main, ArgumentsLength, ErlangFunctionBody).

%%-----------------------------------------------------------------------------
%% Converte o corpo do metodo java em funcao erlang.
%% TODO: Verificar melhor forma de detectar "{nil, Line}".
%% TODO: Declarar variável em qualquer lugar (mover o fun)
%% TODO: tratar assinatura do método por tipo de args, linha 157
get_erl_function_body(Line, JavaMethodBody, ParametersList) ->
	Scope = st:get_scope(),
	{ScopeClass, ScopeMethod} = Scope,

	ErlangArgsListTemp1 = gen_ast:function_args_list(Line, ParametersList),

	case st:is_static_method(ScopeClass, ScopeMethod) of
		true ->
			ErlangArgsList = ErlangArgsListTemp1;
		false ->
			ErlangArgsList = [var(Line, "ObjectID") | ErlangArgsListTemp1]
	end,

	declare_parameters(ParametersList),

	InitArgsAst = gen_ast:init_args(Line, ParametersList),

	MapBodyFun =
		fun(
			{var_declaration,
				{var_type,{VarLine, VarType}},
				{var_list, VarList}
			} = VarDeclaration
		) ->
			st:insert_var_list(VarLine, st:get_scope(), VarList, VarType),
			gen_erl_code:match_statement(VarDeclaration);

		(Statement) ->
			gen_erl_code:match_statement(Statement)
		end,


	New =
		case st:get_scope() of
			{_ScopeClass1, {main,_}} ->
				[rcall(Line, st, new, [])];
			_ ->
				[]
		end,

	OldStack =
	case get(type_method) of
		void ->
			[rcall(Line, st, get_old_stack,
				[gen_ast:scope(Line, st:get_scope())])];
		_ ->
			[]
	end,

	Destroy = case st:get_scope() of
		{_ScopeClass2, {main, _}} ->
			[rcall(Line,st, destroy, [])];
		_ ->
			[]
	end,

	ErlangStmtTemp1 =
		New ++
		[rcall(Line, st, get_new_stack,[gen_ast:scope(Line, st:get_scope())])]
		++
		InitArgsAst ++
		lists:map(MapBodyFun, JavaMethodBody) ++
		OldStack ++ Destroy,

	ErlangStmt = helpers:remove_nop(ErlangStmtTemp1),

	ErlangFunctionBody = [{clause, Line, ErlangArgsList, [], ErlangStmt}],

	{length(ErlangArgsList), ErlangFunctionBody}.

%%-----------------------------------------------------------------------------
%% Cria o modulo a partir do east.
create_module(Name, ErlangAST, OOFuns) ->
	[ { attribute, 1, module, Name },{ attribute, 2, compile, export_all },
			{attribute, 3, import, {loop, [{for, 3}, {while, 2}, {do_while, 2}]}},
			{attribute ,6, import, {vector,[{new,1},{get_vector,1}]}},
			{attribute ,7, import, {matrix,[{new_matrix,1},
						{creation_matrix,2}]}},
			{attribute, 4, import, {random_lib, [{function_random, 2}]}},
			{attribute, 4, import, {file_lib, [{function_file, 3}, {function_file, 1}]}}]
	++ OOFuns ++ hd(ErlangAST) ++ [ { eof, 1 }].

%%-----------------------------------------------------------------------------
%% cria o construtor
create_constructor(ClassName, ConstructorData) ->
	{Line, ClassNameJast, _Visibility, Parameters, Block} = ConstructorData,

	{block, _BlockLine, JavaMethodBody} = Block,
	{name, ConstructorName} = ClassNameJast,

	%% TODO: verificar se nome do construtor bate com o nome da classe

	ClassName2 = helpers:lower_atom(ClassName),
	NewObjectAst = gen_ast:new_object(Line, ClassName2),

	ObjectIDAst = gen_ast:match(Line, var(Line, "ObjectID"), NewObjectAst),

	ParametersTypeList = [Type || {_, {var_type, {_, Type}}, _} <- Parameters],

	Scope = {ClassName, {'__constructor__', ParametersTypeList}},
	st:put_scope(Scope),

	ErlangArgsAstList = gen_ast:function_args_list(Line, Parameters),

	declare_parameters(Parameters),

	InitArgsAst = gen_ast:init_args(Line, Parameters),

	MapBodyFun =
		fun(
			{var_declaration,
				{var_type,{VarLine, VarType}},
				{var_list, VarList}
			} = VarDeclaration
		) ->
			st:insert_var_list(VarLine, st:get_scope(), VarList, VarType),
			gen_erl_code:match_statement(VarDeclaration);

		(Statement) ->
			gen_erl_code:match_statement(Statement)
		end,

	ErlangStmtTemp1 =
		[ObjectIDAst] ++ InitArgsAst ++ lists:map(MapBodyFun, JavaMethodBody)
		++ [var(Line, "ObjectID")],

	ErlangStmt = helpers:remove_nop(ErlangStmtTemp1),

	ErlangFunctionBody = [{clause, Line, ErlangArgsAstList, [], ErlangStmt}],

	FunctionName = '__constructor__',
	ArgumentsLength = length(ErlangArgsAstList),

	function(Line, FunctionName, ArgumentsLength, ErlangFunctionBody).

%%-----------------------------------------------------------------------------
%% cria o construtor padrão da classe
create_default_constructor(ErlangModuleName) ->
	Line = 0,
	FunctionName = '__constructor__',
	Parameters = [],

	NewObjectAst = gen_ast:new_object(Line, ErlangModuleName),

	ConstructorBody = [NewObjectAst],

	FunctionBody = [{clause, Line, [], [], ConstructorBody}],

	function(Line, FunctionName, Parameters, FunctionBody).

%%-----------------------------------------------------------------------------
%% declara os métodos das super classes
create_all_parent_methods(ClassName) ->
	AllMethodsList = st:get_methods_with_parent(ClassName),
	[_ClassMethods | InheritedMethods] = AllMethodsList,
	create_parent_method_list(InheritedMethods, []).

create_parent_method_list([], AllMethodsList) -> AllMethodsList;
create_parent_method_list([{ClassName, MethodsList} | Rest], Result) ->
	TempL = [create_parent_method(Method, ClassName) || Method <- MethodsList],
	create_parent_method_list(Rest, TempL ++ Result).

create_parent_method(MethodInfo, ClassName) ->
	Line = 0,

	{{MethodName, ArgTypeList}, {_, Modifiers}} = MethodInfo,

	ArgsAstList = gen_ast:function_args_list2(Line, ArgTypeList),

	case helpers:has_element(static, Modifiers) of
		false -> ArgsAstList2 = [var(Line, "ObjectID") | ArgsAstList];
		true  -> ArgsAstList2 = ArgsAstList
	end,

	ParentMethodCall = rcall(Line, ClassName, MethodName, ArgsAstList2),
	MethodBody = [ParentMethodCall],

	MethodClauses = [{clause, Line, ArgsAstList2, [], MethodBody}],

	function(Line, MethodName, length(ArgsAstList2), MethodClauses).

%%-----------------------------------------------------------------------------
%% declara na st as variáveis do parâmetro de uma função ou construtor
declare_parameters([]) ->
	ok;
declare_parameters([Param | ParametersList]) ->
	{_VarLine, {var_type, {_Line, VarType}}, {parameter, VarName}} = Param,
	st:put_value({st:get_scope(), VarName}, {VarType, undefined}),
	declare_parameters(ParametersList).
