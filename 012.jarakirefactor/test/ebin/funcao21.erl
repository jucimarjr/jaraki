-module(funcao21).

-compile(export_all).

-import(loop, [for/3, while/2]).

quadrado(V_a) ->
    st:put({quadrado, "a"}, {int, V_a}),
    st:put({quadrado, "a"},
	   {int, st:get(quadrado, "a") * st:get(quadrado, "a")}),
    io:format("~s", ["O valor de a ao quadrado: "]),
    io:format("~p~n", [st:get(quadrado, "a")]).

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
    quadrado(st:get(main, "x")),
    cubo(st:get(main, "x")).

