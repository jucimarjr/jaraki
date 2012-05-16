-module(testandomatriz).

-compile(export_all).

-import(loop, [for/3]).
-import(matrix, [new/1, access_matrix/3, set_matrix/4]).
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
    st:put_value({main, "vet"},
	{{array, int}, matrix:set_matrix(0, 0, 0, st:get_value(main, "vet"))}),
    begin
       st:put_value({main, "i"}, {int, 0}),
      for(fun () -> st:get_value(main, "i") < 2 end,
	  fun () ->
		  st:put_value({main, "i"},
			       {int, trunc(st:get_value(main, "i") + 1)})
	  end,
	  fun () ->
		  begin
		    st:put_value({main, "j"}, {int, 0}),
		    for(fun () -> st:get_value(main, "j") < 2 end,
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
						  st:get_value(main, "vet"))])
			end),
		    st:delete(main, "j")
		  end
	  end),
      st:delete(main, "i")
    end,
    st:destroy().
