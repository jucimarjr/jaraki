-module(vetor04).

-compile(export_all).

-import(loop, [for/3]).
-import(vector, [new/1, get_vector/1]).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"},
		 {{array, 'String'}, V_args}),
    begin
      begin
	st:put_value({main, "vet"},
		     {{array, int}, vector:new(array:from_list([1, 2, 3, 4, 5]))})
      end
    end,
    begin
      st:put_value({main, "i"}, {int, 0}),
      for(fun () -> st:get_value(main, "i") < 5 end,
	  fun () ->
		  st:put_value({main, "i"},
			       {int, trunc(st:get_value(main, "i") + 1)})
	  end,
	  fun () ->
		  io:format("~p~n",
			    [vector:access_array(st:get_value(main, "i"),
				       st:get_value(main, "vet"))
				])
	  end),
      st:delete(main, "i")
    end,
    st:get_old_stack(main),
    st:destroy().
