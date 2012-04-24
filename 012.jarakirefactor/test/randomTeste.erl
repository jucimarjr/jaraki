-module(randomTeste).
-compile(export_all).

main() ->
	A = random:uniform(100),
	io:format("Numero gerado ~p~n: ", [A]).
