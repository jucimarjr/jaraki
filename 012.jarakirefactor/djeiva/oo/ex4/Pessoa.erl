-module('Pessoa').
-export([envelhecer/2, engordar/2, crescer/2]).

envelhecer(ObjectID, V_anos) ->
	Scope = {envelhecer, 'Animal'},

	st:put({Scope, "anos"}, {integer, V_anos}),

	%% if(idade < 21)
	%%	altura = altura + 0.5;
	case (oo:get_attribute(ObjectID, "idade") < 21) of
		true ->
			oo:update_attribute(ObjectID,
				{"altura", float, oo:get_attribute(ObjectID, "altura") + 0.5});
		false ->
			 no_operation
	end,

	%% idade = idade + anos;
	oo:update_attribute(ObjectID,
		{"idade", integer,
			oo:get_attribute(ObjectID, "idade") + st:get(Scope, "anos")}).

engordar(ObjectID, V_peso) ->
	Scope = {engordar, 'Animal'},

	st:put({Scope, "peso"}, {integer, V_peso}),

	%% this.peso = this.peso + peso;
	oo:update_attribute(ObjectID,
		{"peso", integer,
			oo:get_attribute(ObjectID, "peso") + st:get(Scope, "peso")}).

crescer(ObjectID, V_comprimento) ->
	Scope = {comprimento, 'Animal'},

	st:put({Scope, "comprimento"}, {integer, V_comprimento}),

	%% altura = altura + comprimento;
	oo:update_attribute(ObjectID,
		{"altura", integer,
			oo:get_attribute(ObjectID, "altura") +
			st:get(Scope, "comprimento")}).
