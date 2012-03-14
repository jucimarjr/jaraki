-module(mediauea).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(Var_Args1) ->
    st:new(),
    st:insert({"nota1", 6}),
    st:insert({"nota2", 6}),
    st:insert({"nota3", 5}),
    st:insert({"media",
	       (st:get("nota1") + st:get("nota2")) / 2}),
    st:insert({"mediaFinal",
	       (st:get("media") * 2 + st:get("nota3")) / 3}),
    case st:get("media") < 4 of
      true ->
	  io:format("~s", ["Reprovado direto com: "]),
	  io:format("~p~n", [st:get("media")]);
      false ->
	  case st:get("media") >= 8 of
	    true ->
		io:format("~s", ["Aprovado direto com: "]),
		io:format("~p~n", [st:get("media")]);
	    false ->
		case st:get("mediaFinal") >= 6 of
		  true ->
		      io:format("~s", ["Aprovado na prova final com: "]),
		      io:format("~p~n", [st:get("mediaFinal")]);
		  false ->
		      io:format("~s", ["Reprovado na prova final com: "]),
		      io:format("~p~n", [st:get("mediaFinal")])
		end
	  end
    end.

