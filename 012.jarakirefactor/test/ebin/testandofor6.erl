-module(testandofor6).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "Args"}, {'String', V_Args}),
    st:put_value({main, "anterior"}, {int, 0}),
    st:put_value({main, "proximo"}, {int, 1}),
    st:put_value({main, "temp"}, {int, 0}),
    st:put_value({main, "n"}, {int, 10}),
    begin
      st:put_value({main, "i"}, {int, 1}),
      for(fun () ->
		  st:get_value(main, "i") =< st:get_value(main, "n")
	  end,
	  fun () ->
		  st:put_value({main, "i"},
			       {int, st:get_value(main, "i") + 1})
	  end,
	  fun () ->
		  io:format("~p", [st:get_value(main, "anterior")]),
		  io:format("~s", [", "]),
		  st:put_value({main, "temp"},
			       {int, st:get_value(main, "anterior")}),
		  st:put_value({main, "anterior"},
			       {int, st:get_value(main, "proximo")}),
		  st:put_value({main, "proximo"},
			       {int,
				st:get_value(main, "temp") +
				  st:get_value(main, "proximo")})
	  end),
      st:delete(main, "i")
    end,
    st:get_old_stack(main),
    st:destroy().

