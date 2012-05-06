-module(testandowhile1).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    begin Var_i1 = 1, put("i", Var_i1) end,
    begin
      while(fun () -> get("i") < 20 end,
	    fun () ->
		    Var_i2 = get("i"),
		    put("i", Var_i2),
		    io:format("Estou dentro do while!!~n"),
		    begin Var_i3 = Var_i2 + 1, put("i", Var_i3) end
	    end)
    end.

