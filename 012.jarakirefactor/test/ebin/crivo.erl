-module(crivo).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"}, {'String', V_args}),
    st:put_value({main, "cont"}, {int, 0}),
    st:put_value({main, "n"}, {int, 1000}),
    st:put_value({main, "maior"},
		 {double, math:sqrt(st:get_value(main, "n"))}),
    begin
      st:put_value({main, "i"}, {int, 2}),
      for(fun () ->
		  st:get_value(main, "i") =< st:get_value(main, "n")
	  end,
	  fun () ->
		  st:put_value({main, "i"},
			       {int, st:get_value(main, "i") + 1})
	  end,
	  fun () ->
		  st:put_value({main, "cont"}, {int, 0}),
		  begin
		    st:put_value({main, "j"}, {int, 2}),
		    for(fun () ->
				st:get_value(main, "j") =<
				  st:get_value(main, "maior")
			end,
			fun () ->
				st:put_value({main, "j"},
					     {int, st:get_value(main, "j") + 1})
			end,
			fun () ->
				case st:get_value(main, "i") =/=
				       st:get_value(main, "j")
				    of
				  true ->
				      case st:get_value(main, "i") rem
					     st:get_value(main, "j")
					     == 0
					  of
					true ->
					    st:put_value({main, "cont"},
							 {int,
							  st:get_value(main,
								       "cont")
							    + 1});
					false -> no_operation
				      end;
				  false -> no_operation
				end
			end),
		    st:delete(main, "j")
		  end,
		  case st:get_value(main, "cont") == 0 of
		    true -> io:format("~p~n", [st:get_value(main, "i")]);
		    false -> no_operation
		  end
	  end),
      st:delete(main, "i")
    end,
    st:get_old_stack(main),
    st:destroy().

