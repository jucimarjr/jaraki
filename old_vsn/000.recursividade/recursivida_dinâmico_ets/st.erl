-module(st).
-compile(export_all).	

new() ->
	ets:new(dict, [named_table]).

destroy() ->
	ets:delete(dict).

%%SEMÂNTICA E GERAÇÃO DE CÓDIGO

%% VarValue na análise semântica: undefined indica que não foi inicializada
insert_var_list(Scope, [{identifier, VarName} | []], Type, VarValue) ->
	get_declared(Scope, VarName, Type, VarValue),			
	no_operation;

insert_var_list(Scope, [{identifier, VarName} | Rest], Type, VarValue) ->
	get_declared(Scope, VarName, Type, VarValue),	
	insert_var_list(Scope, Rest, Type, VarValue).

%% Semântica - Key = {Scope, VarName}, Value = {Type, VarValue}
put({Scope, Var}, Value) ->
	ets:insert(dict, {{Scope, Var, get_stack(Scope)}, Value}).

get_stack(Scope) ->
	[{_Key, Stack}] = ets:lookup(dict, Scope),
	Stack.

get_new_stack(Scope) ->
	Value = ets:lookup(dict, Scope),	
	case Value of
		[{_Key, Stack}] ->
			NewStack = Stack + 1, 
			ets:insert(dict, {Scope, NewStack}),
			NewStack;
		[] ->
			NewStack = 1,
			ets:insert(dict, {Scope, NewStack}),
			NewStack
	end.

get_old_stack(Method) ->
	[{_Key, Stack}] = ets:lookup(dict, Method),	
	ets:insert(dict, {Method, Stack - 1}).

get(Scope, VarName) ->
	VarValue = ets:lookup(dict, {Scope, VarName, get_stack(Scope)}),
	[{_Key , {_Type, Value}}] = VarValue,
	Value.

get_value(Scope, Parameters) ->
	Value = ets:lookup(dict, {Scope, Parameters}),
	case Value of
	    [{{Scope, Parameters} , Return}] -> 
		{ok, Return};
	    _ -> 
		no_value
	end.

put_value({Scope, Parameters}, Return) ->
	ets:insert(dict, {{Scope, Parameters}, Return}).

delete(Scope, VarName) ->
	ets:delete(dict, {Scope, VarName}).

%% SEMÂNTICA
get2(Scope, VarName) ->
	VarValue = ets:lookup(dict, {Scope, VarName, get_stack(Scope)}),
	case VarValue of
		[{_Key , Value, _Stack}] ->
			Value;
		[] ->
			jaraki_exception:handle_error("Variable not declared")
	end.

get_declared(Scope, VarName, Type, VarValue) ->
	case ets:lookup(dict, {Scope, VarName}) of
		[] ->	
			st:put({Scope, VarName}, {Type, VarValue});
		[{_Key, _Value}] -> 
			jaraki_exception:
				handle_error("Variable already declared")
	end.

put_scope(Scope) ->
	ets:insert(dict, {scope, Scope}).

get_scope() ->
	[{_Key, Scope}] = ets:lookup(dict, scope),
	Scope.
