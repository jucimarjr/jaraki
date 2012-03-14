-module(listarprimos).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:put({main, "args"}, {'String', V_args}),
    st:put({main, "a"}, {int, 2}),
    st:put({main, "i"}, {int, 0}),
    st:put({main, "n"}, {int, 10}),
    io:format("~s~n", ["Primos"]),
    while(fun () -> st:get(main, "i") < st:get(main, "n")
	  end,
	  fun () ->
		  case ehprimo(st:get(main, "a")) == 0 of
		    true ->
			io:format("~s", ["Eh primo: "]),
			io:format("~p~n", [st:get(main, "a")]),
			st:put({main, "i"}, {int, st:get(main, "i") + 1});
		    false -> no_operation
		  end,
		  st:put({main, "a"}, {int, st:get(main, "a") + 1})
	  end).

ehprimo(V_n) ->
    st:put({ehprimo, "n"}, {int, V_n}),
    st:put({ehprimo, "primo"}, {int, 0}),
    begin
      st:put({ehprimo, "i"}, {int, 2}),
      for(fun () ->
		  st:get(ehprimo, "i") =< st:get(ehprimo, "n") - 1
	  end,
	  fun () ->
		  st:put({ehprimo, "i"}, {int, st:get(ehprimo, "i") + 1})
	  end,
	  fun () ->
		  case st:get(ehprimo, "n") rem st:get(ehprimo, "i") == 0
		      of
		    true ->
			st:put({ehprimo, "primo"},
			       {int, st:get(ehprimo, "primo") + 1});
		    false -> no_operation
		  end
	  end)
    end,
    st:get(ehprimo, "primo").

