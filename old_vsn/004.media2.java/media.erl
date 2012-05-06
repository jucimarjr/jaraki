-module(media).

-compile(export_all).

main(Args) ->
    Var_a1 = 10,
    Var_a2 = Var_a1 + 1,
    Var_b1 = 5,
    Var_c1 = (Var_a2 + Var_b1) / 2,
    io:format("A media eh: ~n"),
    io:format("~p~n", [Var_c1]).

