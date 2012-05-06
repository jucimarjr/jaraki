%% Atributos:
%%		...

%% Métodos:
%%	void exibeDados()

%% Atributos da superclasse:
%%		String nome;
%%		float salario;

%% Métodos das superclasses:
%%		void exibeDados()

-module('Gerente').
-export([exibeDados/1]).

exibeDados(ObjectID) ->
	Scope = {exibeDados, 'Gerente'},

	Temp_Class1 = oo:super(ObjectID),
	Temp_Class1:exibeDados(ObjectID),

	io:format("~s~p~n", ["Salario + bonus: ",
						oo:get_attribute(ObjectID, "salario")
						+
						oo:get_attribute(ObjectID, "bonusSalarial")]);

%% da superclasse Funcionario
exibeDados(ObjectID) ->
	'Funcionario':exibeDados(ObjectID).
