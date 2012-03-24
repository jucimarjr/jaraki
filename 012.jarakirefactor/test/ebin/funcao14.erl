-module(funcao14).

-compile(export_all).

-import(loop, [for/3, while/2]).

imprimeVariavel() ->
    st:put({imprimeVariavel, "a"}, {int, 5}),
    case st:get(imprimeVariavel, "a") < 2 of
      true ->
	  io:format("~p~n", [st:get(imprimeVariavel, "a")]);
      false -> no_operation
    end.

main(V_Args) ->
    st:new(),
    st:put({main, "Args"}, {'String', V_Args}),
    imprimeVariavel().

