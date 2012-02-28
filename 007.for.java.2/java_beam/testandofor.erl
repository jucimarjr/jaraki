-module(testandofor).

-compile(export_all).

-import(control, [for/3]).

main(Var_Args) ->
    begin
      put("i", 0),
      for(fun () -> get("i") < 50 end,
	  fun () -> put("i", get("i") + 1) end,
	  fun () ->
		  Var_i2 = get("i"),
		  io:format("Estou dentro do for :D~n"),
		  put("i", Var_i2)
	  end),
      erase("i")
    end.

