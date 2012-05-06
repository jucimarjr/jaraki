-module(mediauea).

-compile(export_all).

main(Args) ->
    Var_nota11 = 6,
    Var_nota21 = 6,
    Var_nota31 = 5,
    Var_media1 = (Var_nota11 + Var_nota21) / 2,
    Var_mediaFinal1 = (Var_media1 * 2 + Var_nota31) / 3,
    case Var_media1 < 4 of
      true ->
	  io:format("Reprovado direto com: "),
	  io:format("~p~n", [Var_media1]);
      false ->
	  case Var_media1 >= 8 of
	    true ->
		io:format("Aprovado direto com: "),
		io:format("~p~n", [Var_media1]);
	    false ->
		case Var_mediaFinal1 >= 6 of
		  true ->
		      io:format("Aprovado na prova final com: "),
		      io:format("~p~n", [Var_mediaFinal1]);
		  false ->
		      io:format("Reprovado na prova final com: "),
		      io:format("~p~n", [Var_mediaFinal1])
		end
	  end
    end.

