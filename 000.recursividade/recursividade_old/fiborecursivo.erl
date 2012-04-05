-module(fiborecursivo).

-compile(export_all).

-import(loop, [for/3, while/2]).

fibo(V_n) ->
    st:get_new_stack(fibo),	
    st:put({fibo, "n"}, {int, V_n}),
    st:put({fibo, "f"}, {int, 0}),
    case st:get(fibo, "n") == 0 of
      true -> st:put({fibo, "f"}, {int, 0});
      false ->
	  case st:get(fibo, "n") == 1 of
	    true -> st:put({fibo, "f"}, {int, 1});
	    false ->
		case st:get(fibo, "n") > 1 of
		  true ->
		      st:put({fibo, "f"},
			     {int,
			      fibo(st:get(fibo, "n") - 1) +
				fibo(st:get(fibo, "n") - 2)});
		  false -> no_operation
		end
	  end
    end,
    
    Return = st:get(fibo, "f"),
    st:get_old_stack(fibo),
    Return.

main(V_args) ->
    st:new(),
    st:get_new_stack(main),	
    st:put({main, "args"}, {'String', V_args}),
    st:put({main, "n"}, {int, 25}),
    begin
      st:put({main, "i"}, {int, 0}),
      for(fun () -> st:get(main, "i") < st:get(main, "n") end,
	  fun () ->
		  st:put({main, "i"}, {int, st:get(main, "i") + 1})
	  end,
	  fun () ->
		  st:put({main, "a"}, {int, fibo(st:get(main, "i"))}),
		  io:format("~p~n", [st:get(main, "a")])
	  end),
      st:delete(main, "i"),
      st:get_old_stack(main),
      st:destroy()		
    end.
