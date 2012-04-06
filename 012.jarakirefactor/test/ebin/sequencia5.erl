-module(sequencia5).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"}, {'String', V_args}),
    io:format("~s~n",
	      ["Informe o numero em metros ser convertido"]),
    st:put_value({main, "metro"},
		 {int, io:fread(">", "~d")}),
    st:put_value({main, "centimetro"},
		 {int, st:get_value(main, "metro") * 100}),
    io:format("~p~s~p~s~n",
	      [st:get_value(main, "metro"), " metros corresponde a ",
	       st:get_value(main, "centimetro"), " centimetros  "]),
    st:get_old_stack(main),
    st:destroy().

