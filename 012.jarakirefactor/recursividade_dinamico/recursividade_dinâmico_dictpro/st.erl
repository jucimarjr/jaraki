-module(st).
-compile(export_all).

new() ->
	put(errors, []),
	put(scope, '__undefined__').

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

put_value({Scope, Var}, Value) ->
%% Semântica - Key = {Scope, VarName}, Value = {Type, VarValue}
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
	erase({Scope, VarName}).

%% Funções de Pilha

get_stack(Scope) ->
	get(Scope).

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
	put(dict, {scope, Scope}).

get_scope() ->
	get(scope).

put_error(Line, Code) ->
	NewErrors = [{Line, Code} | get(errors)],
	put(dict, {errors, NewErrors}).

get_errors() ->
	lists:reverse(get(errors), []).
