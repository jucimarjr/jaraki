-module(mediauea).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:put({main, "Args"}, {'String', V_Args}),
    st:put({main, "nota1"}, {float, 6}),
    st:put({main, "nota2"}, {float, 6}),
    st:put({main, "nota3"}, {float, 5}),
    st:put({main, "media"},
	   {float,
	    (st:get(main, "nota1") + st:get(main, "nota2")) / 2}),
    st:put({main, "mediaFinal"},
	   {float,
	    (st:get(main, "media") * 2 + st:get(main, "nota3")) /
	      3}),
    case st:get(main, "media") < 4 of
      true ->
	  io:format("~s", ["Reprovado direto com: "]),
	  io:format("~p~n", [st:get(main, "media")]);
      false ->
	  case st:get(main, "media") >= 8 of
	    true ->
		io:format("~s", ["Aprovado direto com: "]),
		io:format("~p~n", [st:get(main, "media")]);
	    false ->
		case st:get(main, "mediaFinal") >= 6 of
		  true ->
		      io:format("~s", ["Aprovado na prova final com: "]),
		      io:format("~p~n", [st:get(main, "mediaFinal")]);
		  false ->
		      io:format("~s", ["Reprovado na prova final com: "]),
		      io:format("~p~n", [st:get(main, "mediaFinal")])
		end
	  end
    end.

