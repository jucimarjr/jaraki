-module(testandomatriz).

-compile(export_all).

-import(loop, [for/3]).
-import(matrix, [new/1, access_matrix/3, set_matrix/4, size_matrix/1, creation_matrix/2, creation_vector/4]).
-import(st, [new/0]).

main(V_args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "args"},
		 {{array, 'String'}, V_args}),
    begin
      begin
	st:put_value({main, "vet"},
		     {{array, int},
		      matrix:new( array:from_list([array:from_list([1, 2]), array:from_list([3, 4])]))})
      end
    end,
	begin
      st:put_value({main, "vet2"},
		   {int, matrix:creation_matrix(2,3)})
    end,
    st:put_value({main, "vet2"},
	{{array, int}, matrix:set_matrix(0, 0, 0, st:get_value(main, "vet2"))}),
	st:put_value({main, "vet2"},
	{{array, int}, matrix:set_matrix(0, 1, 0, st:get_value(main, "vet2"))}),
	st:put_value({main, "vet2"},
	{{array, int}, matrix:set_matrix(0, 2, 0, st:get_value(main, "vet2"))}),
    st:put_value({main, "vet2"},
	{{array, int}, matrix:set_matrix(1, 0, 0, st:get_value(main, "vet2"))}),
	st:put_value({main, "vet2"},
	{{array, int}, matrix:set_matrix(1, 1, 0, st:get_value(main, "vet2"))}),
	st:put_value({main, "vet2"},
	{{array, int}, matrix:set_matrix(1, 2, 0, st:get_value(main, "vet2"))}),

    begin
       st:put_value({main, "i"}, {int, 0}),
      for(fun () -> st:get_value(main, "i") < 
		matrix:size_matrix(st:get_value(main, "vet2"))
 	end,
	  fun () ->
		  st:put_value({main, "i"},
			       {int, trunc(st:get_value(main, "i") + 1)})
	  end,
	  fun () ->
		  begin
		    st:put_value({main, "j"}, {int, 0}),
		    for(fun () -> st:get_value(main, "j") < 3
 			end,
			fun () ->
				st:put_value({main, "j"},
					     {int,
					      trunc(st:get_value(main, "j") +
						      1)})
			end,
			fun () ->
				 io:format("~p~n",
			    [matrix:access_matrix(st:get_value(main, "i"),
						  st:get_value(main, "j"),
						  st:get_value(main, "vet2"))])
			end),
		    st:delete(main, "j")
		  end
	  end),
      st:delete(main, "i")
    end,
    st:destroy().
