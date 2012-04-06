-module(testandoprint2).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"}, {'String', V_args}),
    st:put_value({main, "i"}, {int, 1}),
    io:format("~s", ["Texto"]),
    io:format("~p~n", [st:get_value(main, "i")]),
    st:get_old_stack(main),
    st:destroy().

