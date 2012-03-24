-module(testandoprint2).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:put({main, "args"}, {'String', V_args}),
    st:put({main, "i"}, {int, 1}),
    io:format("~s", ["Texto"]),
    io:format("~p~n", [st:get(main, "i")]).

