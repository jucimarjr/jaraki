-module(st).
-export(
	[
		%% criar / zerar dicionário
		new/0,		destroy/0,

		%% tratar variáveis durante execução
		insert_var_list/4,	put_value/2,		get_value/2,	delete/2,
		get_stack/1,		get_new_stack/1,	get_old_stack/1,
		get_return/2,		put_return/2,		return_function/3,
		update_counter/2,

		%% tratar variáveis na semântica
		get2/3,			get_declared/5,			is_declared_var/2,
		put_scope/1,	get_scope/0,
		put_error/2,	get_errors/0,
		lookup/1,		insert/2,

		%% informações das classes
		insert_classes_info/1,	exist_class/1,
		exist_method/2,			get_method_info/2,	is_static_method/2,
		get_class_parent/1,		get_visible_methods/1,
		exist_field/2,			get_field_info/2,	get_all_fields_info/1,
		exist_constructor/2,	get_constr_info/2
	]).

-import(helpers, [has_element/2]).

new() ->
	put(errors, []),
	put(scope, '__undefined__'),
	put(array_address, 0),
	put(matrix_address, 0).

destroy() ->
	erase(), ok.

%%SEMÂNTICA E GERAÇÃO DE CÓDIGO

%% VarValue na análise semântica: undefined indica que não foi inicializada
%% TODO: verificar se variável já existe...
%% TODO: duas variáveis
insert_var_list(Line, Scope, [{{var, VarName}, _VarValue}	| []], Type) ->
	get_declared(Line, Scope, VarName, Type, undefined),
	no_operation;

insert_var_list(Line, Scope, [{{var, VarName}, _VarValue} | Rest], Type) ->
	get_declared(Line, Scope, VarName, Type, undefined),
	insert_var_list(Line, Scope, Rest, Type).

%% Semântica - Key = {Scope, VarName}, Value = {Type, VarValue}
put_value({Scope, Var}, Value) ->
	case Value of
		{Type, {ok, [ValueScanner]}} ->
		put({Scope, Var, get_stack(Scope)}, {Type, ValueScanner});
		_ ->
		put({Scope, Var, get_stack(Scope)}, Value)
	end.

get_value(Scope, VarName) ->
	VarValue = get({Scope, VarName, get_stack(Scope)}),
	{_Type, Value} = VarValue,
	Value.

delete(Scope, VarName) ->
	erase({Scope, VarName, get_stack(Scope)}).

%% Funções de Pilha

get_stack(Scope) ->
	case get(Scope) of
		undefined -> 0;
		_ -> get(Scope)
	end.

get_new_stack(Scope) ->
	case get(Scope) of
		undefined ->
			NewStack = 1,
			put(Scope, NewStack),
			NewStack;
		Stack ->
			NewStack = Stack + 1,
			put(Scope, NewStack),
			NewStack
	end.

get_old_stack(Scope) ->
	put(Scope, get(Scope) - 1).

get_return(Scope, Parameters) ->
	case get({Scope, Parameters}) of
		undefined ->
			no_value;
		Return ->
			{ok, Return}
	end.

put_return({Scope, Parameters}, Return) ->
	put({Scope, Parameters}, Return).

return_function(Fun, Scope, Parameters) ->
	case st:get_return(Scope, Parameters) of
	  {ok, Return} ->
		Return;
	  no_value ->
		Return = Fun(),
		st:put_return({Scope, Parameters}, Return),
		Return
	end.

%% SEMÂNTICA
get2(Line, Scope, VarName) ->
	case get({Scope, VarName, get_stack(Scope)}) of
		undefined ->
			jaraki_exception:handle_error(Line, 1);
		Value ->
			Value
	end.

get_declared(Line, Scope, VarName, Type, VarValue) ->
	case get({Scope, VarName, get_stack(Scope)}) of
		undefined ->
			put_value({Scope, VarName}, {Type, VarValue});
		_Value ->
			{jaraki_exception:handle_error(Line, 2), undefined}
	end.

is_declared_var(Scope, VarName) ->
	case get({Scope, VarName, get_stack(Scope)}) of
		undefined ->
			false;
		_ ->
			true
	end.

put_scope(Scope) ->
	put(scope, Scope).

get_scope() ->
	get(scope).

put_error(Line, Code) ->
	NewErrors = [{Line, Code} | get(errors)],
	put(errors, NewErrors).

get_errors() ->
	lists:reverse(get(errors), []).

lookup(Key) ->
	get(Key).

insert(Key, Value) ->
	put(Key, Value).

update_counter(DictVar, Increment) ->
	IndexValue = lookup(DictVar),
	insert(DictVar, IndexValue + Increment).

%%----------------------------------------------------------------------------
%%                            INFO DAS CLASSES
%% Dicionario de classes
%% Estrutura do dicionario:
%% Chave:
%%		{oo_classes, NomeDaClasse}
%% Onde:
%%		NomeDaClasse => atom()
%%
%% Valor:
%%		{NomePai, Campos, Metodos, Construtores}
%% Onde:
%%		Campos:  [Campo1, Campo2, ...]
%%		Metodos: [Metodo1, Metodo2, ...]
%%
%% CampoN:
%%		{Nome, CampoValue}
%%			   |
%%			   |> {Tipo, Modificadores}
%%
%% MetodoN:
%%		{ MethodKey, MethodValue}
%%		  |			 |
%%		  |			 |> {TipoRetorno, Modificadores}
%%		  |
%%		  |> {Nome, Parametros}
%%
%% Outros:
%%		Tipo			=> atom()
%%		Nome			=> atom()
%%		Modificadores	=> [ atom() ]
%%		Parametros		=> [ Tipo ]

