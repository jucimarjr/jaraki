-module(testerecursao6).

-compile(export_all).

-import(loop, [for/3, while/2]).

x(V_m) ->
    st:get_new_stack(x),
    st:put({x, "m"}, {long, V_m}),
    st:put({x, "x"}, {long, 0}),
    case st:get(x, "m") =< 0 of
      true -> st:put({x, "x"}, {long, st:get(x, "m")});
      false ->
	  st:put({x, "x"},
		 {long,
		  x(st:get(x, "m") - 1) +
		    (x(st:get(x, "m") - 2) + x(st:get(x, "m") - 3))})
    end,
    Return = st:get(x, "x"),
    st:get_old_stack(x),
    Return.

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put({main, "args"}, {'String', V_args}),
    st:put({main, "m"}, {int, 25}),
    st:put({main, "a"}, {long, x(st:get(main, "m"))}),
    io:format("~p~n", [st:get(main, "a")]),
    st:get_old_stack(main).

