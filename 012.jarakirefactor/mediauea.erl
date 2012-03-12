-module(mediauea).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(Var_Args1) ->
    st:new(),
    begin
      Var_nota11 = 6, st:insert({"nota1", Var_nota11})
    end,
    begin
      Var_nota21 = 6, st:insert({"nota2", Var_nota21})
    end,
    begin
      Var_nota31 = 5, st:insert({"nota3", Var_nota31})
    end,
    begin
      Var_media1 = (Var_nota11 + Var_nota21) / 2,
      st:insert({"media", Var_media1})
    end,
    begin
      Var_mediaFinal1 = (Var_media1 * 2 + Var_nota31) / 3,
      st:insert({"mediaFinal", Var_mediaFinal1})
    end,
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

