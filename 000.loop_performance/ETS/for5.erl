-module(for5).
-export([main/1]).
-import(control, [for/4]).

-compile(nowarn_unused_vars).

main(V_Args) ->
	Var_n1 = 500000,
%	Var_n1 = 6,
	Var_x1 = 0,

%% início do for
	begin
		InitFun =
			fun() ->
				ets:new(dict,	[named_table]),
				ets:insert(dict, {"n", Var_n1}),
				ets:insert(dict, {"x", Var_x1}),
				ets:insert(dict, {"i", 0})
			end,

		ConditionFun =
			fun() ->
				[{_, I}] = ets:lookup(dict, "i"), 
				[{_, N}] = ets:lookup(dict, "n"),
				I < N
			end,

		IncrementFun =
			fun() ->
				[{_, I}] = ets:lookup(dict, "i"), 
				ets:insert(dict, {"i", I + 1}) 
			end,

		BodyFun =
			fun() ->
				[{_, Var_n2}] = ets:lookup(dict, "n"),
				[{_, Var_x2}] = ets:lookup(dict, "x"),
				[{_, Var_i1}] = ets:lookup(dict, "i"),

				io:format("Estou contando e calculando dentro do for :D "),
				io:format("i: ~p~n", [Var_i1]),

				Var_x3 = Var_x2 + Var_i1,

				io:format("~p~n", [Var_x2]),
	
				ets:insert(dict, {"n", Var_n2}),
				ets:insert(dict, {"x", Var_x3}), 					
				ets:insert(dict, {"i", Var_i1}) 
			end,

		for(InitFun, ConditionFun, IncrementFun, BodyFun),
		[{_, V_n3}] = ets:lookup(dict, "n"),		
		[{_, V_x4}] = ets:lookup(dict, "x")
	end.
%% fim do for
