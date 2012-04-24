-module(testScanner).

-compile(export_all).


scanner() ->
    io:fread("Prompt> ","~s").
