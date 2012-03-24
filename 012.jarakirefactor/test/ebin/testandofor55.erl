-module(testandofor55).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:put({main, "Args"}, {'String', V_Args}),
    st:put({main, "n"}, {int, 5}),
    st:put({main, "x"}, {int, 0}),
    st:put({main, "y"}, {int, 0}),
    begin
      st:put({main, "i"}, {int, 0}),
      for(fun () -> st:get(main, "i") =< st:get(main, "n")
	  end,
	  fun () ->
		  st:put({main, "i"}, {int, st:get(main, "i") + 1})
	  end,
	  fun () ->
		  st:put({main, "x"},
			 {int, st:get(main, "x") + st:get(main, "i")}),
		  begin
		    st:put({main, "j"}, {int, 0}),
		    for(fun () -> st:get(main, "j") =< st:get(main, "n")
			end,
			fun () ->
				st:put({main, "j"},
				       {int, st:get(main, "j") + 1})
			end,
			fun () ->
				st:put({main, "y"},
				       {int,
					st:get(main, "x") + st:get(main, "j")})
			end),
		    st:delete(main, "j")
		  end
	  end),
      st:delete(main, "i")
    end,
    io:format("~p~n", [st:get(main, "x")]),
    io:format("~p~n", [st:get(main, "y")]).

