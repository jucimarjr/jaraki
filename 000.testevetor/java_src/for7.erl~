-module(for7).
-export([main/1]).
-import(loop, [for/3]).

-compile(nowarn_unused_vars).

main(V_Args) ->
	st:new(),
	begin Var_n1 = 50, st:insert({"n", Var_n1}) end,
	begin Var_x1 = 0, st:insert({"x", Var_x1}) end,			
	begin
		st:insert({"i", 0}),
		for(	fun() -> st:get("i") < st:get("n") end,
			fun() -> st:insert({"i", st:get("i") + 1}) end,
			fun() ->
				Var_n2 = st:get("n"),
				Var_x2 = st:get("x"),
				Var_i1 = st:get("i"),

				io:format("Estou contando e calculando dentro do for :D "),
				io:format("i: ~p~n", [Var_i1]),

				Var_x3 = Var_x2 + Var_i1,

				io:format("~p~n", [Var_x2]),
	
				st:insert({"n", Var_n2}),
				st:insert({"x", Var_x3}), 					
				st:insert({"i", Var_i1}) 
			end
),
		st:delete("i"),
		V_n3 = st:get("n"),		
		V_x4 = st:get("x")

	end.
