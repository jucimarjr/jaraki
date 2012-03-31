-module(st).
-compile(export_all).

new() ->
	ets:new(dict, [named_table]),
	ets:insert(dict, {errors, []}),
	ets:insert(dict, {scope, '__undefined__'}).

destroy() ->
	ets:delete(dict).

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
put(Key, Value) ->
	case Value of
	{Type, {ok, [ValueScanner]}} ->
				ets:insert(dict, {Key, {Type, ValueScanner}});
	_ ->ets:insert(dict, {Key, Value})
	end.

get(Scope, VarName) ->
	VarValue = ets:lookup(dict, {Scope, VarName}),
	[{_Key , {_Type, Value}}] = VarValue,
	Value.

delete(Scope, VarName) ->
	ets:delete(dict, {Scope, VarName}).

%% SEMÂNTICA
get2(Line, Scope, VarName) ->
	VarValue = ets:lookup(dict, {Scope, VarName}),
	case VarValue of
		[{_Key , Value}] ->
					Value;
		[] ->
			jaraki_exception:handle_error(Line, 1)
	end.

get_declared(Line, Scope, VarName, Type, VarValue) ->
	case ets:lookup(dict, {Scope, VarName}) of
		[] ->
			st:put({Scope, VarName}, {Type, VarValue});
		[{_Key, _Value}] ->
			jaraki_exception:
				handle_error(Line, 2)
	end.

put_scope(Scope) ->
	ets:insert(dict, {scope, Scope}).

get_scope() ->
	[{_Key, Scope}] = ets:lookup(dict, scope),
	Scope.

put_error(Line, Code) ->
	[{_Key, Errors}] = ets:lookup(dict, errors),
	NewErrors = [ {Line, Code} | Errors ],
	ets:insert(dict, {errors, NewErrors}).

get_errors() ->
	[{_Key, Errors}] = ets:lookup(dict, errors),
	lists:reverse(Errors, []).
