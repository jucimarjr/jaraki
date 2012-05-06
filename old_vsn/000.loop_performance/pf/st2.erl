-module(st2).
-compile(export_all).	

new() ->
	ets:new(dict, [named_table]).

destroy() ->
	erase().

%%SEMÂNTICA E GERAÇÃO DE CÓDIGO

%% VarValue na análise semântica: undefined indica que não foi inicializada
%% TODO: verificar se variável já existe...
%% TODO: duas variáveis
insert_var_list(Scope, [{identifier, VarName} | []], Type, VarValue) ->
	get_declared(Scope, VarName, Type, VarValue),			
	no_operation;

insert_var_list(Scope, [{identifier, VarName} | Rest], Type, VarValue) ->
	get_declared(Scope, VarName, Type, VarValue),	
	insert_var_list(Scope, Rest, Type, VarValue).

%% Semântica - Key = {Scope, VarName}, Value = {Type, VarValue}
putv(Key, Value) ->
	put(Key, Value).

get(Scope, VarName) ->
	VarValue = get({Scope, VarName}),
	{_Type, Value} = VarValue,
	Value.

delete(Scope, VarName) ->
	erase({Scope, VarName}).

%% SEMÂNTICA
get2(Scope, VarName) ->
	case get({Scope, VarName}) of
		{_Key , Value} ->
					Value;
		undefined ->
			jaraki_exception:handle_error("Variable not declared")
	end.

get_declared(Scope, VarName, Type, VarValue) ->
	case get({Scope, VarName}) of
		undefined ->	
			st:put({Scope, VarName}, {Type, VarValue});		
		{_Key, _Value} -> 
			jaraki_exception:
				handle_error("Variable already declared")
	end.

put_scope(Scope) ->
	put(scope, Scope).

get_scope() ->
	{_Key, Scope} = get(scope),
	Scope.
