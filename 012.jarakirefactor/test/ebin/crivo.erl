-module(crivo).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:put({main, "args"}, {'String', V_args}),
    st:put({main, "cont"}, {int, 0}),
    st:put({main, "n"}, {int, 1000}),
    st:put({main, "maior"},
	   {double, math:sqrt(st:get(main, "n"))}),
    begin
      st:put({main, "i"}, {int, 2}),
      for(fun () -> st:get(main, "i") =< st:get(main, "n")
	  end,
	  fun () ->
		  st:put({main, "i"}, {int, st:get(main, "i") + 1})
	  end,
	  fun () ->
		  st:put({main, "cont"}, {int, 0}),
		  begin
		    st:put({main, "j"}, {int, 2}),
		    for(fun () -> st:get(main, "j") =< st:get(main, "maior")
			end,
			fun () ->
				st:put({main, "j"},
				       {int, st:get(main, "j") + 1})
			end,
			fun () ->
				case st:get(main, "i") =/= st:get(main, "j") of
				  true ->
				      case st:get(main, "i") rem
					     st:get(main, "j")
					     == 0
					  of
					true ->
					    st:put({main, "cont"},
						   {int,
						    st:get(main, "cont") + 1});
					false -> no_operation
				      end;
				  false -> no_operation
				end
			end),
		    st:delete(main, "j")
		  end,
		  case st:get(main, "cont") == 0 of
		    true -> io:format("~p~n", [st:get(main, "i")]);
		    false -> no_operation
		  end
	  end),
      st:delete(main, "i")
    end.

