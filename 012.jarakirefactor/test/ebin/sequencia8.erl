-module(sequencia8).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"}, {'String', V_args}),
    io:format("~s~n",
	      ["Informe quanto voce ganha por hora"]),
    st:put_value({main, "custoHora"},
		 {float, io:fread(">", "~f")}),
    io:format("~s~n",
	      ["Informe quantas horas voce trabalhou "
	       "nesse mês"]),
    st:put_value({main, "qtdHora"},
		 {int, io:fread(">", "~d")}),
    st:put_value({main, "salario"},
		 {float,
		  st:get_value(main, "qtdHora") *
		    st:get_value(main, "custoHora")}),
    io:format("~s~f~n",
	      ["O salario correspondente as horas trabalhadas "
	       "é: ",
	       st:get_value(main, "salario")]),
    st:get_old_stack(main),
    st:destroy().

