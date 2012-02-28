%% Esse record define uma variavel, usado na analise semantica
%%  campos:
%%    java_name  -  nome que aparece no codigo em java   (nomeVariavel)
%%    erl_name   -  nome como ficara no codigo em erlang (V_nomeVariavel)
%%    type       -  tipo da variavel (int, float, etc)
%%    value      -  valor atual da variavel
%%    counter    -  quantas vezes a variavel foi utilizada, o numero de counter
%%                  é acrescido ao nome da variavel no codigo gerado
%%                  (V_nomeVariavel1)
-record( var, { java_name, erl_name, type, value, counter = 0 } ).
