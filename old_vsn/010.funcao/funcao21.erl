-module(funcao21).

-compile(export_all).

-import(loop, [for/3, while/2]).

quadrado(Var_a1) ->
    begin
      Var_a2 = Var_a1 * Var_a1, st:insert({"a", Var_a2})
    end,
    io:format("O valor de a ao quadrado: "),
    io:format("~p~n", [Var_a2]).

cubo(Var_a1) ->
    begin
      Var_a2 = Var_a1 * (Var_a1 * Var_a1),
      st:insert({"a", Var_a2})
    end,
    io:format("O valor de a ao cubo: "),
    io:format("~p~n", [Var_a2]).

main(Var_Args1) ->
    st:new(),
    begin Var_x1 = 5, st:insert({"x", Var_x1}) end,
    quadrado(Var_x1),
    cubo(Var_x1).

