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
    st2:putv({main, "args"}, {'String', V_args}),
    st2:putv({main, "cont"}, {int, 0}),
    st2:putv({main, "n"}, {int, 1000}),
    st2:putv({main, "s"}, {int, 0}),
	
	st2:putv({main, "i"}, {int, 0}),
    for(
		fun() -> st2:get(main, "i") < st2:get(main, "n") end,
		fun() -> st2:putv({main, "i"}, {int, st2:get(main, "i") + 1}) end,
			%% fun() -> 
			%% 		st:put({main, "s"}, {int, st:get(main,"s") + 1 })
			%% 	end

		fun() -> 
			st2:putv({main, "j"}, {int, 0}),
			for(
				fun() -> st2:get(main, "j") < st2:get(main, "n") end,
				fun() -> st2:putv({main, "j"}, {int, st2:get(main, "j") + 1}) end,
				fun() -> 
					st2:putv({main, "s"}, {int, st2:get(main,"s") + 1 })
				end
			),
			st2:delete(main, "j")
		end
	),
    st2:delete(main, "i"),
    io:format("~p~n", [st2:get(main, "s")]),
    st2:destroy().
