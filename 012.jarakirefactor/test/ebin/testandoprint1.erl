-module(testandoprint1).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:put({main, "args"}, {'String', V_args}),
    st:put({main, "i"}, {int, 1}),
    st:put({main, "j"}, {int, 1}),
    io:format("~s~p~p",
	      ["Texto", st:get(main, "i"), st:get(main, "j")]),
    io:format("~s~p~p~n",
	      ["Texto", st:get(main, "i"), st:get(main, "j")]).

