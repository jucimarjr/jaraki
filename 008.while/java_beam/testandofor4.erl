-module(testandofor4).

-compile(export_all).

-import(loop, [for/3]).

main(V_Args) ->
    begin Var_n1 = 5, put("n", Var_n1) end,
    begin
      put("i", 0),
      for(fun () -> get("i") < get("n") end,
	  fun () -> put("i", get("i") + 1) end,
	  fun () ->
		  Var_n2 = get("n"),
		  Var_i2 = get("i"),
		  io:format("Estou contando dentro o for :D "),
		  io:format("~p~n", [Var_i2]),
		  put("n", Var_n2),
		  put("i", Var_i2)
	  end),
      erase("i"),
      Var_n3 = get("n")
    end.

