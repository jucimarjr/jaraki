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
	st:new(),
	st:insert_classes_info(ClassesInfo),

	ErlangModuleBody =
		[get_erl_body(JavaClass)|| JavaClass <- JavaAST],

	%% TODO: declare_static_fields()
	DefaultConstructor = create_default_constructor(ErlangModuleName),
	OOFuns = [DefaultConstructor],

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
			{_Line2, _JavaClassName, {body, JavaClassBody}} = ClassData,
			match_erl_member(JavaClassBody);

		{class, ClassData} ->
			{_Line, _JavaClassName, {body, JavaClassBody}} = ClassData,
			match_erl_member(JavaClassBody)
	end.

%%-----------------------------------------------------------------------------
%% Extrai um campo ou funcao da classe
%% Observação: campos são tratados em outro momendo da análise
match_erl_member(JavaClassBody) ->
	match_erl_member(JavaClassBody, []).

match_erl_member([], ErlangModuleBody) ->
	lists:reverse(ErlangModuleBody, []);
match_erl_member([Member | Rest], ErlangModuleBody) ->
	case Member of
		{var_declaration, _VarType, _VarList} ->
			match_erl_member(Rest, ErlangModuleBody);

		Method ->
			TransformedMethod = get_erl_function(Method),
			match_erl_member(Rest, [TransformedMethod | ErlangModuleBody])
	end.

%%-----------------------------------------------------------------------------
%% Extrai uma funcao erl de um metodo java
%% ISSUE: funciona apenas para métodos públicos
%% TODO: tratar visibilidade dos métodos quando trabalhar com POO.
get_erl_function({Line, _Type, {method, main}, Parameters,
					{block, _BlockLine, JavaMethodBody}})	 ->

	[{_Line, {var_type, {_Line, ArgClass}}, _ArgName}] = Parameters,

	case ArgClass of
		{array, 'String'} ->
			ok;
		_ ->
			jaraki_exception:handle_error(Line, 4)
	end,
	st:put_scope(main),
	ErlangFunctionBody =
		get_erl_function_body(Line, JavaMethodBody, Parameters),
	function(Line, main, Parameters, ErlangFunctionBody);

get_erl_function({Line, {_TypeLine, TypeName},
			{method, FunctionIdentifier}, Parameters,
					{block, _BlockLine, JavaMethodBody}}) ->

	st:put_scope(FunctionIdentifier),
	put(type_method, TypeName),
	ErlangFunctionBody =
		get_erl_function_body(Line, JavaMethodBody, Parameters),
	function(Line, FunctionIdentifier, Parameters, ErlangFunctionBody).

%%-----------------------------------------------------------------------------
%% Converte o corpo do metodo java em funcao erlang.
%% TODO: Verificar melhor forma de detectar "{nil, Line}".
%% TODO: Declarar variável em qualquer lugar (mover o fun)
get_erl_function_body(Line, JavaMethodBody, ParametersList) ->
	ErlangArgsList =
		[var(ParamLine,"V_" ++ atom_to_list(ParamName)) ||
			{ParamLine, _ClassIdentifier, {parameter, ParamName}}
			<- ParametersList
		],

	MappedParamsFun =
		fun ({_VarLine, {var_type, {_Line, VarType}},
				{parameter, VarName}}) ->
			st:put_value({st:get_scope(), VarName}, {VarType, undefined})
		end,
	lists:map( MappedParamsFun, ParametersList),


	ScopeAst = atom(Line, st:get_scope()),
	InitArgs = [
		rcall(Line, st, put_value, [
			tuple(Line,	[ScopeAst, string(Line, InitArgName)]),
			tuple(Line,
				[gen_ast:type_to_ast(Line, InitArgType),
					var(Line, "V_" ++ atom_to_list(InitArgName))])]) ||
		({_Line, {var_type, {_Line, InitArgType}},
				{parameter, InitArgName}}) <-ParametersList
		],

	MappedErlangFun =
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
			main ->
				[rcall(Line, st, new, [])];
			_ ->
				[]
		end,

	OldStack =
	case get(type_method) of
		void ->
			[rcall(Line, st, get_old_stack,
				[atom(Line, st:get_scope())])];
		_ ->
			[]
	end,

	Destroy = case st:get_scope() of
		main ->
			[rcall(Line,st, destroy, [])];
		_ ->
			[]
	end,


	ErlangStmtTemp1 =
		New ++
		[rcall(Line, st, get_new_stack,[atom(Line, st:get_scope())])]
		++
		InitArgs ++
		lists:map(MappedErlangFun, JavaMethodBody) ++
		OldStack ++ Destroy,

	ErlangStmt = [
			Element ||
			Element <- ErlangStmtTemp1,
			Element =/= no_operation
			],
	[{clause, Line, ErlangArgsList, [], ErlangStmt}].

%%-----------------------------------------------------------------------------
%% Cria o modulo a partir do east.
create_module(Name, ErlangAST, OOFuns) ->
	[ { attribute, 1, module, Name },{ attribute, 2, compile, export_all },
			{attribute, 3, import, {loop, [{for, 3}, {while, 2}]}},
			{attribute ,6, import, {vector,[{new,1},{get_vector,1}]}},
			{attribute ,7, import, {matrix,[{new_matrix,1},
						{creation_matrix,2}]}},
			{attribute, 4, import, {randomLib, [{function_random, 2}]}},
			{attribute, 4, import, {fileLib, [{function_file, 3}, {function_file, 0}]}}]
	++ OOFuns ++ hd(ErlangAST) ++ [ { eof, 1 }].

%%-----------------------------------------------------------------------------
%% cria o construtor padrão da classe
create_default_constructor(ErlangModuleName) ->
	Line = 0,
	FunctionName = '__constructor__',
	Parameters = [],

	ClassNameAst = atom(Line, ErlangModuleName),
	%% TODO: tratar super classes!
	SuperClassesAst = {nil, Line},

	FieldsInfoList = st:get_all_fields_info(ErlangModuleName),
	FieldsListAst = create_field_list(FieldsInfoList),

	Arguments = [ClassNameAst, SuperClassesAst, FieldsListAst],
	ConstructorBody = [rcall(Line, oo_lib, new, Arguments)],

	FunctionBody = [{clause, Line, [], [], ConstructorBody}],

	function(Line, FunctionName, Parameters, FunctionBody).

%%-----------------------------------------------------------------------------
%% cria a lista de campos no formato AST para o construtor padrão da classe
create_field_list(FieldInfoList) ->
	FieldAstList = lists:map(fun create_field/1, FieldInfoList),
	list(0, FieldAstList).

%%-----------------------------------------------------------------------------
%% cria a AST de um campo do construtor padrão da classe
create_field({Name, {Type, _Modifiers}}) ->
	NameAst = atom(0, Name),
	TypeAst = atom(0, Type),
	ValueAst =
		case Type of
			float    -> float(0, 0.0);
			int      -> integer(0, 0);
			long     -> integer(0, 0);
			double   -> integer(0, 0);
			boolean  -> atom(0, false);
			_RefType -> atom(0, undefined)
		end,
	tuple(0, [NameAst, TypeAst, ValueAst]).
