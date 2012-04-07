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
-export([getMatricula/1, exibeDados/1, '__constructor__'/4]).

'__constructor__'(ObjectID, V_nome, V_salario, V_matricula) ->
	Scope = {'__constructor__', 'Assistente'},

	%% declarando parâmetros recebidos
	st:put({Scope, "nome"}, {'String', V_nome}),
	st:put({Scope, "salario"}, {float, V_salario}),
	st:put({Scope, "matricula"}, {integer, V_matricula}),

	%% atualizando os objetos...
	%% this.attrb = var
	oo:update_attribute(ObjectID, {"nome", 'String', st:get(Scope, "nome")}),
	oo:update_attribute(ObjectID, {"salario", float, st:get(Scope, "salario")}),
	oo:update_attribute(ObjectID,
		{"matricula", integer, st:get(Scope, "matricula")}),

	ObjectID.


getMatricula(ObjectID) ->
	Scope = {getMatricula, 'Assistente'},

	oo:get_attribute(ObjectID, "matricula").

exibeDados(ObjectID) ->
	Scope = {exibeDados, 'Assistente'},

	'Funcionario':exibeDados(ObjectID),

	io:format("~s~p~n",
		["Matricula: ", oo:get_attribute(ObjectID, "matricula")]);

%% da superclasse Funcionario
exibeDados(ObjectID) ->
	'Funcionario':exibeDados(ObjectID).
