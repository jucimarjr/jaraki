-module(testandofor5_objt_DICT).
-compile(export_all).
-import(jaraki_libs).

main(V_Args) ->
	V_n1 = 5,
	V_x1 = 0,

%% início do for
	D1 = dict:new(),
	D2 = dict:store("n", 5, D1),
	D3 = dict:store("x", 0, D2),

	InitFun =
		fun(Dict) ->
			 dict:store("i", 0, Dict)
		end,

	ConditionFun =
		fun(Dict) ->
				dict:fetch("i", Dict) <= dict:fetch("n", Dict)
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
			io:format("~p~n", [Var_i)]),

			Var_x2 = Var_x1 + Var_n1,

			io:format("~p~n", Var_x2),

			dict:update("n", fun(_) -> Var_x2 end, Dict)
			dict:update("x", fun(_) -> Var_n1 end, Dict)
			dict:update("i", fun(_) -> Var_i  end, Dict)


	DictAtualizado = for().

	V_n2 = dict:fetch(),
	V_x2 = dict:fetch(),
