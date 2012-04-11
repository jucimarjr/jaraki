%% class Rica extends Pessoa

%% Atributos:
%%		private double dinheiro;

%% Métodos:
%%	public void fazCompras()

%% Construtor:
%%  Pessoa(String nome)

%% Métodos Herdados:
%%   public int getIdade()
%%   public String getNome()

%% Atributos Herdados:
%%   private String nome;

-module('Rica').
-export([getIdade/1, getNome/1, '__constructor__'/2]).

'__constructor__'(ObjectID, V_nome) ->
	Scope = {'__constructor__', 'Rica'},

	%% declarando parâmetros recebidos
	st:put({Scope, "nome"}, {'String', V_nome}),

	%% super(nome)
	'Pessoa':'__constructor__'(ObjectID, st:get(Scope, "nome")),

	ObjectID.

getIdade(ObjectID) ->
	'Pessoa':getIdade(ObjectID).

getNome(ObjectID) ->
	'Pessoa':getNome(ObjectID).
