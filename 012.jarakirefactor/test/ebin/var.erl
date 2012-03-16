-module(var).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:put({main, "Args"}, {'String', V_Args}),
    st:put({main, "a"}, {int, 1}),
    io:format("~p~n", [st:get(main, "a")]),
    io:format("~s~n", ["Hello World"]),
    st:put({main, "a"}, {int, 2}),
    io:format("~p", [st:get(main, "a")]),
    io:format("~s", ["Hello World"]).

