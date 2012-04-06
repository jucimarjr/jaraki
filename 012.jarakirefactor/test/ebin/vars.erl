-module(vars).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(V_Args) ->
    st:new(),
    st:get_new_stack(main),
    st:put_value({main, "Args"}, {'String', V_Args}),
    begin
      st:put_value({main, "b"}, {int, 3}),
      st:put_value({main, "c"}, {int, 4})
    end,
    st:put_value({main, "e"}, {int, 4}),
    st:put_value({main, "c"}, {int, 2}),
    io:format("~p~n", [st:get_value(main, "b")]),
    io:format("~s~n", ["Hello World"]),
    io:format("~p", [st:get_value(main, "c")]),
    io:format("~s", ["Hello World"]),
    io:format("~p", [st:get_value(main, "e")]),
    st:get_old_stack(main),
    st:destroy().

