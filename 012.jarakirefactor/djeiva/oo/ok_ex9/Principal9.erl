-module('Principal9').
-export([main/1]).

main(_V_args) ->
	Scope = {main, 'Principal4'},

	%% Retangulo r = new Retangulo();
	st:put({Scope, "r"},
		{'Retangulo',
		oo:new('Retangulo', [],
			[{"altura", integer, 0},
			{"largura", integer, 0},
			{"vertice", 'Ponto',
				oo:new('Ponto', [],
					   [{"x", integer, 0}, {"y", integer, 0}])}])}),

	%% ignora Scanner...

	%% System.out.println...
	io:format("~s~n", ["Digite os valores do retangulo"]),
	io:format("~s", ["altura: "]),
	%% r.altura = s.nextInt();
	oo:update_attribute(st:get(Scope, "r"),
		{"altura", integer,
			begin
			{ok, [Temp1]} = io:fread("", "~d"),
			Temp1
			end}),

	io:format("~s", ["largura: "]),
	%% r.largura = s.nextInt();
	oo:update_attribute(st:get(Scope, "r"),
		{"largura", integer,
			begin
			{ok, [Temp2]} = io:fread("", "~d"),
			Temp2
			end}),

	io:format("~s~n", ["\nvertice inferior esquerdo: "]),
	io:format("~s", ["x: "]),
	%% r.vertice.x = s.nextInt();
	oo:update_attribute(oo:get_attribute(st:get(Scope, "r"), "vertice"),
		{"x", integer,
			begin
			{ok, [Temp3]} = io:fread("", "~d"),
			Temp3
			end}),

	io:format("~s", ["y: "]),
	%% r.vertice.x = s.nextInt();
	oo:update_attribute(oo:get_attribute(st:get(Scope, "r"), "vertice"),
		{"y", integer,
			begin
			{ok, [Temp4]} = io:fread("", "~d"),
			Temp4
			end}),

	io:format("~s", ["o centro do retangulo eh: "]),
	%% r.getCentro().printPoint();
	begin
	Temp_Class1 = oo:get_class(
					begin
					Temp_Class2 = oo:get_class(st:get(Scope, "r")),
					Temp_Class2:getCentro(st:get(Scope, "r"))
					end),
	Temp_Class1:printPoint(
					begin
					Temp_Class3 = oo:get_class(st:get(Scope, "r")),
					Temp_Class3:getCentro(st:get(Scope, "r"))
					end)
	end.
