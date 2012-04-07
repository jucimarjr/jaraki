-module('Principal1').
-export([main/1]).

main(_V_args) ->
	Scope = {main, 'Principal1'},

	%% Pessoa p = new Pessoa()
	st:put({Scope, "b"},
		{'Bola',
			oo:new('Bola', [],
				[{"cor", 'String', undefined},
				{"circunferencia", float, 0.0},
				{"material", 'String', undefined}
				])}),

	%% b.trocaCor("azul"); b.mostraCor(); b.trocaCor("preto"); b.mostraCor();
	begin
	Temp_Class1 = oo:get_class(st:get(Scope, "b")),
	Temp_Class1:trocaCor(st:get(Scope, "b"), "azul")
	end,

	begin
	Temp_Class2 = oo:get_class(st:get(Scope, "b")),
	Temp_Class2:mostraCor(st:get(Scope, "b"))
	end,

	begin
	Temp_Class1 = oo:get_class(st:get(Scope, "b")),
	Temp_Class1:trocaCor(st:get(Scope, "b"), "preto")
	end,

	begin
	Temp_Class2 = oo:get_class(st:get(Scope, "b")),
	Temp_Class2:mostraCor(st:get(Scope, "b"))
	end.
