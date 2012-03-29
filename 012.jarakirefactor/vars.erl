-module(vars).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:put({main, "Args"}, {'String', V_Args}),
    begin
      st:put({main, "b"}, {int, 3}),
      st:put({main, "c"}, {int, 4})
    end,
    st:put({main, "e"}, {int, 4}),
    st:put({main, "c"}, {int, 2}),
    io:format("~p~n", [st:get(main, "b")]),
    io:format("~s~n", ["Hello World"]),
    io:format("~p", [st:get(main, "c")]),
    io:format("~s", ["Hello World"]),
    io:format("~p", [st:get(main, "e")]).

