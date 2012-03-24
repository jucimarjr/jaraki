-module(testandowhile8).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:put({main, "args"}, {'String', V_args}),
    st:put({main, "i"}, {int, 1}),
    st:put({main, "j"}, {int, 1}),
    while(fun () -> st:get(main, "i") < 10 end,
	  fun () ->
		  io:format("~s~p~n",
			    ["1 - Estou dentro do 1o while!!",
			     st:get(main, "i")]),
		  while(fun () -> st:get(main, "j") < 10 end,
			fun () ->
				io:format("~s~p~n",
					  ["2 - Estou dentro do 2o while!!",
					   st:get(main, "j")]),
				st:put({main, "j"},
				       {int, st:get(main, "j") + 1})
			end),
		  st:put({main, "i"}, {int, st:get(main, "i") + 1})
	  end).

