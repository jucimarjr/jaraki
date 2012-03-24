-module(funcao20).

-compile(export_all).

-import(loop, [for/3, while/2]).

imprimeVariavel(V_a) ->
    st:put({imprimeVariavel, "a"}, {int, V_a}),
    io:format("~s", ["O valor de a: "]),
    io:format("~p~n", [st:get(imprimeVariavel, "a")]).

main(V_Args) ->
    st:new(),
    st:put({main, "Args"}, {'String', V_Args}),
    st:put({main, "x"}, {int, 5}),
    imprimeVariavel(st:get(main, "x")).

