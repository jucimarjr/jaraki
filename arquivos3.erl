-module(arquivos3).

-compile(export_all).

-import(loop, [for/3, while/2]).

-import(vector, [new/1, get_vector/1]).

-import(matrix, [new_matrix/1, creation_matrix/2]).

-import(random_lib, [function_random/2]).

-import(file_lib, [function_file/3, function_file/1]).

'__constructor__'() -> oo_lib:new(arquivos3, [], []).

main({{array, 'String'}, V_args}) ->
    st:new(),
    st:get_new_stack({'Arquivos3',
		      {main, [{array, 'String'}]}}),
    st:put_value({{'Arquivos3',
		   {main, [{array, 'String'}]}},
		  "args"},
		 {{array, 'String'}, V_args}),
    begin
      st:put_value({{'Arquivos3',
		     {main, [{array, 'String'}]}},
		    "arq"},
		   {'FileReader',
		    function_file(new, "/home/josie/teste.txt", read)})
    end,
    begin
      st:put_value({{'Arquivos3',
		     {main, [{array, 'String'}]}},
		    "writer"},
		   {'FileWriter', "/home/josie/saida.txt"})
    end,
    st:put_value({{'Arquivos3',
		   {main, [{array, 'String'}]}},
		  "caracter"},
		 {int,
		  function_file(read,
				      st:get_value({'Arquivos3',
						    {main,
						     [{array, 'String'}]}},
						   "arq"),
				      1)}),
    function_file(write,
		  st:get_value({'Arquivos3', {main, [{array, 'String'}]}},
			       "writer"),
		  st:get_value({'Arquivos3', {main, [{array, 'String'}]}},
			       "caracter")),
    function_file(st:get_value({'Arquivos3',
				{main, [{array, 'String'}]}},
			       "arq")),
    function_file(st:get_value({'Arquivos3',
				{main, [{array, 'String'}]}},
			       "writer")),
    st:destroy().

