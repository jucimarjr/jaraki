-module(sequencia4).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"}, {'String', V_args}),
    io:format("~s~n",
	      ["Informe as quatro notas bimestrais"]),
    st:put_value({main, "nota1"},
		 {float, io:fread(">", "~f")}),
    st:put_value({main, "nota2"},
		 {float, io:fread(">", "~f")}),
    st:put_value({main, "nota3"},
		 {float, io:fread(">", "~f")}),
    st:put_value({main, "nota4"},
		 {float, io:fread(">", "~f")}),
    st:put_value({main, "media"},
		 {float,
		  (st:get_value(main, "nota1") +
		     (st:get_value(main, "nota2") +
			(st:get_value(main, "nota3") +
			   st:get_value(main, "nota4"))))
		    / 4}),
    io:format("~s~f~n",
	      ["A média é: ", st:get_value(main, "media")]),
    st:get_old_stack(main),
    st:destroy().

