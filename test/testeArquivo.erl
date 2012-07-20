-module(testeArquivo).

-compile(export_all).


main() ->
	
	{ok, Arq} = file:open("test.erl", read),

	{ok, Read} = file:read(Arq, 7),

	file:write_file("saida.txt", Read).
