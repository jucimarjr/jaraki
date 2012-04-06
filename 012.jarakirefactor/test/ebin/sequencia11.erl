-module(sequencia11).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"}, {'String', V_args}),
    io:format("~s~n", ["Informe o sexo"]),
    st:put_value({main, "sexo"},
		 {'String', io:fread(">", "~s")}),
    io:format("~s~s~n",
	      ["Você digitou: ", st:get_value(main, "sexo")]),
    st:get_old_stack(main),
    st:destroy().

