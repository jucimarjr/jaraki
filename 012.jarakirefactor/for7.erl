-module(for7).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(Var_Args1) ->
    st:new(),
    st:insert({"s", 0}),
    st:insert({"denominador", 1}),
    st:insert({"numerador", 1}),
    begin
      st:insert({"i", 1}),
      for(fun () -> st:get("i") =< 10 end,
	  fun () -> st:insert({"i", st:get("i") + 1}) end,
	  fun () ->
		  io:format("~p", [st:get("numerador")]),
		  io:format("~s", ["/"]),
		  io:format("~p", [st:get("denominador")]),
		  io:format("~s", [" , "]),
		  st:insert({"denominador",
			     st:get("denominador") + st:get("i")}),
		  st:insert({"numerador",
			     st:get("numerador") * st:get("i")}),
		  st:insert({"s",
			     st:get("s") +
			       st:get("numerador") / st:get("denominador")})
	  end)
    end,
    io:format("~p~n", [st:get("s")]).

