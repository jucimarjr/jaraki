-module(test).
-include_lib("eunit/include/eunit.hrl").

%% compile_all_test_() ->
%% 	{
%% 		"Jaraki compiling test...",
%% 		[compile_java(JavaFile) || JavaFile <- filelib:wildcard("java_src/*.java")]
%% 	}.
%% 
compile_all_beam_test_() ->
	{
		"Jaraki compiling .JAVA and generating .BEAM...",
		[compile_beam(JavaFile) || JavaFile <-	filelib:wildcard("java_src/*.java")]
	}.

%% compile_java(JavaFile) ->
%% 	{filename:basename(JavaFile), [?_assertEqual(ok, jaraki:compile(JavaFile))]}.
%% 
compile_beam(JavaFile) ->
	{filename:basename(JavaFile), [?_assertEqual(ok, jaraki:compile({beam,JavaFile}))]}.

