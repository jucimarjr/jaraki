-module(funcao22).

-compile(export_all).

-import(loop, [for/3, while/2]).

bo(Var_a1) ->
    st:insert({"b", false}),
    case st:get("a") == true of
      true -> st:insert({"b", false});
      false -> st:insert({"b", true})
    end,
    st:get("b").

quadrado(Var_a1) ->
    st:insert({"temp", st:get("a") * st:get("a")}),
    st:get("temp").

cubo(Var_a1) ->
    st:insert({"a",
	       st:get("a") * (st:get("a") * st:get("a"))}),
    io:format("~s", ["O valor de a ao cubo: "]),
    io:format("~p~n", [st:get("a")]).

main(Var_Args1) ->
    st:new(),
    st:insert({"x", 5}),
    st:insert({"t", quadrado(st:get("x"))}),
    cubo(st:get("x")),
    io:format("~s", ["O valor de a ao quadrado eh: "]),
    io:format("~p~n", [st:get("t")]),
    st:insert({"b", bo(true)}),
    io:format("~s", ["O valor de b ao quadrado eh: "]),
    io:format("~p~n", [st:get("b")]).

