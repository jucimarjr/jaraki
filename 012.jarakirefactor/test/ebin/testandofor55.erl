-module(testandofor55).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "Args"}, {'String', V_Args}),
    st:put_value({main, "n"}, {int, 5}),
    st:put_value({main, "x"}, {int, 0}),
    st:put_value({main, "y"}, {int, 0}),
    begin
      st:put_value({main, "i"}, {int, 0}),
      for(fun () ->
		  st:get_value(main, "i") =< st:get_value(main, "n")
	  end,
	  fun () ->
		  st:put_value({main, "i"},
			       {int, st:get_value(main, "i") + 1})
	  end,
	  fun () ->
		  st:put_value({main, "x"},
			       {int,
				st:get_value(main, "x") +
				  st:get_value(main, "i")}),
		  begin
		    st:put_value({main, "j"}, {int, 0}),
		    for(fun () ->
				st:get_value(main, "j") =<
				  st:get_value(main, "n")
			end,
			fun () ->
				st:put_value({main, "j"},
					     {int, st:get_value(main, "j") + 1})
			end,
			fun () ->
				st:put_value({main, "y"},
					     {int,
					      st:get_value(main, "x") +
						st:get_value(main, "j")})
			end),
		    st:delete(main, "j")
		  end
	  end),
      st:delete(main, "i")
    end,
    io:format("~p~n", [st:get_value(main, "x")]),
    io:format("~p~n", [st:get_value(main, "y")]),
    st:get_old_stack(main),
    st:destroy().

