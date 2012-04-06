-module(sequencia10).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"}, {'String', V_args}),
    io:format("~s~n",
	      ["Informe uma temperatura em graus Celsius"]),
    st:put_value({main, "grausCelsius"},
		 {int, io:fread(">", "~d")}),
    st:put_value({main, "grausFarenheit"},
		 {int,
		  (9 * st:get_value(main, "grausCelsius") + 160) / 5}),
    io:format("~p~s~p~s~n",
	      [st:get_value(main, "grausCelsius"),
	       " graus Celsius corresponde a ",
	       st:get_value(main, "grausFarenheit"),
	       " graus Farenheit"]),
    st:get_old_stack(main),
    st:destroy().

