-module(vetor02).

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
    begin st:put_value({main, "a"}, {int, 1}) end,
    io:format("~p~n", [st:get_value(main, "a")]),
    io:format("~p",
	      [array:get(2, st:get_value(main, "vet"))]),
    io:format("~p~n",
	      [array:get(4, st:get_value(main, "vet"))]),
    io:format("~p~n",
	      [array:get(st:get_value(main, "a"),
			 st:get_value(main, "vet"))]),
    st:get_old_stack(main),
    st:destroy().

