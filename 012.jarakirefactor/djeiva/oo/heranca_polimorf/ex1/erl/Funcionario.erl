%% Atributos:
%%		String nome;
%%		float salario;

%% Métodos:
%%	void exibeDados()

-module('Funcionario').
-export([exibeDados/1]).

exibeDados(ObjectID) ->
	Scope = {exibeDados, 'Funcionario'},

	io:format("~s~n", ["======== DADOS ========"]),
	io:format("~s~p~n", ["Nome: ", oo:get_attribute(ObjectID, "nome")]),
	io:format("~s~p~n", ["Salario: ", oo:get_attribute(ObjectID, "salario")]).
