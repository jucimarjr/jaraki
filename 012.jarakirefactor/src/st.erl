-module(st).
-export([new/0, insert/1, delete/1, get/1]).

new() ->
	TableName = ets:new(dict,[named_table]),
	TableName.

insert({VarName,VarValue}) ->
	ets:insert(dict,{VarName,VarValue}).

get(VarName) ->
	VarValue = ets:lookup(dict,VarName),
	[{_,Valor}] = VarValue,
	Valor.

delete(VarName) ->
	ets:delete(dict,VarName).



