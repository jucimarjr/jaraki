-module(buscabinaria).

-compile(export_all).

-import(loop, [for/3]).

buscabinaria(V_valor, V_e, V_d, V_vetor) ->
    st:get_new_stack(buscabinaria),
    st:put_value({buscabinaria, "valor"}, {int, V_valor}),
    st:put_value({buscabinaria, "e"}, {int, V_e}),
    st:put_value({buscabinaria, "d"}, {int, V_d}),
    st:put_value({buscabinaria, "vetor"},
		 {{array, int}, V_vetor}),
    begin
      st:put_value({buscabinaria, "m"},
		   {int,
		    trunc((st:get_value(buscabinaria, "e") +
		       st:get_value(buscabinaria, "d"))
		      / 2)})
    end,
    begin
      st:put_value({buscabinaria, "Return"}, {int, -1})
    end,
    case st:get_value(buscabinaria, "m") == 0 of
      true ->
	  case array:get(0, st:get_value(buscabinaria, "vetor"))
		 == st:get_value(buscabinaria, "valor")
	      of
	    true ->
		st:put_value({buscabinaria, "Return"}, {int, 0});
	    false -> no_operation
	  end;
      false -> no_operation
    end,
    case st:get_value(buscabinaria, "e") ==
	   st:get_value(buscabinaria, "d") - 1
	of
      true ->
	  case array:get(st:get_value(buscabinaria, "d"),
			 st:get_value(buscabinaria, "vetor"))
		 == st:get_value(buscabinaria, "valor")
	      of
	    true ->
		st:put_value({buscabinaria, "Return"},
			     {int, st:get_value(buscabinaria, "d")});
	    false ->
		st:put_value({buscabinaria, "Return"}, {int, -1})
	  end;
      false ->
	  case array:get(st:get_value(buscabinaria, "m"),
			 st:get_value(buscabinaria, "vetor"))
		 < st:get_value(buscabinaria, "valor")
	      of
	    true ->
		st:put_value({buscabinaria, "Return"},
			     {int,
			      st:return_function(fun () ->
							 buscabinaria(st:get_value(buscabinaria,
										   "valor"),
								      st:get_value(buscabinaria,
										   "m"),
								      st:get_value(buscabinaria,
										   "d"),
								      st:get_value(buscabinaria,
										   "vetor"))
						 end,
						 buscabinaria,
						 [st:get_value(buscabinaria,
							       "valor"),
						  st:get_value(buscabinaria,
							       "m"),
						  st:get_value(buscabinaria,
							       "d"),
						  st:get_value(buscabinaria,
							       "vetor")])});
	    false ->
		st:put_value({buscabinaria, "Return"},
			     {int,
			      st:return_function(fun () ->
							 buscabinaria(st:get_value(buscabinaria,
										   "valor"),
								      st:get_value(buscabinaria,
										   "e"),
								      st:get_value(buscabinaria,
										   "m"),
								      st:get_value(buscabinaria,
										   "vetor"))
						 end,
						 buscabinaria,
						 [st:get_value(buscabinaria,
							       "valor"),
						  st:get_value(buscabinaria,
							       "e"),
						  st:get_value(buscabinaria,
							       "m"),
						  st:get_value(buscabinaria,
							       "vetor")])})
	  end
    end,
    begin
      Return = st:get_value(buscabinaria, "Return"),
      st:get_old_stack(buscabinaria),
      Return
    end.

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"},
		 {{array, 'String'}, V_args}),
    begin
      st:put_value({main, "vet"}, {int, array:new(10)})
    end,
    begin
      st:put_value({main, "i"}, {int, 0}),
      for(fun () ->
		  st:get_value(main, "i") <
		    array:size(st:get_value(main, "vet"))
	  end,
	  fun () ->
		  st:put_value({main, "i"},
			       {int, st:get_value(main, "i") + 1})
	  end,
	  fun () ->
		  st:put_value({main, "vet"},
			       {{array, int},
				array:set(st:get_value(main, "i"),
					  st:get_value(main, "i") * 10,
					  st:get_value(main, "vet"))})
	  end),
      st:delete(main, "i")
    end,
    begin
      st:put_value({main, "indice"},
		   {int,
		    st:return_function(fun () ->
					       buscabinaria(30, 0,
							    array:size(st:get_value(main,
										    "vet"))
							      - 1,
							    st:get_value(main,
									 "vet"))
				       end,
				       buscabinaria,
				       [30, 0,
					array:size(st:get_value(main, "vet")) -
					  1,
					st:get_value(main, "vet")])})
    end,
    io:format("~p~n", [st:get_value(main, "indice")]),
    st:get_old_stack(main),
    st:destroy().
