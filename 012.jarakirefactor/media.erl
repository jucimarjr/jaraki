-module(media).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(Var_Args1) ->
    st:new(),
    st:insert({"a", 10}),
    st:insert({"a", st:get("a") + 1}),
    st:insert({"b", 5}),
    st:insert({"c", (st:get("a") + st:get("b")) / 2}),
    io:format("~s~n", ["A media eh: "]),
    io:format("~p~n", [st:get("c")]).

