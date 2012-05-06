-module(fibo).
-export([f/1]).

f(0) -> 0;
f(1) -> 1;
f(N) when N > 1 -> f(N-1)+f(N-2).
