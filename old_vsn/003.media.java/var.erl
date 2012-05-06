-module(var).

-compile(export_all).

main(Args) ->
    Var_a1 = 1,
    io:format("~p~n", Var_a1),
    io:format("Hello World~n"),
    Var_a2 = 2,
    io:format("~p", Var_a2),
    io:format("Hello World").

