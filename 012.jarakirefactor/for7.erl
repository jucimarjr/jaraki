-module(for7).

-compile(export_all).

-import(loop, [for/3, while/2]).

main(Var_Args1) ->
    st:new(),
    begin Var_s1 = 0, st:insert({"s", Var_s1}) end,
    begin
      Var_denominador1 = 1,
      st:insert({"denominador", Var_denominador1})
    end,
    begin
      Var_numerador1 = 1,
      st:insert({"numerador", Var_numerador1})
    end,
    begin
      st:insert({"i", 1}),
      for(fun () -> st:get("i") =< 10 end,
	  fun () -> st:insert({"i", st:get("i") + 1}) end,
	  fun () ->
		  Var_s2 = st:get("s"),
		  Var_i2 = st:get("i"),
		  Var_nota32 = st:get("nota3"),
		  Var_mediaFinal2 = st:get("mediaFinal"),
		  Var_c2 = st:get("c"),
		  Var_nota22 = st:get("nota2"),
		  Var_denominador2 = st:get("denominador"),
		  Var_Args2 = st:get("Args"),
		  Var_nota12 = st:get("nota1"),
		  Var_numerador2 = st:get("numerador"),
		  Var_media2 = st:get("media"),
		  Var_a3 = st:get("a"),
		  Var_b2 = st:get("b"),
		  io:format("~p", [Var_numerador2]),
		  io:format("/"),
		  io:format("~p", [Var_denominador2]),
		  io:format(" , "),
		  begin
		    Var_denominador3 = Var_denominador2 + Var_i2,
		    st:insert({"denominador", Var_denominador3})
		  end,
		  begin
		    Var_numerador3 = Var_numerador2 * Var_i2,
		    st:insert({"numerador", Var_numerador3})
		  end,
		  begin
		    Var_s3 = Var_s2 + Var_numerador3 / Var_denominador3,
		    st:insert({"s", Var_s3})
		  end,
		  st:insert({"s", Var_s3}),
		  st:insert({"i", Var_i2}),
		  st:insert({"nota3", Var_nota32}),
		  st:insert({"mediaFinal", Var_mediaFinal2}),
		  st:insert({"c", Var_c2}),
		  st:insert({"nota2", Var_nota22}),
		  st:insert({"denominador", Var_denominador3}),
		  st:insert({"nota1", Var_nota12}),
		  st:insert({"Args", Var_Args2}),
		  st:insert({"numerador", Var_numerador3}),
		  st:insert({"media", Var_media2}),
		  st:insert({"a", Var_a3}),
		  st:insert({"b", Var_b2})
	  end),
      st:delete("i"),
      Var_s4 = st:get("s"),
      Var_nota33 = st:get("nota3"),
      Var_mediaFinal3 = st:get("mediaFinal"),
      Var_c3 = st:get("c"),
      Var_nota23 = st:get("nota2"),
      Var_denominador4 = st:get("denominador"),
      Var_nota13 = st:get("nota1"),
      Var_Args3 = st:get("Args"),
      Var_numerador4 = st:get("numerador"),
      Var_media3 = st:get("media"),
      Var_a4 = st:get("a"),
      Var_b3 = st:get("b")
    end,
    io:format("~p~n", [Var_s4]).

