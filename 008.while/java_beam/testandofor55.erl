-module(testandofor55).

-compile(export_all).

-import(control, [for/3]).

main(Var_Args) ->
    begin Var_n1 = 5, put("n", Var_n1) end,
    begin Var_x1 = 0, put("x", Var_x1) end,
    begin Var_y1 = 0, put("y", Var_y1) end,
    begin
      put("i", 0),
      for(fun () -> get("i") =< get("n") end,
	  fun () -> put("i", get("i") + 1) end,
	  fun () ->
		  Var_n2 = get("n"),
		  Var_i2 = get("i"),
		  Var_y2 = get("y"),
		  Var_x2 = get("x"),
		  begin Var_x3 = Var_x2 + Var_i2, put("x", Var_x3) end,
		  begin
		    put("j", 0),
		    for(fun () -> get("j") =< get("n") end,
			fun () -> put("j", get("j") + 1) end,
			fun () ->
				Var_j2 = get("j"),
				Var_n3 = get("n"),
				Var_i3 = get("i"),
				Var_y3 = get("y"),
				Var_x4 = get("x"),
				begin
				  Var_y4 = Var_x4 + Var_j2, put("y", Var_y4)
				end,
				put("j", Var_j2),
				put("n", Var_n3),
				put("y", Var_y4),
				put("i", Var_i3),
				put("x", Var_x4)
			end),
		    erase("j"),
		    Var_n4 = get("n"),
		    Var_y5 = get("y"),
		    Var_i4 = get("i"),
		    Var_x5 = get("x")
		  end,
		  put("n", Var_n4),
		  put("y", Var_y5),
		  put("i", Var_i4),
		  put("x", Var_x5)
	  end),
      erase("i"),
      Var_n5 = get("n"),
      Var_y6 = get("y"),
      Var_x6 = get("x")
    end,
    io:format("~p~n", [Var_x6]),
    io:format("~p~n", [Var_y6]).

