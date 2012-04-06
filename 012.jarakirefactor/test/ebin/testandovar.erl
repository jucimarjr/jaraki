-module(testandovar).

-compile(export_all).

-import(loop, [for/3, while/2]).

foo(V_x, V_y) ->
    st:get_new_stack(foo),
    st:put_value({foo, "x"}, {float, V_x}),
    st:put_value({foo, "y"}, {float, V_y}),
    st:put_value({foo, "r"},
		 {float,
		  (st:get_value(foo, "x") + st:get_value(foo, "y")) / 2}),
    begin
      Return = st:get_value(foo, "r"),
      st:get_old_stack(foo),
      Return
    end.

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"}, {'String', V_args}),
    st:put_value({main, "a"}, {float, 10}),
    st:put_value({main, "b"}, {float, 5}),
    st:put_value({main, "x"},
		 {float,
		  st:return_function(fun () ->
					     foo(st:get_value(main, "a"),
						 st:get_value(main, "b"))
				     end,
				     foo,
				     [st:get_value(main, "a"),
				      st:get_value(main, "b")])}),
    io:format("~f~n", [st:get_value(main, "x")]),
    st:get_old_stack(main),
    st:destroy().

