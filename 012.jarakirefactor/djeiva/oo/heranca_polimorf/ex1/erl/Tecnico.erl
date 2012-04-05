%% Atributos:
%%		private float bonusSalarial;

%% Métodos:
%%	void exibeDados()

%% Atributos da superclasse:
%%		String nome;
%%		float salario;

%% Métodos das superclasses:
%%		void exibeDados()
%%		int getMatricula()

-module('Tecnico').
-export([exibeDados/1, getMatricula/1]).

getMatricula(ObjectID) ->
	'Assistente':getMatricula(ObjectID).

exibeDados(ObjectID) ->
	Scope = {exibeDados, 'Gerente'},

	Temp_Class1 = oo:super(ObjectID),
	Temp_Class1:exibeDados(ObjectID),

	io:format("~s~n", ["(Gerente)"]);

%% da superclasse Assistente
exibeDados(ObjectID) ->
	'Assistente':exibeDados(ObjectID).

%% da superclasse Funcionario
exibeDados(ObjectID) ->
	'Funcionario':exibeDados(ObjectID).
