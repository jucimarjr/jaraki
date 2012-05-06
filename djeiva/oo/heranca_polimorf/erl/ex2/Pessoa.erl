%% public class Pessoa

%% Atributos:
%%		private String nome;
%%      private int idade;

%% Métodos:
%%	getIdade()
%%  getNome()

%% Construtor:
%%  Pessoa()
%%  Pessoa(String nome)

%% Métodos Herdados:
%%   ...

%% Atributos Herdados:
%%   ...

-module('Pessoa').
-export([getIdade/1, getNome/1, '__constructor__'/1, '__constructor__'/2]).

'__constructor__'(ObjectID) ->
	Scope = {'__constructor__', 'Pessoa'},

	%% atualizando os objetos...
	%% this.attrb = var
	oo:update_attribute(ObjectID, {"nome", 'String', "Pessoa sem nome"}),

	ObjectID.


'__constructor__'(ObjectID, V_nome) ->
	Scope = {'__constructor__', 'Pessoa'},

	%% declarando parâmetros recebidos
	st:put({Scope, "nome"}, {'String', V_nome}),

	%% atualizando os objetos...
	%% this.attrb = var
	oo:update_attribute(ObjectID, {"nome", 'String', st:get(Scope, "nome")}),

	ObjectID.

getIdade(ObjectID) ->
	Scope = {getIdade, 'Pessoa'},

	oo:get_attribute(ObjectID, "idade").

getNome(ObjectID) ->
	Scope = {getNome, 'Pessoa'},

	oo:get_attribute(ObjectID, "nome").
