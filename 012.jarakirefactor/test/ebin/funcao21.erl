-module(funcao21).

-compile(export_all).

-import(loop, [for/3, while/2]).

quadrado(V_a) ->
    st:get_new_stack(quadrado),
    st:put_value({quadrado, "a"}, {int, V_a}),
    st:put_value({quadrado, "a"},
		 {int,
		  st:get_value(quadrado, "a") *
		    st:get_value(quadrado, "a")}),
    io:format("~s", ["O valor de a ao quadrado: "]),
    io:format("~p~n", [st:get_value(quadrado, "a")]).

cubo(V_a) ->
    st:get_new_stack(cubo),
    st:put_value({cubo, "a"}, {int, V_a}),
    st:put_value({cubo, "a"},
		 {int,
		  st:get_value(cubo, "a") *
		    (st:get_value(cubo, "a") * st:get_value(cubo, "a"))}),
    io:format("~s", ["O valor de a ao cubo: "]),
    io:format("~p~n", [st:get_value(cubo, "a")]).

main(V_Args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "Args"}, {'String', V_Args}),
    st:put_value({main, "x"}, {int, 5}),
    st:return_function(fun () ->
			       quadrado(st:get_value(main, "x"))
		       end,
		       quadrado, [st:get_value(main, "x")]),
    st:return_function(fun () ->
			       cubo(st:get_value(main, "x"))
		       end,
		       cubo, [st:get_value(main, "x")]),
    st:get_old_stack(main),
    st:destroy().

