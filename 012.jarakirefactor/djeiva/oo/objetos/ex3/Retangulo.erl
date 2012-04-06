-module('Retangulo').
-export([mudarLadoA/2, mudarLadoB/2, calcularArea/1, calcularPerimetro/1]).

mudarLadoA(ObjectID, V_lado) ->
	Scope = {mudarLadoA, 'Retangulo'},
	st:put({Scope, "lado"}, {integer, V_lado}),

	oo:update_attribute(ObjectID, {"ladoA", integer, st:get(Scope, "lado")}).

mudarLadoB(ObjectID, V_lado) ->
	Scope = {mudarLadoB, 'Retangulo'},
	st:put({Scope, "lado"}, {integer, V_lado}),

	oo:update_attribute(ObjectID, {"ladoB", integer, st:get(Scope, "lado")}).

calcularArea(ObjectID) ->
	Scope = {calcArea, 'Quadrado'},

	oo:get_attribute(ObjectID, "ladoA") * oo:get_attribute(ObjectID, "ladoB").

calcularPerimetro(ObjectID) ->
	Scope = {calcularPerimetro, 'Quadrado'},

	oo:get_attribute(ObjectID, "ladoA") * 2
		+ oo:get_attribute(ObjectID, "ladoB") * 2.
