-module(hello).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "Args"}, {'String', V_Args}),
    io:format("~s~n", ["Hello World"]),
    st:get_old_stack(main),
    st:destroy().

