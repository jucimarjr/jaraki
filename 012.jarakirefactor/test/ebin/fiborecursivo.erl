-module(fiborecursivo).

-compile(export_all).

-import(loop, [for/3, while/2]).

fibo(V_n) ->
    st:get_new_stack(fibo),
    st:put_value({fibo, "n"}, {int, V_n}),
    st:put_value({fibo, "f"}, {int, 0}),
    case st:get_value(fibo, "n") == 0 of
      true -> st:put_value({fibo, "f"}, {int, 0});
      false ->
	  case st:get_value(fibo, "n") == 1 of
	    true -> st:put_value({fibo, "f"}, {int, 1});
	    false ->
		case st:get_value(fibo, "n") > 1 of
		  true ->
		      st:put_value({fibo, "f"},
				   {int,
				    st:return_function(fun () ->
							       fibo(st:get_value(fibo,
										 "n")
								      - 1)
						       end,
						       fibo,
						       [st:get_value(fibo, "n")
							  - 1])
				      +
				      st:return_function(fun () ->
								 fibo(st:get_value(fibo,
										   "n")
									- 2)
							 end,
							 fibo,
							 [st:get_value(fibo,
								       "n")
							    - 2])});
		  false -> no_operation
		end
	  end
    end,
    begin
      Return = st:get_value(fibo, "f"),
      st:get_old_stack(fibo),
      Return
    end.

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"}, {'String', V_args}),
    st:put_value({main, "n"}, {int, 100}),
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
		  st:put_value({main, "a"},
			       {int,
				st:return_function(fun () ->
							   fibo(st:get_value(main,
									     "i"))
						   end,
						   fibo,
						   [st:get_value(main, "i")])}),
		  io:format("~p~n", [st:get_value(main, "a")])
	  end),
      st:delete(main, "i")
    end,
    st:get_old_stack(main),
    st:destroy().

