-module(testandovetor000).

-compile(export_all).

-import(loop, [for/3, while/2]).
-import(st).

main(V_Args) ->
    st:new(),
  	 st:put_value({main, "vet"}, {'int[]', array:set(0, 1, array:new())}),
	 st:put_value({main, "vet"}, {'int[]', array:set(1, 2, st:get_value(main, "vet"))}),
	 st:put_value({main, "vet"}, {'int[]', array:set(2, 3,  st:get_value(main, "vet"))}),

     st:put_value({main, "n"}, {int, 3}),
	
    st:put_value({main, "vet"}, {'int[]', array:set(2, 7, st:get_value(main, "vet"))}),
     
   begin
      st:put_value({main, "i"}, {int, 0}),
      for(fun () ->
		  st:get_value(main, "i") < st:get_value(main, "n")
	  end,
	  fun () ->
		  st:put_value({main, "i"},
			       {int, st:get_value(main, "i") + 1})
	  end,
	  fun () ->
		  io:format("~p~n", [array:get(st:get_value(main, "i"), st:get_value(main, "vet"))])
	  end),
      st:delete(main, "i")
    end.

 
