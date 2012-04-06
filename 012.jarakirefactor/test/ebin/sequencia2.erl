-module(sequencia2).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"}, {'String', V_args}),
    io:format("~s~n", ["Informe um numero"]),
    st:put_value({main, "num"}, {int, io:fread(">", "~d")}),
    io:format("~s~p~n",
	      ["O numero informado foi: ",
	       st:get_value(main, "num")]),
    st:get_old_stack(main),
    st:destroy().

