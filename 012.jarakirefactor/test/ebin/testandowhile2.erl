-module(testandowhile2).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:put({main, "args"}, {'String', V_args}),
    st:put({main, "i"}, {int, 1}),
    while(fun () -> st:get(main, "i") < 20 end,
	  fun () ->
		  io:format("~s~n", ["1 - Estou dentro do while!!"]),
		  io:format("~s~n", ["2 - Estou dentro do while!!"]),
		  st:put({main, "i"}, {int, st:get(main, "i") + 1})
	  end).

