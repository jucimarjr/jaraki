-module(vetor04).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"}, {'String', V_args}),
    begin
      begin
	st:put_value({main, "vet"},
		     {int, array:set(0, 1, array:new())}),
	st:put_value({main, "vet"},
		     {int, array:set(1, 2, st:get_value(main, "vet"))}),
	st:put_value({main, "vet"},
		     {int, array:set(2, 3, st:get_value(main, "vet"))}),
	st:put_value({main, "vet"},
		     {int, array:set(3, 4, st:get_value(main, "vet"))}),
	st:put_value({main, "vet"},
		     {int, array:set(4, 5, st:get_value(main, "vet"))})
      end
    end,
    begin
      st:put_value({main, "i"}, {int, 1}),
      for(fun () -> st:get_value(main, "i") < 5 end,
	  fun () ->
		  st:put_value({main, "i"},
			       {int, st:get_value(main, "i") + 1})
	  end,
	  fun () ->
		  io:format("~p~n",
			    [array:get(st:get_value(main, "i"),
				       st:get_value(main, "vet"))])
	  end),
      st:delete(main, "i")
    end,
    st:get_old_stack(main),
    st:destroy().

