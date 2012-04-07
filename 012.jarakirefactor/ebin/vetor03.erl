-module(vetor03).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"}, {'String', V_args}),
    begin
      begin
	st:put_value({main, "vet"},
		     {int, array:set(0, 10, array:new())}),
	st:put_value({main, "vet"},
		     {int, array:set(1, 9, st:get_value(main, "vet"))}),
	st:put_value({main, "vet"},
		     {int, array:set(2, 8, st:get_value(main, "vet"))}),
	st:put_value({main, "vet"},
		     {int, array:set(3, 7, st:get_value(main, "vet"))}),
	st:put_value({main, "vet"},
		     {int, array:set(4, 6, st:get_value(main, "vet"))})
      end
    end,
    begin
      st:put_value({main, "i"}, {int, 0}),
      for(fun () -> st:get_value(main, "i") =< 3 end,
	  fun () ->
		  st:put_value({main, "i"},
			       {int, st:get_value(main, "i") + 1})
	  end,
	  fun () -> io:format("~p~n", [st:get_value(main, "i")])
	  end),
      st:delete(main, "i")
    end,
    io:format("~p~n",
	      [array:get(3, st:get_value(main, "vet"))]),
    st:get_old_stack(main),
    st:destroy().

