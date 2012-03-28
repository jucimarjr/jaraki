-module('Principal3').
-export([main/1]).

main(_Args) ->
	Scope = {main, 'Principal3'},

	%% a se pensar como fazer o scanner...

	%% Pessoa p = new Pessoa()
	st:put({Scope, "r"},
		{'Retangulo',
			oo:new('Retangulo', [],
				[{"ladoA", integer, 0},
				{"ladoB", integer, 0}
				])}),

	io:format("Informe as medidas do local: "),

	{ok, [Temp1]} = io:fread("", "~d"),
	begin
		Temp_Class1 = oo:get_class(st:get(Scope, "r")),
		Temp_Class1:mudarLadoA(st:get(Scope, "r"), Temp1)
	end,

	{ok, [Temp2]} = io:fread("", "~d"),
	begin
		Temp_Class2 = oo:get_class(st:get(Scope, "r")),
		Temp_Class2:mudarLadoB(st:get(Scope, "r"), Temp2)
	end,

	io:format("~s~p~s~n", ["Rodapes necessarios: ",
							begin
							Temp_Class3 = oo:get_class(st:get(Scope, "r")),
							Temp_Class3:calcularPerimetro(st:get(Scope, "r"))
							end, "m"]),

	io:format("~s~p~s~n", ["Piso necessario: ",
							begin
							Temp_Class4 = oo:get_class(st:get(Scope, "r")),
							Temp_Class4:calcularArea(st:get(Scope, "r"))
							end, "m^2"]).
