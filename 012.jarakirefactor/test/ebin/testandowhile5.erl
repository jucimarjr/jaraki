-module(testandowhile5).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"}, {'String', V_args}),
    st:put_value({main, "i"}, {int, 1}),
    st:put_value({main, "n"}, {int, 20}),
    st:put_value({main, "x"}, {int, 0}),
    while(fun () ->
		  st:get_value(main, "i") =< st:get_value(main, "n")
	  end,
	  fun () ->
		  io:format("~s",
			    ["Estou contando e calculando dentro do "
			     "while :D "]),
		  io:format("~p~n", [st:get_value(main, "i")]),
		  st:put_value({main, "x"},
			       {int,
				st:get_value(main, "x") +
				  st:get_value(main, "i")}),
		  io:format("~p~n", [st:get_value(main, "x")]),
		  st:put_value({main, "i"},
			       {int, st:get_value(main, "i") + 1})
	  end),
    st:get_old_stack(main),
    st:destroy().

