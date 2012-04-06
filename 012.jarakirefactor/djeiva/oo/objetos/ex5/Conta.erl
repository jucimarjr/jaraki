-module('Conta').
-export(['__constructor__'/3, '__constructor__'/4,
		alterarNome/2, depositar/2, sacar/2]).

'__constructor__'(ObjectID, V_numero, V_nome) ->
	Scope = {'__constructor__', 'Conta'},

	st:put({Scope, "numero"}, {integer, V_numero}),
	st:put({Scope, "nome"}, {integer, V_nome}),

	oo:update_attribute(ObjectID, {"numero", integer, st:get(Scope, "numero")}),
	oo:update_attribute(ObjectID, {"nome", integer, st:get(Scope, "nome")}),
	oo:update_attribute(ObjectID, {"saldo", float, 0.0}),
	ObjectID.

'__constructor__'(ObjectID, V_numero, V_nome, V_saldo) ->
	Scope = {'__constructor__', 'Conta'},

	st:put({Scope, "numero"}, {integer, V_numero}),
	st:put({Scope, "nome"}, {integer, V_nome}),
	st:put({Scope, "saldo"}, {integer, V_saldo}),

	oo:update_attribute(ObjectID, {"numero", integer, st:get(Scope, "numero")}),
	oo:update_attribute(ObjectID, {"nome", integer, st:get(Scope, "nome")}),
	oo:update_attribute(ObjectID, {"saldo", float, st:get(Scope, "saldo")}),
	ObjectID.



alterarNome(ObjectID, V_nome) ->
	Scope = {alterarNome, 'Conta'},

	st:put({Scope, "nome"}, {integer, V_nome}),

	oo:update_attribute(ObjectID, {"nome", integer, st:get(Scope, "nome")}).

depositar(ObjectID, V_quantia) ->
	Scope = {depositar, 'Conta'},

	st:put({Scope, "quantia"}, {integer, V_quantia}),

	oo:update_attribute(ObjectID,
		{"saldo", float,
			oo:get_attribute(ObjectID, "saldo") + st:get(Scope, "quantia")}).

sacar(ObjectID, V_quantia) ->
	Scope = {sacar, 'Conta'},

	st:put({Scope, "quantia"}, {integer, V_quantia}),

	oo:update_attribute(ObjectID,
		{"saldo", float,
			oo:get_attribute(ObjectID, "saldo") - st:get(Scope, "quantia")}).
