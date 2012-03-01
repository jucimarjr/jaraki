-module(dict).
-compile(export_all).
-import(loop, [for/4]).

main(V_Args) ->
	V_n1 = 5,
	V_x1 = 0,

%% início do for
	D1 = dict:new(),
	D2 = dict:store("n", V_n1, D1),
	D3 = dict:store("x", V_x1, D2),

	InitFun =
		fun(Dict) ->
			 dict:store("i", 0, Dict)
		end,

	ConditionFun =
		fun(Dict) ->
				dict:fetch("i", Dict) =< dict:fetch("n", Dict)
		end,

	IncrementFun =
		fun(Dict) ->
			dict:update("i", fun(OldValue) -> OldValue + 1 end, Dict)
		end,

	BodyFun =
		fun(Dict) ->
			Var_n1 = dict:fetch("n", Dict),
			Var_x1 = dict:fetch("x", Dict),
			Var_i  = dict:fetch("i", Dict),

			io:format("Estou contando e calculando dentro do for :D "),
			io:format("~p~n", [Var_i]),

			Var_x2 = Var_x1 + Var_n1,

			io:format("~p~n", Var_x2),

			D1 = dict:update("n", fun(_) -> Var_x2 end, Dict),
			D2 = dict:update("x", fun(_) -> Var_n1 end, D1),
			dict:update("i", fun(_) -> Var_i  end, D2)
		end,
	D4 = for(ConditionFun, IncrementFun, BodyFun, D3),

	V_n2 = dict:fetch("n", D4),
	V_x2 = dict:fetch("x", D4),
	D5 = dict:erase("i", D4).
