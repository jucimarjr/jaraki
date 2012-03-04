-module(for5).
-compile(export_all).
-import(jaraki_lib, [for/3]).

main(V_Args) ->
	begin V_n1 = 5, put("n", V_n1) end,
	begin V_x1 = 0, put("x", V_x1) end,
	%% início do for
	begin
		put("i", 0),
		for(%% funcao de condicao
			fun() -> get("i") =< get("n") end,
			%% funcao de incremento
			fun() -> put("i", get("i") + 1)	end,
			%% funcao do corpo
			fun() ->
				Var_n1 = get("n"),
				Var_x1 = get("x"),
				Var_i  = get("i"),
			%% inicio do corpo do for
				io:format("Estou contando e calculando dentro do for :D "),
				io:format("~p~n", [Var_i]),
				begin Var_x2 = Var_x1 + Var_i, put("x", Var_x2) end,
				io:format("~p~n", [Var_x2]),
			%% final do corpo do for
			put("x", Var_x2),
			put("n", Var_n1),
			put("i", Var_i)
			end
		),
		erase("i"),
		V_n2 = get("n"),
		V_x3 = get("x")
	end.
