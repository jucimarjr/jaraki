-module(sequencia2).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:put({main, "args"}, {'String', V_args}),
    io:format("~s~n", ["Informe um numero"]),
    st:put({main, "num"}, {int, io:fread(">", "~d")}),
    io:format("~s~p~n",
	      ["O numero informado foi: ", st:get(main, "num")]).

