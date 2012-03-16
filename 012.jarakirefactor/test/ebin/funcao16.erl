-module(funcao16).

-compile(export_all).

-import(loop, [for/3, while/2]).

imprimeVariavel() ->
    st:put({imprimeVariavel, "a"}, {int, 5}),
    io:format("~s", ["Valor de a: "]),
    io:format("~p~n", [st:get(imprimeVariavel, "a")]).

imprime() -> io:format("~s~n", ["Hello World"]).

testandoFor() ->
    st:put({testandoFor, "a"}, {int, 8}),
    begin
      st:put({testandoFor, "i"}, {int, 0}),
      for(fun () -> st:get(testandoFor, "i") =< 5 end,
	  fun () ->
		  st:put({testandoFor, "i"},
			 {int, st:get(testandoFor, "i") + 1})
	  end,
	  fun () ->
		  io:format("~s", ["Valor de a: "]),
		  io:format("~p~n", [st:get(testandoFor, "a")]),
		  st:put({testandoFor, "a"},
			 {int, st:get(testandoFor, "a") + 1}),
		  io:format("~s", ["Iteracao: "]),
		  io:format("~p~n", [st:get(testandoFor, "i")])
	  end),
      st:delete(testandoFor, "i")
    end.

testandoIf() ->
    st:put({testandoIf, "a"}, {int, 3}),
    case st:get(testandoIf, "a") < 2 of
      true -> io:format("~p~n", [st:get(testandoIf, "a")]);
      false -> no_operation
    end.

main(V_Args) ->
    st:new(),
    st:put({main, "Args"}, {'String', V_Args}),
    imprime(),
    imprimeVariavel(),
    testandoFor(),
    testandoIf().

