-module(testandovar).

-compile(export_all).

-import(loop, [for/3, while/2]).

foo(V_x, V_y) ->
    st:put({foo, "x"}, {float, V_x}),
    st:put({foo, "y"}, {float, V_y}),
    st:put({foo, "r"},
	   {float, (st:get(foo, "x") + st:get(foo, "y")) / 2}),
    st:get(foo, "r").

main(V_args) ->
    st:new(),
    st:put({main, "args"}, {'String', V_args}),
    st:put({main, "a"}, {float, 10}),
    st:put({main, "b"}, {float, 5}),
    st:put({main, "x"},
	   {float, foo(st:get(main, "a"), st:get(main, "b"))}),
    io:format("~p~n", [st:get(main, "x")]).

