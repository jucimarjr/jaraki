-module(test).
-include_lib("eunit/include/eunit.hrl").

f_test_() -> [
	?_assertEqual(ok, jaraki:compile("java_src/jaraki_hello.java"))
	].
