-module(funcao16).

-compile(export_all).

-import(loop, [for/3, while/2]).

imprimeVariavel() ->
    begin Var_a1 = 5, st:insert({"a", Var_a1}) end,
    io:format("Valor de a: "),
    io:format("~p~n", [Var_a1]).

imprime() -> io:format("Hello World~n").

testandoFor() ->
    begin Var_a1 = 8, st:insert({"a", Var_a1}) end,
    begin
      st:insert({"i", 0}),
      for(fun () -> st:get("i") =< 5 end,
	  fun () -> st:insert({"i", st:get("i") + 1}) end,
	  fun () ->
		  Var_i2 = st:get("i"),
		  Var_a2 = st:get("a"),
		  Var_a2 = st:get("a"),
		  io:format("Valor de a: "),
		  io:format("~p~n", [Var_a2]),
		  begin Var_a3 = Var_a2 + 1, st:insert({"a", Var_a3}) end,
		  io:format("Iteracao: "),
		  io:format("~p~n", [Var_i2]),
		  st:insert({"i", Var_i2}),
		  st:insert({"a", Var_a3}),
		  st:insert({"a", Var_a1})
	  end),
      st:delete("i"),
      Var_a4 = st:get("a"),
      Var_a2 = st:get("a")
    end.

testandoIf() ->
    begin Var_a1 = 3, st:insert({"a", Var_a1}) end,
    case Var_a1 < 2 of
      true -> io:format("~p~n", [Var_a1]);
      false -> no_operation
    end.

main(Var_Args1) ->
    st:new(),
    imprime(),
    imprimeVariavel(),
    testandoFor(),
    testandoIf().

