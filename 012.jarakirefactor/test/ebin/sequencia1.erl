-module(sequencia1).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"}, {'String', V_args}),
    io:format("~s~n", ["Hello world!"]),
    st:get_old_stack(main),
    st:destroy().

