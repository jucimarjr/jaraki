-module('Principal2').
-export([main/1]).

main(_V_args) ->
	Scope = {main, 'Principal2'},

	%% Quadrado q = new Quadrado()
	st:put({Scope, "q"},
		{'Quadrado',
			oo:new('Quadrado', [],
				[{"lado", float, 0.0}])}),

	begin
	Temp_Class1 = oo:get_class(st:get(Scope, "q")),
	Temp_Class1:mudarLado(st:get(Scope, "q"), 10.0)
	end,

	io:format("~s~p~s~n", ["lado: ",
					begin
					Temp_Class2 = oo:get_class(st:get(Scope, "q")),
					Temp_Class2:getLado(st:get(Scope, "q"))
					end,
					"m"]),

	io:format("~s~p~s~n", ["area: ",
					begin
					Temp_Class2 = oo:get_class(st:get(Scope, "q")),
					Temp_Class2:calcArea
(st:get(Scope, "q"))
					end,
					"m^2"]).
