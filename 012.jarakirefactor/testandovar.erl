-module(testandovar).

-compile(export_all).

-import(loop, [for/3, while/2]).

foo(Var_x1, Var_y1) ->
    st:insert({"r", (st:get("x") + st:get("y")) / 2}),
    st:get("r").

main(Var_args1) ->
    st:new(),
    st:insert({"a", 10}),
    st:insert({"b", 5}),
    st:insert({"d", foo(st:get("a"), st:get("b"))}),
    io:format("~p~n", [st:get("d")]).

