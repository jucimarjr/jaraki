-module(trycatch2).
-compile(export_all).


main() -> 
	
	St = io:get_line(">"), 
	A = io_lib:fread("~d", St),
	%%io:format("Saida ~p", [A]),
	

	case A of
		{ok,[_], [46, _, 10]}->
			io:format("Entrada inválida");
		{error,{fread,integer}} ->
			io:format("Entrada invalida");
		_ ->
			ok
	end.

