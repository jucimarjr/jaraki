-module(arquivoTest).

-compile(export_all).

-import(loop, [for/3, while/2]).

-import(vector, [new/1, get_vector/1]).

-import(matrix, [new_matrix/1, creation_matrix/2]).

-import(randomLib, [function_random/2]).

main(V_args) ->

    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"},
		 {{array, 'String'}, V_args}),
    begin
      st:put_value({main, "counter"}, {int, trunc(0)})
    end,

	 {ok, Arquivo} = file:open("teste.txt", read),

	{ok, Caracter} = file:read(Arquivo, 1),

	st:put_value({main, "caracter"}, {int, Caracter}),

    while(fun () ->
		   not (st:get_value(main, "caracter") == 'eof')
	   end,
	   fun () ->
		   case st:get_value(main, "caracter") =/=  ' ' of
		     true ->
			 st:put_value({main, "counter"},
				      {int,
				       trunc(st:get_value(main, "counter") +
					       1)}),
			 {ok, ProximoCaracter} = file:read(Arquivo, 1),
			 st:put_value({main, "caracter"}, {int, ProximoCaracter});
		
		     false -> no_operation
		   end
	   end),
    io:format("~s~p~n",
	      ["O numero de caracteres do arquivo é:",
	       st:get_value(main, "counter")]),
	%%io:format("Valor do char: ~p", [Caracter]),
    st:destroy().

