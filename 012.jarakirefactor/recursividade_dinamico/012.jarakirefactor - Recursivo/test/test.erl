-module(test).
-include_lib("eunit/include/eunit.hrl").

%% compile_all_test_() ->
%% 	{
%% 		"Jaraki compiling test...",
%% 		[compile_java(JavaFile) || JavaFile <- filelib:wildcard("java_src/*.java")]
%% 	}.
%% 

%% compile_all_error_test_() ->
%% 	{
%% 		"Jaraki compiling .JAVA with errors...",
%% 		[compile_error(JavaFile) || JavaFile <-	filelib:wildcard("java_erro/*.java")]
%% 	}.
%% 
compile_all_beam_test_() ->
	{
		"Jaraki compiling .JAVA and generating .BEAM...",
		[compile_beam(JavaFile) || JavaFile <-	filelib:wildcard("java_src/*.java")]
	}.

compile_beam(JavaFile) ->
	{filename:basename(JavaFile), [?_assertEqual(ok, jaraki:compile({beam,JavaFile}))]}.

%% compile_error(JavaFile) ->
%% 	{filename:basename(JavaFile), [?_assertError(badarg, jaraki:compile({beam,JavaFile}))]}.
