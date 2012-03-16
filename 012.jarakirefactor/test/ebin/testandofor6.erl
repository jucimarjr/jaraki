-module(testandofor6).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:put({main, "Args"}, {'String', V_Args}),
    st:put({main, "anterior"}, {int, 0}),
    st:put({main, "proximo"}, {int, 1}),
    st:put({main, "temp"}, {int, 0}),
    st:put({main, "n"}, {int, 10}),
    begin
      st:put({main, "i"}, {int, 1}),
      for(fun () -> st:get(main, "i") =< st:get(main, "n")
	  end,
	  fun () ->
		  st:put({main, "i"}, {int, st:get(main, "i") + 1})
	  end,
	  fun () ->
		  io:format("~p", [st:get(main, "anterior")]),
		  io:format("~s", [", "]),
		  st:put({main, "temp"}, {int, st:get(main, "anterior")}),
		  st:put({main, "anterior"},
			 {int, st:get(main, "proximo")}),
		  st:put({main, "proximo"},
			 {int, st:get(main, "temp") + st:get(main, "proximo")})
	  end),
      st:delete(main, "i")
    end.

