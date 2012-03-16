-module(testandowhile4).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:put({main, "args"}, {'String', V_args}),
    st:put({main, "i"}, {int, 1}),
    st:put({main, "n"}, {int, 20}),
    while(fun () -> st:get(main, "i") =< st:get(main, "n")
	  end,
	  fun () ->
		  io:format("~s~n", ["Estou dentro do while!!"]),
		  io:format("~p~n", [st:get(main, "i")]),
		  st:put({main, "i"}, {int, st:get(main, "i") + 1})
	  end).

