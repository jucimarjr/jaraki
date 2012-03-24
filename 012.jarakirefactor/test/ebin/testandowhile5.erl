-module(testandowhile5).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:put({main, "args"}, {'String', V_args}),
    st:put({main, "i"}, {int, 1}),
    st:put({main, "n"}, {int, 20}),
    st:put({main, "x"}, {int, 0}),
    while(fun () -> st:get(main, "i") =< st:get(main, "n")
	  end,
	  fun () ->
		  io:format("~s",
			    ["Estou contando e calculando dentro do "
			     "while :D "]),
		  io:format("~p~n", [st:get(main, "i")]),
		  st:put({main, "x"},
			 {int, st:get(main, "x") + st:get(main, "i")}),
		  io:format("~p~n", [st:get(main, "x")]),
		  st:put({main, "i"}, {int, st:get(main, "i") + 1})
	  end).

