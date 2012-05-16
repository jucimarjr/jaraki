-module(testinc1).

-compile(export_all).

-import(loop, [for/3, while/2]).

-import(vector, [new/1, get_vector/1]).

-import(randomLib, [function_random/2]).

testInc(V_a) ->
    st:get_new_stack(testInc),
    st:put_value({testInc, "a"}, {int, V_a}),
    io:format("~p~n", [st:get_value(testInc, "a")]),
    st:get_old_stack(testInc).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"},
		 {{array, 'String'}, V_args}),
    st:put_value({main, "i"}, {int, trunc(1)}),
    st:put_value({main, "i"},
		 {int, trunc(st:get_value(main, "i") + 1)}),
    st:return_function(fun () ->
			       testInc(st:get_value(main, "i"))
		       end,
		       testInc, [st:get_value(main, "i")]),
    st:get_old_stack(main),
    st:destroy().

