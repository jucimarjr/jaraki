
%%-----------------------------------------------------------------------------
%% modulo testes de desempenho em erlang
%%-----------------------------------------------------------------------------

-module(fibo).
-compile(export_all).

%%-----------------------------------------------------------------------------
%% calcula o quadrado de N
quad(N) ->
	N * N.

%%-----------------------------------------------------------------------------
%% calcula o cubo de N
cubo(N) ->
	N*N*N.

%%-----------------------------------------------------------------------------
%% calcula o fibonacci de N
fib1(0) -> 0;
fib1(1) -> 0;
fib1(2) -> 1;
fib1(N) -> fib1(N-1) + fib1(N-2).

%%-----------------------------------------------------------------------------
%% calcula lista de fibonacci de N
fib2(N) ->
    fib2(N, 0, 1, []).
fib2(0, _Current, _Next, Fibs) ->
    Fibs;
fib2(N, Current, Next, Fibs) ->
    fib2(N - 1, Next, Current + Next, Fibs ++ [Current]).

%%-----------------------------------------------------------------------------
%% calcula lista de fibonacci de N
fib3(N) ->
    fib3(N, 0, 1, []).
fib3(0, _Current, _Next, Fibs) ->
    lists:reverse(Fibs);
fib3(N, Current, Next, Fibs) ->
    fib3(N - 1, Next, Current + Next, [Current|Fibs]).

%%-----------------------------------------------------------------------------
%% calcula lista de fibonacci de N
fib31(N) ->
    fib31(N, 0, 1, []).
fib31(0, _Current, _Next, Fibs) ->
    lists:reverse(Fibs);
fib31(N, Current, Next, Fibs) ->
    fib31(N - 1, Next, Current + Next, [Current] ++ Fibs).


%%-----------------------------------------------------------------------------
%% calcula lista de fibonacci de N
fib4(N) ->
    fib4(N, 0, 1, []).
fib4(0, _Current, _Next, Fibs) ->
    Fibs;
fib4(N, Current, Next, Fibs) ->
	fib4(N - 1, Next, Current + Next, [Current] ++ Fibs).


%%-----------------------------------------------------------------------------
%% calcula o tempo de execução de uma funcao em microssegundos
get_runtime(Func, N)->
	{ElapsedTime, R} = timer:tc(fibo, Func, [N]),
	io:format("~p(~p): ~p [~p us]~n",[Func, N, R, ElapsedTime]).

%%-----------------------------------------------------------------------------
%% roda os testes de desempenho
run(N) ->
	get_runtime(fib1 , N),
	get_runtime(fib2 , N),
	get_runtime(fib3 , N),
	get_runtime(fib4 , N),
	get_runtime(fib31, N ),
	get_runtime(quad, N ),
	get_runtime(cubo, N ).

