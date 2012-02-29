-module(testandofor45).

-compile(export_all).

-import(control, [for/3]).

main(Var_Args) ->
    begin Var_n1 = 5, put("n", Var_n1) end,
    begin
      put("i", 0),
      for(fun () -> get("i") =< get("n") end,
	  fun () -> put("i", get("i") + 1) end,
	  fun () ->
		  Var_n2 = get("n"),
		  Var_i2 = get("i"),
		  io:format("Estou contando dentro o for :D "),
		  io:format("~p~n", [Var_i2]),
		  begin
		    put("j", 0),
		    for(fun () -> get("j") =< get("n") end,
			fun () -> put("j", get("j") + 1) end,
			fun () ->
				Var_j2 = get("j"),
				Var_n3 = get("n"),
				Var_i3 = get("i"),
				io:format("Estou contando dentro do 2o for :D "),
				io:format("~p~n", [Var_j2]),
				put("j", Var_j2),
				put("n", Var_n3),
				put("i", Var_i3)
			end),
		    erase("j"),
		    Var_n4 = get("n"),
		    Var_i4 = get("i")
		  end,
		  put("n", Var_n4),
		  put("i", Var_i4)
	  end),
      erase("i"),
      Var_n5 = get("n")
    end.

