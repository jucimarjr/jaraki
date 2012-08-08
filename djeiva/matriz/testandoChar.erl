-module(testandoChar).

-compile(export_all).

-import(loop, [for/3, while/2, do_while/2]).

-import(vector, [new/1, get_vector/1]).

-import(matrix, [new_matrix/1, creation_matrix/2]).

-import(random_lib, [function_random/2]).

-import(file_lib, [function_file/3, function_file/1]).

'__constructor__'() -> oo_lib:new(char1, [], []).

main( V_args) ->
    st:new(),
    st:get_new_stack({'Char1',
		      {main, [{array, 'String'}]}}),
    st:put_value({{'Char1', {main, [{array, 'String'}]}},
		  "args"},
		 {{array, 'String'}, V_args}),
    begin
      st:put_value({{'Char1', {main, [{array, 'String'}]}},
		    "u"},
		   {'String', "U"})
    end,
	begin
      st:put_value({{'Char1', {main, [{array, 'String'}]}},
		    "e"},
		   {'String', "E"})
    end,
	begin
      st:put_value({{'Char1', {main, [{array, 'String'}]}},
		    "a"},
		   {'String', "A"})
    end,
	begin
      st:put_value({{'Char1', {main, [{array, 'String'}]}},
		    "uea"},
		   {'String', "U" ++ "E" ++ "A"})
    end,
    
    io:format("~s~s~n",
	      ["String: ",
	       st:get_value({'Char1', {main, [{array, 'String'}]}},
			    "uea")]),
    st:destroy().
