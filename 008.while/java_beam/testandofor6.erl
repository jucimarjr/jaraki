-module(testandofor6).

-compile(export_all).

-import(loop, [for/3]).

main(V_Args) ->
    begin
      Var_anterior1 = 0, put("anterior", Var_anterior1)
    end,
    begin
      Var_proximo1 = 1, put("proximo", Var_proximo1)
    end,
    begin Var_temp1 = 0, put("temp", Var_temp1) end,
    begin Var_n1 = 10, put("n", Var_n1) end,
    begin
      put("i", 1),
      for(fun () -> get("i") =< get("n") end,
	  fun () -> put("i", get("i") + 1) end,
	  fun () ->
		  Var_n2 = get("n"),
		  Var_i2 = get("i"),
		  Var_temp2 = get("temp"),
		  Var_proximo2 = get("proximo"),
		  Var_anterior2 = get("anterior"),
		  io:format("~p", [Var_anterior2]),
		  io:format(", "),
		  begin
		    Var_temp3 = Var_anterior2, put("temp", Var_temp3)
		  end,
		  begin
		    Var_anterior3 = Var_proximo2,
		    put("anterior", Var_anterior3)
		  end,
		  begin
		    Var_proximo3 = Var_temp3 + Var_proximo2,
		    put("proximo", Var_proximo3)
		  end,
		  put("n", Var_n2),
		  put("i", Var_i2),
		  put("temp", Var_temp3),
		  put("proximo", Var_proximo3),
		  put("anterior", Var_anterior3)
	  end),
      erase("i"),
      Var_n3 = get("n"),
      Var_temp4 = get("temp"),
      Var_proximo4 = get("proximo"),
      Var_anterior4 = get("anterior")
    end.

