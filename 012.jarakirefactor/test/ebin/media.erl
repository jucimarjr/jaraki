-module(media).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "Args"}, {'String', V_Args}),
    st:put_value({main, "a"}, {float, 10}),
    st:put_value({main, "a"},
		 {float, st:get_value(main, "a") + 1}),
    st:put_value({main, "b"}, {float, 5}),
    st:put_value({main, "c"},
		 {float,
		  (st:get_value(main, "a") + st:get_value(main, "b")) /
		    2}),
    io:format("~s~n", ["A media eh: "]),
    io:format("~f~n", [st:get_value(main, "c")]),
    st:get_old_stack(main),
    st:destroy().

