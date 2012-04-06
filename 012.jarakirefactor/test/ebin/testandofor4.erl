-module(testandofor4).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "Args"}, {'String', V_Args}),
    st:put_value({main, "n"}, {int, 5}),
    begin
      st:put_value({main, "i"}, {int, 0}),
      for(fun () ->
		  st:get_value(main, "i") < st:get_value(main, "n")
	  end,
	  fun () ->
		  st:put_value({main, "i"},
			       {int, st:get_value(main, "i") + 1})
	  end,
	  fun () ->
		  io:format("~s", ["Estou contando dentro o for :D "]),
		  io:format("~p~n", [st:get_value(main, "i")])
	  end),
      st:delete(main, "i")
    end,
    st:get_old_stack(main),
    st:destroy().

