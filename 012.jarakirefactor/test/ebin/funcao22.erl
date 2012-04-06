-module(funcao22).

-compile(export_all).

-import(loop, [for/3, while/2]).

bo(V_a) ->
    st:get_new_stack(bo),
    st:put_value({bo, "a"}, {boolean, V_a}),
    st:put_value({bo, "b"}, {boolean, false}),
    case st:get_value(bo, "a") == true of
      true -> st:put_value({bo, "b"}, {boolean, false});
      false -> st:put_value({bo, "b"}, {boolean, true})
    end,
    begin
      Return = st:get_value(bo, "b"),
      st:get_old_stack(bo),
      Return
    end.

quadrado(V_a) ->
    st:get_new_stack(quadrado),
    st:put_value({quadrado, "a"}, {int, V_a}),
    st:put_value({quadrado, "temp"},
		 {int,
		  st:get_value(quadrado, "a") *
		    st:get_value(quadrado, "a")}),
    begin
      Return = st:get_value(quadrado, "temp"),
      st:get_old_stack(quadrado),
      Return
    end.

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
    st:put_value({main, "t"},
		 {int,
		  st:return_function(fun () ->
					     quadrado(st:get_value(main, "x"))
				     end,
				     quadrado, [st:get_value(main, "x")])}),
    st:return_function(fun () ->
			       cubo(st:get_value(main, "x"))
		       end,
		       cubo, [st:get_value(main, "x")]),
    io:format("~s", ["O valor de a ao quadrado eh: "]),
    io:format("~p~n", [st:get_value(main, "t")]),
    st:put_value({main, "b"},
		 {boolean,
		  st:return_function(fun () -> bo(true) end, bo,
				     [true])}),
    io:format("~s", ["O valor de b ao quadrado eh: "]),
    io:format("~s~n", [st:get_value(main, "b")]),
    st:get_old_stack(main),
    st:destroy().

