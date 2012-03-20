-module(testandofor7).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:put({main, "Args"}, {'String', V_Args}),
    st:put({main, "s"}, {float, 0}),
    st:put({main, "denominador"}, {int, 1}),
    st:put({main, "numerador"}, {int, 1}),
    begin
      st:put({main, "i"}, {int, 1}),
      for(fun () -> st:get(main, "i") =< 10 end,
	  fun () ->
		  st:put({main, "i"}, {int, st:get(main, "i") + 1})
	  end,
	  fun () ->
		  io:format("~p", [st:get(main, "numerador")]),
		  io:format("~s", ["/"]),
		  io:format("~p", [st:get(main, "denominador")]),
		  io:format("~s", [" , "]),
		  st:put({main, "denominador"},
			 {int,
			  st:get(main, "denominador") + st:get(main, "i")}),
		  st:put({main, "numerador"},
			 {int, st:get(main, "numerador") * st:get(main, "i")}),
		  st:put({main, "s"},
			 {float,
			  st:get(main, "s") +
			    st:get(main, "numerador") /
			      st:get(main, "denominador")})
	  end),
      st:delete(main, "i")
    end,
    io:format("~p~n", [st:get(main, "s")]).

