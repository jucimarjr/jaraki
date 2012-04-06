-module(mediauea).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "Args"}, {'String', V_Args}),
    st:put_value({main, "nota1"}, {float, 6}),
    st:put_value({main, "nota2"}, {float, 6}),
    st:put_value({main, "nota3"}, {float, 5}),
    st:put_value({main, "media"},
		 {float,
		  (st:get_value(main, "nota1") +
		     st:get_value(main, "nota2"))
		    / 2}),
    st:put_value({main, "mediaFinal"},
		 {float,
		  (st:get_value(main, "media") * 2 +
		     st:get_value(main, "nota3"))
		    / 3}),
    case st:get_value(main, "media") < 4 of
      true ->
	  io:format("~s", ["Reprovado direto com: "]),
	  io:format("~f~n", [st:get_value(main, "media")]);
      false ->
	  case st:get_value(main, "media") >= 8 of
	    true ->
		io:format("~s", ["Aprovado direto com: "]),
		io:format("~f~n", [st:get_value(main, "media")]);
	    false ->
		case st:get_value(main, "mediaFinal") >= 6 of
		  true ->
		      io:format("~s", ["Aprovado na prova final com: "]),
		      io:format("~f~n", [st:get_value(main, "mediaFinal")]);
		  false ->
		      io:format("~s", ["Reprovado na prova final com: "]),
		      io:format("~f~n", [st:get_value(main, "mediaFinal")])
		end
	  end
    end,
    st:get_old_stack(main),
    st:destroy().

