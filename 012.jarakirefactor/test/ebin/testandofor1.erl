-module(testandofor1).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "Args"}, {'String', V_Args}),
    begin
      st:put_value({main, "i"}, {int, 0}),
      for(fun () -> st:get_value(main, "i") < 50 end,
	  fun () ->
		  st:put_value({main, "i"},
			       {int, st:get_value(main, "i") + 1})
	  end,
	  fun () -> io:format("~s~n", ["Estou dentro do for :D"])
	  end),
      st:delete(main, "i")
    end,
    st:get_old_stack(main),
    st:destroy().

