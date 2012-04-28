%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% 			Eden ( edenstark@gmail.com )
%% 			Helder Cunha Batista ( hcb007@gmail.com )
%% 			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% 			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% 			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Array

-module(vector).
-export([new/1, access_array/2, put_array/3]).
-import(st, [update_counter/2, lookup/1, insert/2]).

%% new - Cria o endereço para o vetor declarado
new(ArrayValue) ->
	ArrayAddress = st:update_counter(array_address, 1),
	st:insert({array_dict, ArrayAddress}, ArrayValue),
	ArrayAddress.

%% get_vector - Retorna o valor do vetor da posição Address
%% Address - "posição de memória" do vetor
get_vector(Address) ->
	Key = {array_dict, Address},
	ArrayValue = st:lookup(Key),
	ArrayValue.

%% ArrayIndex - índice do vetor, ArrayAddr - "posição de memória" do vetor
access_array(ArrayIndex, ArrayAddr) ->	
	Array = get_vector(ArrayAddr),
	Value = array:get(ArrayIndex, Array),
	Value.

put_array(ArrayIndex, ArrayValue, ArrayAddr) ->
	Array = get_vector(ArrayAddr),
	array:set(ArrayIndex, ArrayValue, Array).
