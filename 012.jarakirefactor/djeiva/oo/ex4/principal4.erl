-module(principal4).
-export([main/1, printPessoa/1]).

main(_V_args) ->
	Scope = {main, 'Principal4'},

	%% Pessoa p = new Pessoa()
	st:put({Scope, "p"},
		{'Pessoa',
			oo:new('Pessoa', [],
				[{"nome", 'String', ""},
				{"idade", integer, 0},
				{"peso", float, 0.0},
				{"altura", float, 0.0}
				])}),

	printPessoa(st:get(Scope, "p")),

	%% System.out.println("Alterando valores...");
	io:format("~s~n", ["Alterando valores..."]),

	%% p.envelhecer(1); p.engordar(3); p.crescer(2);
	Temp_Class1 = oo:get_class(st:get(Scope, "p")),
	Temp_Class1:envelhecer(st:get(Scope, "p"), 1),

	Temp_Class2 = oo:get_class(st:get(Scope, "p")),
	Temp_Class2:engordar(st:get(Scope, "p"), 3),

	Temp_Class3 = oo:get_class(st:get(Scope, "p")),
	Temp_Class3:crescer(st:get(Scope, "p"), 2),

	printPessoa(st:get(Scope, "p")).

printPessoa(V_p) ->
	Scope = {main, printPessoa},

	st:put({Scope, "p"}, {'Pessoa', V_p}),

	%% System.out.println(...)....
	io:format("~s~p~n", ["Nome: ",
		oo:get_attribute( st:get(Scope, "p"), "nome" )]),
	io:format("~s~p~n", ["Idade: ",
		oo:get_attribute( st:get(Scope, "p"), "idade" )]),
	io:format("~s~p~n", ["Peso: ",
		oo:get_attribute( st:get(Scope, "p"), "peso" )]),
	io:format("~s~p~n", ["Altura: ",
		oo:get_attribute( st:get(Scope, "p"), "altura" )]).
