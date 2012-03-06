-module(funcao22).

-compile(export_all).

-import(loop, [for/3, while/2]).

quadrado(Var_a1) ->
    begin
      Var_temp1 = Var_a1 * Var_a1,
      st:insert({"temp", Var_temp1})
    end,
    Var_temp1.

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
    begin
      Var_t1 = quadrado(Var_x1), st:insert({"t", Var_t1})
    end,
    cubo(Var_x1),
    io:format("O valor de a ao quadrado eh: "),
    io:format("~p~n", [Var_t1]).

