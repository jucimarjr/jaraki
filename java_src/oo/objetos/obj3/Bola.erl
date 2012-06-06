-module('Bola').
-export([trocaCor/2, mostraCor/1]).

%% construtor padrão
'__constructor__'() ->
	oo:new('Bola', [],
		[{"cor", 'String', undefined},
		{"circunferencia", float, 0.0},
		{"material", 'String', undefined}
	])}).


trocaCor(ObjectID, V_cor) ->
	Scope = {trocaCor, 'Bola'},
	st:put({Scope, "cor"}, {integer, V_cor}),

	oo:update_attribute(ObjectID, {"cor", integer, st:get(Scope, "cor")}).

mostraCor(ObjectID) ->
	Scope = {mostraCor, 'Bola'},

	io:format("~s~p~n", ["Cor: ", oo:get_attribute(ObjectID, "cor")]).
