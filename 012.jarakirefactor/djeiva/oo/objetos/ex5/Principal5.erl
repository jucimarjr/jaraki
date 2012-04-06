-module('Principal5').
-export([main/1]).

main(_V_args) ->
	Scope = {main, 'Principal4'},

	%% Conta c = new Conta()
	st:put({Scope, "c"},
		{'Conta',
		'Conta':'__constructor__'(
			oo:new('Conta', [],
				[{"numero", integer, 0},
				{"nome", 'String', undefined},
				{"saldo", float, 0.0}]),
			1345,
			"Rodrigo")}),

	%% System.out.println("...");
	io:format("~s~p~n", ["Numero: ",
		oo:get_attribute( st:get(Scope, "c"), "numero" )]),

	io:format("~s~p~n", ["Nome: ",
		oo:get_attribute( st:get(Scope, "c"), "nome" )]),

	io:format("~s~p~n", ["Saldo: ",
		oo:get_attribute( st:get(Scope, "c"), "saldo" )]),

	io:format("~s~n", ["\nalterando...\n"]),

	%% c.alterarNome("..."); c.depositar(1000f); c.sacar(100f);
	begin
	Temp_Class1 = oo:get_class(st:get(Scope, "c")),
	Temp_Class1:alterarNome(st:get(Scope, "c"), "Rodrigo Bernardino")
	end,

	begin
	Temp_Class2 = oo:get_class(st:get(Scope, "c")),
	Temp_Class2:depositar(st:get(Scope, "c"), 1000.0)
	end,

	begin
	Temp_Class3 = oo:get_class(st:get(Scope, "c")),
	Temp_Class3:sacar(st:get(Scope, "c"), 100.0)
	end,

	%% System.out.println("...");
	io:format("~s~p~n", ["Numero: ",
		oo:get_attribute( st:get(Scope, "c"), "numero" )]),

	io:format("~s~p~n", ["Nome: ",
		oo:get_attribute( st:get(Scope, "c"), "nome" )]),

	io:format("~s~p~n", ["Saldo: ",
		oo:get_attribute( st:get(Scope, "c"), "saldo" )]).
