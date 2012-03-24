-module(funcao15).

-compile(export_all).

-import(loop, [for/3, while/2]).

imprimeVariavel() ->
    st:put({imprimeVariavel, "a"}, {int, 5}),
    begin
      st:put({imprimeVariavel, "i"}, {int, 0}),
      for(fun () -> st:get(imprimeVariavel, "i") < 3 end,
	  fun () ->
		  st:put({imprimeVariavel, "i"},
			 {int, st:get(imprimeVariavel, "i") + 1})
	  end,
	  fun () ->
		  io:format("~s", ["Valor de a: "]),
		  io:format("~p~n", [st:get(imprimeVariavel, "a")]),
		  st:put({imprimeVariavel, "a"},
			 {int, st:get(imprimeVariavel, "a") + 1}),
		  io:format("~s", ["Iteracao: "]),
		  io:format("~p~n", [st:get(imprimeVariavel, "i")])
	  end),
      st:delete(imprimeVariavel, "i")
    end,
    io:format("~s", ["Valor de a: "]),
    io:format("~p~n", [st:get(imprimeVariavel, "a")]).

main(V_Args) ->
    st:new(),
    st:put({main, "Args"}, {'String', V_Args}),
    imprimeVariavel().

