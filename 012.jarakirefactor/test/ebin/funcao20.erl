-module(funcao20).

-compile(export_all).

-import(loop, [for/3, while/2]).

imprimeVariavel(V_a) ->
    st:get_new_stack(imprimeVariavel),
    st:put_value({imprimeVariavel, "a"}, {int, V_a}),
    io:format("~s", ["O valor de a: "]),
    io:format("~p~n", [st:get_value(imprimeVariavel, "a")]).

main(V_Args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "Args"}, {'String', V_Args}),
    st:put_value({main, "x"}, {int, 5}),
    st:return_function(fun () ->
			       imprimeVariavel(st:get_value(main, "x"))
		       end,
		       imprimeVariavel, [st:get_value(main, "x")]),
    st:get_old_stack(main),
    st:destroy().

