-module(teste).

-compile(export_all).


main() -> 
	[begin io:format("Estou dentro do for :D\n") end || _ <- lists:seq(0,9)].
