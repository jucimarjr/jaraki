-module(arquivos1).

-compile(export_all).

-import(loop, [for/3, while/2, do_while/2]).

-import(vector, [new/1, get_vector/1]).

-import(matrix, [new_matrix/1, creation_matrix/2]).

-import(random_lib, [function_random/2]).

-import(file_lib, [function_file/3, function_file/1]).

'__constructor__'() -> oo_lib:new(arquivos1, [], []).

main({{array, 'String'}, V_args}) ->
    st:new(),
    st:get_new_stack({'Arquivos1',
		      {main, [{array, 'String'}]}}),
    st:put_value({{'Arquivos1',
		   {main, [{array, 'String'}]}},
		  "args"},
		 {{array, 'String'}, V_args}),
    begin
      st:put_value({{'Arquivos1',
		     {main, [{array, 'String'}]}},
		    "counter"},
		   {int, trunc(0)})
    end,
    begin
      st:put_value({{'Arquivos1',
		     {main, [{array, 'String'}]}},
		    "arq"},
		   {'FileReader',
		    function_file(new, "/home/josie/teste.txt", read)})
    end,
    st:put_value({{'Arquivos1',
		   {main, [{array, 'String'}]}},
		  "caracter"},
		 {int,
		  trunc(function_file(read,
				      st:get_value({'Arquivos1',
						    {main,
						     [{array, 'String'}]}},
						   "arq"),
				      1))}),
    while(fun () ->
		  not
		    (st:get_value({'Arquivos1',
				   {main, [{array, 'String'}]}},
				  "caracter")
		       == -1)
	  end,
	  fun () ->
		  st:put_value({{'Arquivos1',
				 {main, [{array, 'String'}]}},
				"counter"},
			       {int,
				trunc(st:get_value({'Arquivos1',
						    {main,
						     [{array, 'String'}]}},
						   "counter")
					+ 1)}),
		  st:put_value({{'Arquivos1',
				 {main, [{array, 'String'}]}},
				"caracter"},
			       {int,
				trunc(function_file(read,
						    st:get_value({'Arquivos1',
								  {main,
								   [{array,
								     'String'}]}},
								 "arq"),
						    1))})
	  end),
    function_file(st:get_value({'Arquivos1',
				{main, [{array, 'String'}]}},
			       "arq")),
    io:format("~s~p~n",
	      ["O numero de caracteres do arquivo é:",
	       st:get_value({'Arquivos1', {main, [{array, 'String'}]}},
			    "counter")]),
    st:destroy().

