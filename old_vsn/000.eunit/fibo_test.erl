-module(fibo_test).
-include_lib("eunit/include/eunit.hrl").

f_test_()->	[ 
	?_assertEqual(0,fibo:f(0)),
	?_assertEqual(1,fibo:f(1)),
	?_assertEqual(1,fibo:f(2)),
	?_assertError(function_clause,fibo:f(-1)),
	?_assert(fibo:f(31) =:= 1346269)
].

