-module(testandofor4).

-compile(export_all).

main(V_Args) ->
    Var_n1 = 5,
    [begin
       io:format("Estou contando dentro o for :D "),
       io:format("~p~n", [V_i])
     end
     || V_i <- lists:seq(0, Var_n1 - 1)].

