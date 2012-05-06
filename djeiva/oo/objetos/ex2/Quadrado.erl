-module('Quadrado').
-export([mudarLado/2, getLado/1, calcArea/1]).

mudarLado(ObjectID, V_lado) ->
	Scope = {mudarLado, 'Quadrado'},
	st:put({Scope, "lado"}, {float, V_lado}),

	oo:update_attribute(ObjectID, {"lado", float, st:get(Scope, "lado")}).

getLado(ObjectID) ->
	Scope = {getLado, 'Quadrado'},

	oo:get_attribute(ObjectID, "lado").

calcArea(ObjectID) ->
	Scope = {calcArea, 'Quadrado'},

	oo:get_attribute(ObjectID, "lado") * oo:get_attribute(ObjectID, "lado").
