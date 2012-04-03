-module(st).
-compile(export_all).

new() ->
	put(errors, []),
	put(scope, '__undefined__').

destroy() ->
	erase().

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

put_value(Key, Value) ->
%% Semântica - Key = {Scope, VarName}, Value = {Type, VarValue}
	case Value of
		{Type, {ok, [ValueScanner]}} ->
			put(Key, {Type, ValueScanner});
		_ ->put(Key, Value)
	end.

get_value(Scope, VarName) ->
	VarValue = get({Scope, VarName}),
	{_Type, Value} = VarValue,
	Value.

delete(Scope, VarName) ->
	erase({Scope, VarName}).

%% SEMÂNTICA
get2(Line, Scope, VarName) ->
	VarValue = get({Scope, VarName}),
	case VarValue of
		undefined ->
			jaraki_exception:handle_error(Line, 1);
		Value ->
			Value
	end.

get_declared(Line, Scope, VarName, Type, VarValue) ->
	case get({Scope, VarName}) of
		[{_Key, _Value}] ->
			jaraki_exception:
				handle_error(Line, 2);
		_ ->
			put_value({Scope, VarName}, {Type, VarValue})
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
