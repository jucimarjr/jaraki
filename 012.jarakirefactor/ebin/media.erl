-module(media).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:put({main, "Args"}, {'String', V_Args}),
    st:put({main, "a"}, {float, 10}),
    st:put({main, "a"}, {float, st:get(main, "a") + 1}),
    st:put({main, "b"}, {float, 5}),
    st:put({main, "c"},
	   {float, (st:get(main, "a") + st:get(main, "b")) / 2}),
    io:format("~s~n", ["A media eh: "]),
    io:format("~p~n", [st:get(main, "c")]).

