-module(testandowhile7).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"}, {'String', V_args}),
    st:put_value({main, "i"}, {int, 1}),
    st:put_value({main, "j"}, {int, 1}),
    while(fun () -> st:get_value(main, "i") < 10 end,
	  fun () ->
		  io:format("~s~n", ["1 - Estou dentro do 1o while!!"]),
		  io:format("~s~n", ["2 - Estou dentro do 1o while!!"]),
		  while(fun () -> st:get_value(main, "j") < 10 end,
			fun () ->
				io:format("~s~n",
					  ["1 - Estou dentro do 2o while!!"]),
				io:format("~s~n",
					  ["2 - Estou dentro do 2o while!!"]),
				st:put_value({main, "j"},
					     {int, st:get_value(main, "j") + 1})
			end),
		  st:put_value({main, "i"},
			       {int, st:get_value(main, "i") + 1})
	  end),
    st:get_old_stack(main),
    st:destroy().

