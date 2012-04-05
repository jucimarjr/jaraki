%% Atributos:
%%		private int matricula;

%% Métodos:
%%	int getMatricula()
%%	void exibeDados()

%% Atributos da superclasse:
%%		String nome;
%%		float salario;

%% Métodos das superclasses:
%%		void exibeDados()

-module('Assistente').
-export([getMatricula/1, exibeDados/1]).

getMatricula(ObjectID) ->
	Scope = {getMatricula, 'Assistente'},

	oo:get_attribute(ObjectID, "matricula").

exibeDados(ObjectID) ->
	Scope = {exibeDados, 'Assistente'},

	Temp_Class1 = oo:super(ObjectID),
	Temp_Class1:exibeDados(ObjectID),

	io:format("~s~p~n",
		["Matricula: ", oo:get_attribute(ObjectID, "matricula")]);

%% da superclasse Funcionario
exibeDados(ObjectID) ->
	'Funcionario':exibeDados(ObjectID).
