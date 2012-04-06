-module(testandofor7).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "Args"}, {'String', V_Args}),
    st:put_value({main, "s"}, {float, 0}),
    st:put_value({main, "denominador"}, {int, 1}),
    st:put_value({main, "numerador"}, {int, 1}),
    begin
      st:put_value({main, "i"}, {int, 1}),
      for(fun () -> st:get_value(main, "i") =< 10 end,
	  fun () ->
		  st:put_value({main, "i"},
			       {int, st:get_value(main, "i") + 1})
	  end,
	  fun () ->
		  io:format("~p", [st:get_value(main, "numerador")]),
		  io:format("~s", ["/"]),
		  io:format("~p", [st:get_value(main, "denominador")]),
		  io:format("~s", [" , "]),
		  st:put_value({main, "denominador"},
			       {int,
				st:get_value(main, "denominador") +
				  st:get_value(main, "i")}),
		  st:put_value({main, "numerador"},
			       {int,
				st:get_value(main, "numerador") *
				  st:get_value(main, "i")}),
		  st:put_value({main, "s"},
			       {float,
				st:get_value(main, "s") +
				  st:get_value(main, "numerador") /
				    st:get_value(main, "denominador")})
	  end),
      st:delete(main, "i")
    end,
    io:format("~f~n", [st:get_value(main, "s")]),
    st:get_old_stack(main),
    st:destroy().

