-module(test).
-include_lib("eunit/include/eunit.hrl").

compile_all_test_() ->
	{
		"Jaraki compiling test...",
		[compilar(JavaFile) || JavaFile <-	filelib:wildcard("java_src/*.java")]
	}.

compilar(JavaFile) ->
	{filename:basename(JavaFile), [?_assertEqual(ok, jaraki:compile(JavaFile))]}.



