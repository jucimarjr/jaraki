-module(testandofor6).

-compile(export_all).

-import(loop, [for/3, while/2]).
-import(st).

main(V_Args) ->
    st:new(),
    begin
      Var_anterior1 = 0,
      st:insert({"anterior", Var_anterior1})
    end,
    begin
      Var_proximo1 = 1, st:insert({"proximo", Var_proximo1})
    end,
    begin Var_temp1 = 0, st:insert({"temp", Var_temp1}) end,
    begin Var_n1 = 10, st:insert({"n", Var_n1}) end,
    begin
      st:insert({"i", 1}),
      for(fun () -> st:get("i") =< st:get("n") end,
	  fun () -> st:insert({"i", st:get("i") + 1}) end,
	  fun () ->
		  Var_n2 = st:get("n"),
		  Var_i2 = st:get("i"),
		  Var_temp2 = st:get("temp"),
		  Var_proximo2 = st:get("proximo"),
		  Var_anterior2 = st:get("anterior"),
		  io:format("~p", [Var_anterior2]),
		  io:format(", "),
		  begin
		    Var_temp3 = Var_anterior2,
		    st:insert({"temp", Var_temp3})
		  end,
		  begin
		    Var_anterior3 = Var_proximo2,
		    st:insert({"anterior", Var_anterior3})
		  end,
		  begin
		    Var_proximo3 = Var_temp3 + Var_proximo2,
		    st:insert({"proximo", Var_proximo3})
		  end,
		  st:insert({"n", Var_n2}),
		  st:insert({"i", Var_i2}),
		  st:insert({"temp", Var_temp3}),
		  st:insert({"proximo", Var_proximo3}),
		  st:insert({"anterior", Var_anterior3})
	  end),
      st:delete("i"),
      Var_n3 = st:get("n"),
      Var_temp4 = st:get("temp"),
      Var_proximo4 = st:get("proximo"),
      Var_anterior4 = st:get("anterior")
    end.

