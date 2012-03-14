-module(test).
-include_lib("eunit/include/eunit.hrl").

helloworld_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/J01Hello.java")).

media_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/J02Media.java")).

mediauea_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/J03MediaUea.java")).

for7_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/TestandoFor7.java")).

funcao22_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/funcao2.2.java")).

listarprimos_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/ListarPrimos.java")).

testandovar1_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/ATestandoVar01.java")).

testandovar2_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/ATestandoVar02.java")).

testandovar3_test_() ->
	?_assertEqual(ok, jaraki:compile("java_src/ATestandoVar03.java")).

