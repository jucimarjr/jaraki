-module(st).
-compile(export_all).	

new() ->
	ets:new(dict, [named_table]).


%%SEMÂNTICA E GERAÇÃO DE CÓDIGO

%% VarValue na análise semântica: undefined indica que não foi inicializada
%% TODO: verificar se variável já existe...
%% TODO: duas variáveis
insert_var_list(Scope, [{identifier, VarName} | []], Type, VarValue) ->
	st:put({Scope, VarName}, {Type, VarValue});

insert_var_list(Scope, [{identifier, VarName} | Rest], Type, VarValue) ->
	st:put({Scope, VarName}, {Type, VarValue}),
	insert_var_list(Scope, Rest, Type, VarValue).

%% Semântica - Key = {Scope, VarName}, Value = {Type, VarValue}
put(Key, Value) ->
	ets:insert(dict, {Key, Value}),
	no_operation.

get(Scope, VarName) ->
	VarValue = ets:lookup(dict, {Scope, VarName}),
	[{_Key , {_Type, Value}}] = VarValue,
	Value.

delete(Scope, VarName) ->
	ets:delete(dict, {Scope, VarName}).

%% SEMÂNTICA
get2(Scope, VarName) ->
	VarValue = ets:lookup(dict, {Scope, VarName}),
	case VarValue of
		[{_Key , Value}] ->
					Value;
		[] ->
			jaraki_exception:handle_error("Variable not declared")
	end.

put_scope(Scope) ->
	ets:insert(dict, {scope, Scope}).

get_scope() ->
	[{_Key, Scope}] = ets:lookup(dict, scope),
	Scope.
