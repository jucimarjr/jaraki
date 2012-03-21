-module(pf).
-compile(export_all).
-import(loop, [for/3, while/2]).

st_new() ->
	jaraki_utils:get_runtime(st,new).

st_destroy() ->
	jaraki_utils:get_runtime(st,destroy).

pf_main() ->
	jaraki_utils:get_runtime(pf,main,[]).

pf_main2() ->
	jaraki_utils:get_runtime(pf,main2,[]).


st_put_perf() ->
	jaraki_utils:get_runtime(pf,st_put).

main(V_args) ->
    st:new(),
    st:put({main, "args"}, {'String', V_args}),
    st:put({main, "cont"}, {int, 0}),
    st:put({main, "n"}, {int, 1000}),
    st:put({main, "s"}, {int, 0}),
	
	st:put({main, "i"}, {int, 0}),
    for(
		fun() -> st:get(main, "i") < st:get(main, "n") end,
		fun() -> st:put({main, "i"}, {int, st:get(main, "i") + 1}) end,
			%% fun() -> 
			%% 		st:put({main, "s"}, {int, st:get(main,"s") + 1 })
			%% 	end

		fun() -> 
			st:put({main, "j"}, {int, 0}),
			for(
				fun() -> st:get(main, "j") < st:get(main, "n") end,
				fun() -> st:put({main, "j"}, {int, st:get(main, "j") + 1}) end,
				fun() -> 
					st:put({main, "s"}, {int, st:get(main,"s") + 1 })
				end
			),
			st:delete(main, "j")
		end
	),
    st:delete(main, "i"),
	io:format("~p~n", [st:get(main, "s")]),
	st:destroy().

main2(V_args) ->
    put({main, "args"}, V_args),
    put({main, "cont"}, 0),
    put({main, "n"}, 1000),
    put({main, "s"}, 0),
	
	put({main, "i"}, 0),
    for(
		fun() -> get({main, "i"}) < get({main, "n"}) end,
		fun() -> put({main, "i"}, get({main, "i"}) + 1 ) end,
			%% fun() -> 
			%% 		st:put({main, "s"}, {int, st:get(main,"s") + 1 })
			%% 	end

		fun() -> 
			put({main, "j"}, 0),
			for(
				fun() -> get({main, "j"}) < get({main, "n"}) end,
				fun() -> put({main, "j"}, get({main, "j"}) + 1 ) end,
				fun() -> 
						put({main, "s"}, get({main,"s"}) + 1 )
				end
			),
			erase({main, "j"})
		end
	),
	erase({main, "i"}),
	io:format("~p~n", [get({main, "s"})]),
	erase().
