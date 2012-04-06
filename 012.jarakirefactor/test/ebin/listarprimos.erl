-module(listarprimos).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"}, {'String', V_args}),
    st:put_value({main, "a"}, {int, 2}),
    st:put_value({main, "i"}, {int, 0}),
    st:put_value({main, "n"}, {int, 10}),
    io:format("~s~n", ["Primos"]),
    while(fun () ->
		  st:get_value(main, "i") < st:get_value(main, "n")
	  end,
	  fun () ->
		  case st:return_function(fun () ->
						  ehprimo(st:get_value(main,
								       "a"))
					  end,
					  ehprimo, [st:get_value(main, "a")])
			 == 0
		      of
		    true ->
			io:format("~s", ["Eh primo: "]),
			io:format("~p~n", [st:get_value(main, "a")]),
			st:put_value({main, "i"},
				     {int, st:get_value(main, "i") + 1});
		    false -> no_operation
		  end,
		  st:put_value({main, "a"},
			       {int, st:get_value(main, "a") + 1})
	  end),
    st:get_old_stack(main),
    st:destroy().

ehprimo(V_n) ->
    st:get_new_stack(ehprimo),
    st:put_value({ehprimo, "n"}, {int, V_n}),
    st:put_value({ehprimo, "primo"}, {int, 0}),
    begin
      st:put_value({ehprimo, "i"}, {int, 2}),
      for(fun () ->
		  st:get_value(ehprimo, "i") =<
		    st:get_value(ehprimo, "n") - 1
	  end,
	  fun () ->
		  st:put_value({ehprimo, "i"},
			       {int, st:get_value(ehprimo, "i") + 1})
	  end,
	  fun () ->
		  case st:get_value(ehprimo, "n") rem
			 st:get_value(ehprimo, "i")
			 == 0
		      of
		    true ->
			st:put_value({ehprimo, "primo"},
				     {int, st:get_value(ehprimo, "primo") + 1});
		    false -> no_operation
		  end
	  end),
      st:delete(ehprimo, "i")
    end,
    begin
      Return = st:get_value(ehprimo, "primo"),
      st:get_old_stack(ehprimo),
      Return
    end.

