-module(testandofor25).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:put({main, "Args"}, {'String', V_Args}),
    begin
      st:put({main, "i"}, {int, 0}),
      for(fun () -> st:get(main, "i") < 50 end,
	  fun () ->
		  st:put({main, "i"}, {int, st:get(main, "i") + 1})
	  end,
	  fun () ->
		  io:format("~s~n", ["1 - Estou dentro do 1o for :D"]),
		  io:format("~s~n", ["2 - Estou dentro do 1o for :D"]),
		  begin
		    st:put({main, "j"}, {int, 0}),
		    for(fun () -> st:get(main, "j") < 50 end,
			fun () ->
				st:put({main, "j"},
				       {int, st:get(main, "j") + 1})
			end,
			fun () ->
				io:format("~s~n",
					  ["1 - Estou dentro do 2o for :D"]),
				io:format("~s~n",
					  ["2 - Estou dentro do 2o for :D"])
			end),
		    st:delete(main, "j")
		  end
	  end),
      st:delete(main, "i")
    end.

