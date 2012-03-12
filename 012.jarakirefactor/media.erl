-module(media).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(Var_Args1) ->
    st:new(),
    begin Var_a1 = 10, st:insert({"a", Var_a1}) end,
    begin Var_a2 = Var_a1 + 1, st:insert({"a", Var_a2}) end,
    begin Var_b1 = 5, st:insert({"b", Var_b1}) end,
    begin
      Var_c1 = (Var_a2 + Var_b1) / 2, st:insert({"c", Var_c1})
    end,
    io:format("A media eh: ~n"),
    io:format("~p~n", [Var_c1]).

