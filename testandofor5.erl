-module(testandofor5).

-compile(export_all).

-import(loop, [for/3, while/2]).

-import(vector, [new/1, get_vector/1]).

-import(randomLib, [function_random/2]).

main(V_Args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "Args"},
		 {{array, 'String'}, V_Args}),
    st:put_value({main, "n"}, {int, trunc(5)}),
    st:put_value({main, "x"}, {int, trunc(0)}),
    begin
      st:put_value({main, "i"}, {int, 0}),
      for(fun () ->
		  st:get_value(main, "i") =< st:get_value(main, "n")
	  end,
	  fun () ->
		  st:put_value({main, "i"},
			       {int, trunc(st:get_value(main, "i") + 1)})
	  end,
	  fun () ->
		  io:format("~s",
			    ["Estou contando e calculando dentro o "
			     "for :D "]),
		  io:format("~p~n", [st:get_value(main, "i")]),
		  st:put_value({main, "x"},
			       {int,
				trunc(st:get_value(main, "x") +
					st:get_value(main, "i"))}),
		  io:format("~p~n", [st:get_value(main, "x")])
	  end),
      st:delete(main, "i")
    end,
    st:destroy().

