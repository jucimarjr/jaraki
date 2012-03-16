-module(testandofor5).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:put({main, "Args"}, {'String', V_Args}),
    st:put({main, "n"}, {int, 5}),
    st:put({main, "x"}, {int, 0}),
    begin
      st:put({main, "i"}, {int, 0}),
      for(fun () -> st:get(main, "i") =< st:get(main, "n")
	  end,
	  fun () ->
		  st:put({main, "i"}, {int, st:get(main, "i") + 1})
	  end,
	  fun () ->
		  io:format("~s",
			    ["Estou contando e calculando dentro o "
			     "for :D "]),
		  io:format("~p~n", [st:get(main, "i")]),
		  st:put({main, "x"},
			 {int, st:get(main, "x") + st:get(main, "i")}),
		  io:format("~p~n", [st:get(main, "x")])
	  end),
      st:delete(main, "i")
    end.

