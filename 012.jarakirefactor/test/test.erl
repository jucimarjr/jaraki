-module(test).
-include_lib("eunit/include/eunit.hrl").

helloworld_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/jaraki_hello.java")).

media_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/jaraki_media.java")).

mediauea_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/jaraki_mediauea.java")).

for7_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/For7.java")).

funcao22_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/funcao2.2.java")).

listarprimos_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/ListarPrimos.java")).

