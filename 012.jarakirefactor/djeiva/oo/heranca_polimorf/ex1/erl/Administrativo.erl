%% construtor
%%		Administrativo(String nome, float salario, int matricula, char turno,
%%						float adicionalNoturno)

%% Atributos:
%%		char turno;
%%		float adicionalNoturno;

%% Métodos:
%%	void exibeDados()

%% Atributos da superclasse:
%%		String nome;
%%		float salario;

%% Métodos das superclasses:
%%		int getMatricula()
%%		void exibeDados()

-module('Administrativo').
-export([exibeDados/1, getMatricula/1]).

'__constructor__'(ObjectID, V_nome, V_salario, V_matricula, V_turno,
					V_adicionalNoturno) ->
	Scope = {'__constructor__', 'Administrativo'},

	st:put({Scope, "nome"}, {'String', V_nome}),
	st:put({Scope, "salario"}, {float, V_salario}),
	st:put({Scope, "matricula"}, {integer, V_matricula}),
	st:put({Scope, "turno"}, {char, V_turno}),
	st:put({Scope, "adicionalNoturno"}, {float, V_adicionalNoturno}).
%% terminar...


%% da superclasse
getMatricula(ObjectID) ->
	'Assistente':getMatricula(ObjectID).

%% sobrescreve
exibeDados(ObjectID) ->
	Scope = {exibeDados, 'Administrativo'},

	Temp_Class1 = oo:super(ObjectID),
	Temp_Class1:exibeDados(),

	st:put({Scope, "turnoExtenso"}, {'String', undefined}),
	st:put({Scope, "salarioTotal"}, {'float', 0.0}),

	case (oo:get_attribute(ObjectID, "turno") == "D") of
		true ->
			st:put({Scope, "turnoExtenso"}, {'String', "diurno"});
		_ ->
			st:put({Scope, "salarioTotal"},
				oo:get_attribute(ObjectID, "salario")
				   + oo:get_attribute(ObjectID, "adicionalNoturno")),
			st:put({Scope, "turnoExtenso"}, {'String', "noturno"})
	end,

	io:format("~s~p~n", ["Turno: ", st:get(Scope, "turnoExtenso")]),

	case (oo:get_attribute(ObjectID, "turno") == "N") of
		true ->
			io:format("~s~p~n",
				["Salario + adicional noturno: ",
				 st:get(Scope, "salarioTotal")]);

		_ ->
			no_operation
	end;

%% da superclasse Assistente
exibeDados(ObjectID) ->
	'Assistente':exibeDados(ObjectID);

%% da superclasse Funcionario
exibeDados(ObjectID) ->
	'Funcionario':exibeDados(ObjectID).
