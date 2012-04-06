-module(sequencia3).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"}, {'String', V_args}),
    io:format("~s~n", ["Informe o primeiro numero"]),
    st:put_value({main, "num1"},
		 {int, io:fread(">", "~d")}),
    io:format("~s~n", ["Informe o segundo numero"]),
    st:put_value({main, "num2"},
		 {int, io:fread(">", "~d")}),
    st:put_value({main, "soma"},
		 {int,
		  st:get_value(main, "num1") +
		    st:get_value(main, "num2")}),
    io:format("~s~p~n",
	      ["A soma é: ", st:get_value(main, "soma")]),
    st:get_old_stack(main),
    st:destroy().

