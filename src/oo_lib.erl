-module(oo_lib).
-export([new/3, update_attribute/2, get_attribute/2, get_class/1]).

%%	ClassName:
%%		atom()
%%		usado nas chamada de função
%%	SuperClasses:
%%		list() -> [ClassName]
%%		usado nas chamadas de "super"
%%		armazenados em ordem hierárquica (esq -> dir == super -> super.super)
%%	VarsList:
%%		list() -> [Var]
%%		Lista dos nomes dos atributos do objeto
%%	Var:
%%		tuple() -> {VarName, VarType}
%%		Atributo de um objeto
%%	VarName:
%%		string()
%%	VarType:
%%		atom()

%%-----------------------------------------------------------------------------
%% instancia um objeto de uma classe
new(ClassName, SuperClasses, VarsList) ->
	ObjectID = make_ref(),
	declare_attributes(ObjectID, VarsList),
	declare_object(ObjectID, ClassName, SuperClasses),
	ObjectID.

%%-----------------------------------------------------------------------------
%% Declara os atributos (armazenando eles no dicionário)
%%
%% em tempo de compilação são gerados quais atributos esse objeto deve ter
%% isso é descoberto analisando-se a classe atual e suas superclasses
declare_attributes(_, []) ->
	ok;
declare_attributes(ObjectID, [ Var | Rest ]) ->
	{VarName, VarType, VarValue} = Var,
	Key = {object_var, ObjectID, VarName},
	Value = {VarType, VarValue},
	put(Key, Value),

	declare_attributes(ObjectID, Rest).

%%-----------------------------------------------------------------------------
%% finaliza a declaração de um objeto
%%
%% função apenas para encapsular, não é necessário estar em uma função mesmo...
declare_object(ObjectID, ClassName, SuperClasses) ->
	Key = {object, ObjectID},
	Value = {ClassName, SuperClasses},
	put(Key, Value),
	ObjectID.

%%-----------------------------------------------------------------------------
%% obtém a classe de um determinado objeto
get_class(ObjectID) ->
	Key = {object, ObjectID},
	{ClassName, _SuperClasses} = get(Key),
	ClassName.

%%-----------------------------------------------------------------------------
%% ao alterar o valor de um atributo de um determinado objeto
%%
%% ObjectID = integer(), obtido em new()
%% Var = {VarName, VarType, NewVarValue}
update_attribute(ObjectID, {VarName, VarType, NewVarValue}) ->
	Key = {object_var, ObjectID, VarName},
	Value = {VarType, NewVarValue},
	put(Key, Value).

%%-----------------------------------------------------------------------------
%% acessar o atributo de um determinado objeto
get_attribute(ObjectID, VarName) ->
	Key = {object_var, ObjectID, VarName},
	{_Type, Value} = get(Key),
	Value.
