-module(testandowhile3).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:put({main, "Args"}, {'String', V_Args}),
    st:put({main, "i"}, {int, 1}),
    while(fun () -> st:get(main, "i") < 20 end,
	  fun () ->
		  io:format("~s~n", ["Estou dentro do while :D"]),
		  io:format("~p~n", [st:get(main, "i")]),
		  st:put({main, "i"}, {int, st:get(main, "i") + 1})
	  end).

