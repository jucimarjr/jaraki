-module(testeTryCatch).
-compile(export_all).

main() ->
	try io:fread("Informe um numero inteiro>", "~d")
	catch 
		exit:badarg -> {'EXIT', badarg},
			io:format("~p~n: ", ["Entrada invalida"])
	end.



	
