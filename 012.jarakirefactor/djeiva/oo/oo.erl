-module(oo).
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
new(ClassName, SuperClasses, VarsList) ->
	ObjectID = ets:update_counter(dict, object_counter, 1),
	declare_attributes(ObjectID, VarsList),
	declare_object(ObjectID, ClassName, SuperClasses),
	ObjectID.

%% em tempo de compilação são gerados quais atributos esse objeto deve ter
%% isso é descoberto analisando-se a classe atual e suas superclasses
declare_attributes(_, []) ->
	ok;
declare_attributes(ObjectID, [ Var | Rest ]) ->
	{VarName, VarType, VarValue} = Var,
	Key = {object_var, ObjectID, VarName},
	Value = {VarType, VarValue},
	ets:insert(dict, {Key, Value}),

	declare_attributes(ObjectID, Rest).

%% função apenas para encapsular, não é necessário estar em uma função mesmo...
declare_object(ObjectID, ClassName, SuperClasses) ->
	Key = {object, ObjectID},
	Value = {ClassName, SuperClasses},
	ets:insert(dict, {Key, Value}),
	ObjectID.

get_class(ObjectID) ->
	Key = {object, ObjectID},
	[{_Key, {ClassName, _SuperClasses}}] = ets:lookup(dict, Key),
	ClassName.

%% ObjectID = integer(), obtido em new()
%% Var = {VarName, VarType, NewVarValue}
update_attribute(ObjectID, {VarName, VarType, NewVarValue}) ->
	Key = {object_var, ObjectID, VarName},
	Value = {VarType, NewVarValue},
	st:put(Key, Value).

get_attribute(ObjectID, VarName) ->
	Key = {object_var, ObjectID, VarName},
	[{_Key, {_Type, Value}}] = ets:lookup(dict, Key),
	Value.
