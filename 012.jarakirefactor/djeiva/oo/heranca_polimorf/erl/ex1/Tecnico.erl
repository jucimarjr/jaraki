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
-export([exibeDados/1, getMatricula/1, '__constructor__'/5]).

'__constructor__'(ObjectID, V_nome, V_salario, V_matricula, V_bonusSalarial) ->
	Scope = {'__constructor__', 'Administrativo'},

	%% declarando parâmetros recebidos
	st:put({Scope, "nome"}, {'String', V_nome}),
	st:put({Scope, "salario"}, {float, V_salario}),
	st:put({Scope, "matricula"}, {integer, V_matricula}),
	st:put({Scope, "bonusSalarial"}, {float, V_bonusSalarial}),

	%% determinado em tempo de compilação quem é a classe super
	%% super(Args...)
	'Assistente':'__constructor__'(
		ObjectID,
		st:get(Scope, "nome"),
		st:get(Scope, "salario"), st:get(Scope, "matricula")),

	%% atualizando os objetos...
	%% this.attrb = var
	oo:update_attribute(ObjectID,
		{"bonusSalarial", float, st:get(Scope, "bonusSalarial")}),

	%% como todo construtor, deve retornar o ObjectID!
	%% por enquanto isso não está sendo usado, mas por precaução...
	ObjectID.

getMatricula(ObjectID) ->
	'Assistente':getMatricula(ObjectID).

exibeDados(ObjectID) ->
	Scope = {exibeDados, 'Gerente'},

	'Assistente':exibeDados(ObjectID);

%% da superclasse Assistente
exibeDados(ObjectID) ->
	'Assistente':exibeDados(ObjectID);

%% da superclasse Funcionario
exibeDados(ObjectID) ->
	'Funcionario':exibeDados(ObjectID).
