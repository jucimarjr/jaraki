-module('Retangulo').
-export([getCentro/1]).

%% é necessário bolar maneira de resolver dependências antes de
%% compilar as classes!!!
%% nesse caso é necessário saber a definição de Ponto ANTES da
%% de Retângulo
getCentro(ObjectID) ->
	Scope = {getCentro, 'Retangulo'},

	%% Ponto centro = new Ponto()
	st:put({Scope, "centro"},
		{'Ponto',
		oo:new('Ponto', [],
			[{"x", integer, 0},
			 {"y", integer, 0}])}),

	oo:update_attribute(st:get(Scope, "centro"),
		{"x", integer,
			oo:get_attribute(oo:get_attribute(ObjectID, "vertice"), "x")
			+
			oo:get_attribute(ObjectID, "largura") / 2}),

	oo:update_attribute(st:get(Scope, "centro"),
		{"y", integer,
			oo:get_attribute(oo:get_attribute(ObjectID, "vertice"), "y")
			+
			oo:get_attribute(ObjectID, "altura") / 2}),

	st:get(Scope, "centro").
