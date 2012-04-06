-module(funcao14).

-compile(export_all).

-import(loop, [for/3, while/2]).

imprimeVariavel() ->
    st:get_new_stack(imprimeVariavel),
    st:put_value({imprimeVariavel, "a"}, {int, 5}),
    case st:get_value(imprimeVariavel, "a") < 2 of
      true ->
	  io:format("~p~n", [st:get_value(imprimeVariavel, "a")]);
      false -> no_operation
    end.

main(V_Args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "Args"}, {'String', V_Args}),
    st:return_function(fun () -> imprimeVariavel() end,
		       imprimeVariavel, []),
    st:get_old_stack(main),
    st:destroy().

