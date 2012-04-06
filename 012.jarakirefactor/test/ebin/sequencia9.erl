-module(sequencia9).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"}, {'String', V_args}),
    io:format("~s~n",
	      ["Informe uma temperatura em graus Farenheit"]),
    st:put_value({main, "grausFarenheit"},
		 {int, io:fread(">", "~d")}),
    st:put_value({main, "grausCelsius"},
		 {int,
		  5 * ((st:get_value(main, "grausFarenheit") - 32) / 9)}),
    io:format("~p~s~p~s~n",
	      [st:get_value(main, "grausFarenheit"),
	       " graus Farenheit corresponde a ",
	       st:get_value(main, "grausCelsius"), " graus Celsius"]),
    st:get_old_stack(main),
    st:destroy().

