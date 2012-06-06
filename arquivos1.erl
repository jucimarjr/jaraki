-module(arquivos1).

-compile(export_all).

-import(loop, [for/3, while/2]).

-import(vector, [new/1, get_vector/1]).

-import(matrix, [new_matrix/1, creation_matrix/2]).

-import(randomLib, [function_random/2]).

-import(fileLib, [function_file/3, function_file/0]).

'__constructor__'() -> oo_lib:new(arquivos1, [], []).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"},
		 {{array, 'String'}, V_args}),
    begin
      st:put_value({main, "counter"}, {int, trunc(0)})
    end,
    begin
      st:put_value({main, "arq"},
		   {'FileReader',
		    function_file(new, "/home/josie/teste.txt", read)})
    end,
    st:put_value({main, "caracter"},
		 {int,
		  trunc(function_file(read, st:get_value(main, "arq"),
				      1))}),
    while(fun () ->
		  not (st:get_value(main, "caracter") == -1)
	  end,
	  fun () ->
		  st:put_value({main, "counter"},
			       {int, trunc(st:get_value(main, "counter") + 1)}),
		  st:put_value({main, "caracter"},
			       {int,
				trunc(function_file(read,
						    st:get_value(main, "arq"),
						    1))})
	  end),
    io:format("~s~p~n",
	      ["O numero de caracteres do arquivo é:",
	       st:get_value(main, "counter")]),
    st:destroy().

