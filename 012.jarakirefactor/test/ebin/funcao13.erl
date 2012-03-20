-module(funcao13).

-compile(export_all).

-import(loop, [for/3, while/2]).

imprimeVariavel() ->
    st:put({imprimeVariavel, "a"}, {int, 5}),
    io:format("~p~n", [st:get(imprimeVariavel, "a")]).

main(V_Args) ->
    st:new(),
    st:put({main, "Args"}, {'String', V_Args}),
    imprimeVariavel().

