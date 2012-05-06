-module(mediaueab2).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    begin Var_n11 = 8, put("n1", Var_n11) end,
    begin Var_n21 = 7, put("n2", Var_n21) end,
    begin Var_n31 = 3, put("n3", Var_n31) end,
    begin
      Var_media1 = (Var_n11 + Var_n21) / 2,
      put("media", Var_media1)
    end,
    begin
      Var_mediaFinal1 = (Var_media1 * 2 + Var_n31) / 3,
      put("mediaFinal", Var_mediaFinal1)
    end,
    case Var_media1 < 4 of
      true ->
	  io:format("Perdeu Preiboi! "),
	  io:format("~p~n", [Var_media1]);
      false ->
	  io:format("Aeeeeh "), io:format("~p~n", [Var_media1])
    end,
    case Var_mediaFinal1 >= 8 of
      true ->
	  io:format("To no IF de uma linha! Feel like a ninja! ");
      false -> no_operation
    end,
    io:format("~p~n", [Var_mediaFinal1]).

