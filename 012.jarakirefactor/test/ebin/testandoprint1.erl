-module(testandoprint1).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"}, {'String', V_args}),
    st:put_value({main, "i"}, {int, 1}),
    st:put_value({main, "j"}, {int, 1}),
    io:format("~s~p~p",
	      ["Texto", st:get_value(main, "i"),
	       st:get_value(main, "j")]),
    io:format("~s~p~p~n",
	      ["Texto", st:get_value(main, "i"),
	       st:get_value(main, "j")]),
    st:get_old_stack(main),
    st:destroy().

