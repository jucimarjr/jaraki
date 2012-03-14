-module(listarprimos).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(Var_args1) ->
    st:new(),
    st:insert({"a", 2}),
    st:insert({"i", 0}),
    st:insert({"n", 10}),
    io:format("~s~n", ["Primos"]),
    while(fun () -> st:get("i") < st:get("n") end,
	  fun () ->
		  case ehprimo(st:get("a")) == 0 of
		    true ->
			io:format("~s", ["Eh primo: "]),
			io:format("~p~n", [st:get("a")]),
			st:insert({"i", st:get("i") + 1});
		    false -> no_operation
		  end,
		  st:insert({"a", st:get("a") + 1})
	  end).

ehprimo(Var_m1) ->
    st:insert({"primo", 0}),
    begin
      st:insert({"j", 2}),
      for(fun () -> st:get("j") =< st:get("m") - 1 end,
	  fun () -> st:insert({"j", st:get("j") + 1}) end,
	  fun () ->
		  case st:get("m") rem st:get("j") == 0 of
		    true -> st:insert({"primo", st:get("primo") + 1});
		    false -> no_operation
		  end
	  end)
    end,
    st:get("primo").

