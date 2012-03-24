-module(testandofor3).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:put({main, "Args"}, {'String', V_Args}),
    begin
      st:put({main, "i"}, {int, 0}),
      for(fun () -> st:get(main, "i") < 50 end,
	  fun () ->
		  st:put({main, "i"}, {int, st:get(main, "i") + 1})
	  end,
	  fun () ->
		  io:format("~s", ["Estou contando dentro o for :D "]),
		  io:format("~p~n", [st:get(main, "i")])
	  end),
      st:delete(main, "i")
    end.

