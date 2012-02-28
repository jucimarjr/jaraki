-module(testandofor35).

-compile(export_all).

-import(control, [for/3]).

main(Var_Args) ->
    begin
      put("i", 0),
      for(fun () -> get("i") < 50 end,
	  fun () -> put("i", get("i") + 1) end,
	  fun () ->
		  Var_i2 = get("i"),
		  io:format("Estou contando dentro o for :D "),
		  io:format("~p~n", [Var_i2]),
		  begin
		    put("j", 0),
		    for(fun () -> get("j") < 50 end,
			fun () -> put("j", get("j") + 1) end,
			fun () ->
				Var_j2 = get("j"),
				Var_i3 = get("i"),
				io:format("Estou contando dentro do 2o for :D "),
				io:format("~p~n", [Var_j2]),
				put("j", Var_j2),
				put("i", Var_i3)
			end),
		    erase("j"),
		    Var_i4 = get("i")
		  end,
		  put("i", Var_i4)
	  end),
      erase("i")
    end.

