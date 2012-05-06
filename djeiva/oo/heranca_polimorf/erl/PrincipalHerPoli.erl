-module('PrincipalHerPoli').
-export([main/1]).

main(_V_args) ->
	Scope = {main, 'PrincipalHerPoli'},

	%% Realizada checagem de tipos!!!
	%% Assistente adm =
	%%	new Administrativo("Rodrigo Administrativo", 1000, 1, 'D', 100);
	st:put({Scope, "adm"},
		{'Assistente',
		'Administrativo':'__constructor__'(
			oo:new('Administrativo', ['Assistente', 'Funcionario'],
				[{"turno", char, '\0'},
				{"adicionalNoturno", float, 0.0},
				{"Nome", 'String', ""},
				{"salario", float, 0.0}]),
			"Rodrigo Administrativo", 1000, 1, 'D', 100)}),

	%% Assistente tecnico = new Tecnico("Rodrigao", 100, 2, 50);
	st:put({Scope, "tecnico"},
		{'Assistente',
		'Tecnico':'__constructor__'(
			oo:new('Tecnico', ['Assistente', 'Funcionario'],
				[{"bonusSalarial", float, 0.0},
				{"Nome", 'String', ""},
				{"salario", float, 0.0}]),
			"Rodrigao", 100, 1, 50)}),

	%% adm.exibeDados()
	begin
	Temp_Class1 = oo:get_class(st:get(Scope, "adm")),
	Temp_Class1:exibeDados(st:get(Scope, "adm"))
	end,

	io:format("~s~n", [[]]),

	%% tecnico.exibeDados()
	begin
	Temp_Class2 = oo:get_class(st:get(Scope, "tecnico")),
	Temp_Class2:exibeDados(st:get(Scope, "tecnico"))
	end.
