-module(funcao16).

-compile(export_all).

-import(loop, [for/3, while/2]).

imprimeVariavel() ->
    st:get_new_stack(imprimeVariavel),
    st:put_value({imprimeVariavel, "a"}, {int, 5}),
    io:format("~s", ["Valor de a: "]),
    io:format("~p~n", [st:get_value(imprimeVariavel, "a")]).

imprime() ->
    st:get_new_stack(imprime),
    io:format("~s~n", ["Hello World"]).

testandoFor() ->
    st:get_new_stack(testandoFor),
    st:put_value({testandoFor, "a"}, {int, 8}),
    begin
      st:put_value({testandoFor, "i"}, {int, 0}),
      for(fun () -> st:get_value(testandoFor, "i") =< 5 end,
	  fun () ->
		  st:put_value({testandoFor, "i"},
			       {int, st:get_value(testandoFor, "i") + 1})
	  end,
	  fun () ->
		  io:format("~s", ["Valor de a: "]),
		  io:format("~p~n", [st:get_value(testandoFor, "a")]),
		  st:put_value({testandoFor, "a"},
			       {int, st:get_value(testandoFor, "a") + 1}),
		  io:format("~s", ["Iteracao: "]),
		  io:format("~p~n", [st:get_value(testandoFor, "i")])
	  end),
      st:delete(testandoFor, "i")
    end.

testandoIf() ->
    st:get_new_stack(testandoIf),
    st:put_value({testandoIf, "a"}, {int, 3}),
    case st:get_value(testandoIf, "a") < 2 of
      true ->
	  io:format("~p~n", [st:get_value(testandoIf, "a")]);
      false -> no_operation
    end.

main(V_Args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "Args"}, {'String', V_Args}),
    st:return_function(fun () -> imprime() end, imprime,
		       []),
    st:return_function(fun () -> imprimeVariavel() end,
		       imprimeVariavel, []),
    st:return_function(fun () -> testandoFor() end,
		       testandoFor, []),
    st:return_function(fun () -> testandoIf() end,
		       testandoIf, []),
    st:get_old_stack(main),
    st:destroy().

