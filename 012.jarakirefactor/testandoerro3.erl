-module(testandoerro3).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:put({main, "args"}, {'String', V_args}),
    begin st:put({main, "d"}, {float, 7}) end,
    st:put({main, "a"}, {float, 10}),
    st:put({main, "b"}, {float, 5}),
    st:put({main, "c"},
	   {int, (st:get(main, "a") + st:get(main, "b")) / 2}),
    io:format("~s~n", ["A media eh: "]),
    io:format("~p~n", [st:get(main, "c")]),
    io:format("~p~n", [st:get(main, "d")]).

