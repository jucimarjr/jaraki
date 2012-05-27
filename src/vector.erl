%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%%			Eden ( edenstark@gmail.com )
%%			Helder Cunha Batista ( hcb007@gmail.com )
%%			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%%			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%%			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Array

-module(vector).
-export([new/1, access_vector/2, set_vector/3, size_vector/1, new_vector/1]).
-import(st, [update_counter/2, lookup/1, insert/2]).

%% new - Cria o endereço para o vetor declarado
new(ArrayValue) ->
	ArrayAddress = st:update_counter(array_address, 1),
	st:insert({array_dict, ArrayAddress}, ArrayValue),
	ArrayAddress.

%% Vetor instanciado
new_vector(Row) ->
	Array = array:new(Row, {default, 0}),
	new(Array).

%% get_vector - Retorna o valor do vetor da posição Address
%% Address - "posição de memória" do vetor
get_vector(Address) ->
	Key = {array_dict, Address},
	ArrayValue = st:lookup(Key),
	ArrayValue.

%% ArrayIndex - índice do vetor, ArrayAddr - "posição de memória" do vetor
access_vector(ArrayIndex, ArrayAddr) ->
	Array = get_vector(ArrayAddr),
	Value = array:get(ArrayIndex, Array),
	Value.

set_vector(ArrayIndex, ArrayValue, ArrayAddress) ->
	Array = get_vector(ArrayAddress),
	NewArray = array:set(ArrayIndex, ArrayValue, Array),
	st:insert({array_dict, ArrayAddress}, NewArray),
	ArrayAddress.

size_vector(ArrayAddress)->
	Array = get_vector(ArrayAddress),
	ArraySize = array:size(Array),
	ArraySize.
