-module(funcao22).

-compile(export_all).

-import(loop, [for/3, while/2]).

bo(V_a) ->
    st:put({bo, "a"}, {boolean, V_a}),
    st:put({bo, "b"}, {boolean, false}),
    case st:get(bo, "a") == true of
      true -> st:put({bo, "b"}, {boolean, false});
      false -> st:put({bo, "b"}, {boolean, true})
    end,
    st:get(bo, "b").

quadrado(V_a) ->
    st:put({quadrado, "a"}, {int, V_a}),
    st:put({quadrado, "temp"},
	   {int, st:get(quadrado, "a") * st:get(quadrado, "a")}),
    st:get(quadrado, "temp").

cubo(V_a) ->
    st:put({cubo, "a"}, {int, V_a}),
    st:put({cubo, "a"},
	   {int,
	    st:get(cubo, "a") *
	      (st:get(cubo, "a") * st:get(cubo, "a"))}),
    io:format("~s", ["O valor de a ao cubo: "]),
    io:format("~p~n", [st:get(cubo, "a")]).

main(V_Args) ->
    st:new(),
    st:put({main, "Args"}, {'String', V_Args}),
    st:put({main, "x"}, {int, 5}),
    st:put({main, "t"}, {int, quadrado(st:get(main, "x"))}),
    cubo(st:get(main, "x")),
    io:format("~s", ["O valor de a ao quadrado eh: "]),
    io:format("~p~n", [st:get(main, "t")]),
    st:put({main, "b"}, {boolean, bo(true)}),
    io:format("~s", ["O valor de b ao quadrado eh: "]),
    io:format("~p~n", [st:get(main, "b")]).

