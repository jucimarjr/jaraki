-module(testerecursao2).

-compile(export_all).

-import(loop, [for/3, while/2]).

fat(V_n) ->
    st:get_new_stack(fat),
    st:put({fat, "n"}, {long, V_n}),
    st:put({fat, "f"}, {long, 0}),
    case st:get(fat, "n") == 0 of
      true -> st:put({fat, "f"}, {long, 1});
      false ->
	  case st:get(fat, "n") == 1 of
	    true -> st:put({fat, "f"}, {long, 1});
	    false ->
		st:put({fat, "f"},
		       {long, st:get(fat, "n") * fat(st:get(fat, "n") - 1)})
	  end
    end,
    Return = st:get(fat, "f"),
    st:get_old_stack(fat),
    Return.	

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put({main, "args"}, {'String', V_args}),
    st:put({main, "n"}, {int, 50}),
    st:put({main, "a"}, {long, fat(st:get(main, "n"))}),
    io:format("~p~n", [st:get(main, "a")]),
    st:get_old_stack(main).
