-module(test).
-include_lib("eunit/include/eunit.hrl").

<<<<<<< HEAD
compile_all_test_() ->
	{
		"Jaraki compiling test...",
		[compile(JavaFile) || JavaFile <-	filelib:wildcard("java_src/*.java")]
	}.

compile_all_beam_test_() ->
	{
		"Jaraki generating .BEAM...",
		[compile_beam(JavaFile) || JavaFile <-	filelib:wildcard("java_src/*.java")]
	}.


compile(JavaFile) ->
	{filename:basename(JavaFile), [?_assertEqual(ok, jaraki:compile(JavaFile))]}.

compile_beam(JavaFile) ->
	{filename:basename(JavaFile), [?_assertEqual(ok, jaraki:compile(file_beam,JavaFile))]}.

=======
helloworld_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/jaraki_hello.java")).

media_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/jaraki_media.java")).

mediauea_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/jaraki_mediauea.java")).
>>>>>>> c5a417666735dfa29b81dd9a09aae7f766d8a1db

for7_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/For7.java")).

funcao22_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/funcao2.2.java")).

listarprimos_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/ListarPrimos.java")).

