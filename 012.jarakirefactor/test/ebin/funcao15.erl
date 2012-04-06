-module(funcao15).

-compile(export_all).

-import(loop, [for/3, while/2]).

imprimeVariavel() ->
    st:get_new_stack(imprimeVariavel),
    st:put_value({imprimeVariavel, "a"}, {int, 5}),
    begin
      st:put_value({imprimeVariavel, "i"}, {int, 0}),
      for(fun () -> st:get_value(imprimeVariavel, "i") < 3
	  end,
	  fun () ->
		  st:put_value({imprimeVariavel, "i"},
			       {int, st:get_value(imprimeVariavel, "i") + 1})
	  end,
	  fun () ->
		  io:format("~s", ["Valor de a: "]),
		  io:format("~p~n", [st:get_value(imprimeVariavel, "a")]),
		  st:put_value({imprimeVariavel, "a"},
			       {int, st:get_value(imprimeVariavel, "a") + 1}),
		  io:format("~s", ["Iteracao: "]),
		  io:format("~p~n", [st:get_value(imprimeVariavel, "i")])
	  end),
      st:delete(imprimeVariavel, "i")
    end,
    io:format("~s", ["Valor de a: "]),
    io:format("~p~n", [st:get_value(imprimeVariavel, "a")]).

main(V_Args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "Args"}, {'String', V_Args}),
    st:return_function(fun () -> imprimeVariavel() end,
		       imprimeVariavel, []),
    st:get_old_stack(main),
    st:destroy().

