-module(testandovetor000).

-compile(export_all).

-import(loop, [for/3, while/2]).
-import(st).

main(V_Args) ->
    st:new(),
    begin
      Array_vet = array:set(0, 1, array:new()),
      Array_vet1 = array:set(1, 2, Array_vet),
      Array_vet2 = array:set(2, 3, Array_vet1),

      st:insert({"vet", Array_vet2})
    end,
    begin Var_n1 = 2, st:insert({"n", Var_n1}) end,
    begin
      st:insert({"i", 0}),
      for(fun () -> st:get("i") =< st:get("n") end,
	  fun () -> st:insert({"i", st:get("i") + 1}) end,
	  fun () ->
		  Var_i2 = st:get("i"),
		  Array_vet3 = st:get("vet"),
		  io:format("~p~n", [array:get(Var_i2, Array_vet3)])
	  end),
      st:delete("i"),
      Array_vet4 = st:get("vet")
    end.

