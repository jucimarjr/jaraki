-module(hello).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(Var_Args1) ->
    st:new(), io:format("~s~n", ["Hello World"]).

