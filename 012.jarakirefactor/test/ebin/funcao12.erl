-module(funcao12).

-compile(export_all).

-import(loop, [for/3, while/2]).

imprime() ->
    st:get_new_stack(imprime),
    io:format("~s", ["Hello "]),
    io:format("~s~n", ["World"]).

main(V_Args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "Args"}, {'String', V_Args}),
    st:return_function(fun () -> imprime() end, imprime,
		       []),
    st:get_old_stack(main),
    st:destroy().

