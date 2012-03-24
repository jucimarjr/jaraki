-module(funcao12).

-compile(export_all).

-import(loop, [for/3, while/2]).

imprime() ->
    io:format("~s", ["Hello "]),
    io:format("~s~n", ["World"]).

main(V_Args) ->
    st:new(),
    st:put({main, "Args"}, {'String', V_Args}),
    imprime().

