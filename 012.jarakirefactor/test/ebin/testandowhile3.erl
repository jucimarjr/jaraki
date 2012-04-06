-module(testandowhile3).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "Args"}, {'String', V_Args}),
    st:put_value({main, "i"}, {int, 1}),
    while(fun () -> st:get_value(main, "i") < 20 end,
	  fun () ->
		  io:format("~s~n", ["Estou dentro do while :D"]),
		  io:format("~p~n", [st:get_value(main, "i")]),
		  st:put_value({main, "i"},
			       {int, st:get_value(main, "i") + 1})
	  end),
    st:get_old_stack(main),
    st:destroy().

