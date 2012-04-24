-module(random1).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "Args"},
		 {{array, 'String'}, V_Args}),
    io:format("~s~n",
	      ["Generating 10 random integers in range "
	       "0..99."]),
    begin
      st:put_value({main, "idx"}, {int, 1}),
      for(fun () -> st:get_value(main, "idx") =< 10 end,
	  fun () ->
		  st:put_value({main, "idx"},
			       {int, trunc(st:get_value(main, "idx") + 1)})
	  end,
	  fun () ->
		  st:put_value({main, "randomInt"},
			       {int, trunc(random:uniform(100))}),
		  io:format("~s~p~n",
			    ["Generated : ", st:get_value(main, "randomInt")])
	  end),
      st:delete(main, "idx")
    end,
    io:format("~s~n", ["Done."]),
    st:get_old_stack(main),
    st:destroy().

