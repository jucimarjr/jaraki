-module(sequencia3).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:put({main, "args"}, {'String', V_args}),
    io:format("~s~n", ["Informe o primeiro numero"]),
    st:put({main, "num1"}, {int, io:fread(">", "~d")}),
    io:format("~s~n", ["Informe o segundo numero"]),
    st:put({main, "num2"}, {int, io:fread(">", "~d")}),
    st:put({main, "soma"},
	   {int, st:get(main, "num1") + st:get(main, "num2")}),
    io:format("~s~p~n",
	      ["A soma é: ", st:get(main, "soma")]).