%% inicializa "sub-dicionario" com informações das classes
insert_classes_info(ClassesInfoList) ->
	lists:map(fun put_class_info/1, ClassesInfoList),
	insert_parent_members(ClassesInfoList).

%% insere informação de uma classe
put_class_info({ClassName, ParentName, Fields, Methods, Constructors}) ->
	ClassName2 = list_to_atom(string:to_lower(atom_to_list(ClassName))),
	put({oo_classes, ClassName2}, {ParentName, Fields, Methods, Constructors}).

%% insere informações dos métodos visíveis na superclasse
insert_parent_members([]) -> ok;
insert_parent_members([{_, null, _, _, _} | Rest]) ->
	insert_parent_members(Rest);
insert_parent_members([ ClassInfo | Rest ]) ->
	{ClassName, ParentName, Fields, Methods,Constructors} = ClassInfo,
	ParentMethods = get_visible_methods(ParentName),
	ParentFields  = get_visible_fields(ParentName),

	NewMethods    = ParentMethods ++ Methods,
	NewFields     = ParentFields  ++ Fields,

	ClassName2 = list_to_atom(string:to_lower(atom_to_list(ClassName))),
	Key = {ParentName, NewFields, NewMethods, Constructors},
	put({oo_classes, ClassName2}, Key),

	insert_parent_members(Rest).

%% busca a informação de todos os métodos visíveis às classes filhas
get_visible_methods(ClassName) ->
	ClassName2 = list_to_atom(string:to_lower(atom_to_list(ClassName))),
	{_, _, MethodsInfo, _} = get({oo_classes, ClassName2}),
	lists:filter(fun is_visible_method/1, MethodsInfo).

is_visible_method({ _, {_, Modifiers} }) ->
	case Modifiers of
		[public    |_] -> true;
		[protected |_] -> true;
		_Other         -> false
	end.

%% busca a informação de todos os campos visíveis às casses filhas
get_visible_fields(ClassName) ->
	ClassName2 = list_to_atom(string:to_lower(atom_to_list(ClassName))),
	{_, FieldsInfo, _, _} = get({oo_classes, ClassName2}),
	lists:filter(fun is_visible_field/1, FieldsInfo).

is_visible_field({_, {_, Modifiers}}) ->
	not helpers:has_element(private, Modifiers).

%% busca a classe pai da classe recebida por parametro
get_class_parent(ClassName) ->
	ClassName2 = list_to_atom(string:to_lower(atom_to_list(ClassName))),
	{ParentName, _, _, _} = get({oo_classes, ClassName2}),
	ParentName.

%%---------------------------------------------

%% verifica se classe existe
exist_class(ClassName) ->
	ClassName2 = list_to_atom(string:to_lower(atom_to_list(ClassName))),
	case get({oo_classes, ClassName2}) of
		undefined  -> false;
		_ClassInfo -> true
	end.

%%----------------------------------------------------------------------------
%%                                MÉTODOS
%%
%% a assinatura de um método (que o trona único na classe) corresponde a:
%% - Nome (identificador)
%% ----- temporariamente desativado: Tipos dos parâmetros (em ordem)

%% verifica existência do método
exist_method(ClassName, {MethodName, Parameters}) ->
	case get_method_info(ClassName, {MethodName, Parameters}) of
		false       -> false;
		_MethodInfo -> true
	end.

%% busca informações do método de uma classe
get_method_info(ClassName, {MethodName, Parameters}) ->
	get_member_info(method, ClassName, {MethodName, Parameters}).

is_static_method(_, {'__constructor__', _})           -> false;
is_static_method(ClassName, {MethodName, Parameters}) ->
	{_ReturnType, Modifiers} =
		get_method_info(ClassName, {MethodName, Parameters}),
	has_element(static, Modifiers).

%%----------------------------------------------------------------------------
%%                              CAMPOS
%%
%% busca informações de todos os campos declarados
get_all_fields_info(ClassName) ->
	ClassName2 = list_to_atom(string:to_lower(atom_to_list(ClassName))),
	{_, FieldList, _, _} = get({oo_classes, ClassName2}),
	FieldList.

%% verifica se variável existe na classe
exist_field(ClassName, FieldName) ->
	case get_field_info(ClassName, FieldName) of
		false      -> false;
		_FieldInfo -> true
	end.

%% busca informações do campo de uma classe
get_field_info(ClassName, FieldName) ->
	get_member_info(field, ClassName, FieldName).

%%----------------------------------------------------------------------------
%%                            CONSTRUTORES
%%
%% busca informações dos construtores declarados
exist_constructor(ClassName, Parameters) ->
	case get_constr_info(ClassName, Parameters) of
		false            -> false;
		_ConstructorInfo -> true
	end.

get_constr_info(ClassName, Parameters) ->
	get_member_info(constructor, ClassName, Parameters).

%%----------------------------------------------------------------------------
%%                       MÉTODOS E CAMPOS (MEMBROS)
%%
%% busca informações de um membro da classe (método ou campo)
%% MemberType = field | method
get_member_info(MemberType, ClassName, MemberKey) ->
	ClassName2 = list_to_atom(string:to_lower(atom_to_list(ClassName))),
	{_, FieldList, MethodList, ConstrList} = get({oo_classes, ClassName2}),
	case MemberType of
		field ->
			get_member_info(MemberKey, FieldList);
		method ->
			get_member_info(MemberKey, MethodList);
		constructor ->
			get_member_info(MemberKey, ConstrList)
	end.

get_member_info(MemberKey, MemberList) ->
	case lists:keyfind(MemberKey, 1, MemberList) of
		{MemberKey, MemberValue} ->
			MemberValue;
		false ->
			false
	end.

%%                     FINAL INFO DAS CLASSES
%%----------------------------------------------------------------------------
