-module(funcao22).

-compile(export_all).

-import(loop, [for/3, while/2]).

bo(Var_a1) ->
    begin Var_b1 = false, st:insert({"b", Var_b1}) end,
    case Var_a1 == true of
      true ->
	  begin Var_b2 = false, st:insert({"b", Var_b2}) end;
      false ->
	  begin Var_b3 = true, st:insert({"b", Var_b3}) end
    end,
    st:get("b").

quadrado(Var_a1) ->
    begin
      Var_temp1 = Var_a1 * Var_a1,
      st:insert({"temp", Var_temp1})
    end,
    st:get("temp").

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
    io:format("~p~n", [Var_t1]),
    begin Var_b1 = bo(true), st:insert({"b", Var_b1}) end,
    io:format("O valor de b ao quadrado eh: "),
    io:format("~p~n", [Var_b1]).

