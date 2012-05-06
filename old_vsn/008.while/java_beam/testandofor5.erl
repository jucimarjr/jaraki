-module(testandofor5).

-compile(export_all).

-import(control, [for/3]).

main(Var_Args) ->
    begin Var_n1 = 5, put("n", Var_n1) end,
    begin Var_x1 = 0, put("x", Var_x1) end,
    begin
      put("i", 0),
      for(fun () -> get("i") =< get("n") end,
	  fun () -> put("i", get("i") + 1) end,
	  fun () ->
		  Var_n2 = get("n"),
		  Var_i2 = get("i"),
		  Var_x2 = get("x"),
		  io:format("Estou contando e calculando dentro o "
			    "for :D "),
		  io:format("~p~n", [Var_i2]),
		  begin Var_x3 = Var_x2 + Var_i2, put("x", Var_x3) end,
		  io:format("~p~n", [Var_x3]),
		  put("n", Var_n2),
		  put("i", Var_i2),
		  put("x", Var_x3)
	  end),
      erase("i"),
      Var_n3 = get("n"),
      Var_x4 = get("x")
    end.

