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
			Fun1 = fun () -> fibo(st:get(fibo, "n") -1) end,
			Fun2 = fun () -> fibo(st:get(fibo, "n") -2) end,			      
			st:put({fibo, "f"},
			     	{
					int,
					get_return(Fun1, fibo, [st:get(fibo, "n") -1]) +
					get_return(Fun2, fibo, [st:get(fibo, "n") -2])
				});
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
    st:put({main, "n"}, {int, 50}),
    begin
      st:put({main, "i"}, {int, 0}),
      for(fun () -> st:get(main, "i") < st:get(main, "n") end,
	  fun () ->
		  st:put({main, "i"}, {int, st:get(main, "i") + 1})
	  end,
	  fun () ->
		  Fun1 = fun () -> fibo(st:get(main, "i")) end,
		  st:put({main, "a"}, {int, get_return(Fun1, fibo, [st:get(main, "i")])}),
		  io:format("~p~n", [st:get(main, "a")])
	  end),
      st:delete(main, "i"),
      st:get_old_stack(main),
      st:destroy()		
    end.

get_return(Fun, Scope, Parameters) ->
	case st:get_value(Scope, Parameters) of 
	  {ok, Return} -> 
		Return;
	  no_value -> 
		Return = Fun(),
		st:put_value({Scope, Parameters}, Return),
		Return
	end.
