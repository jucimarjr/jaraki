%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% 			Eden ( edenstark@gmail.com )
%% 			Helder Cunha Batista ( hcb007@gmail.com )
%% 			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% 			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% 			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Array

-module(matrix).
-export([new/1, access_matrix/3, set_matrix/4]).
-import(st, [update_counter/2, lookup/1, insert/2]).

%% new - Cria o endereço para o vetor declarado
new(ArrayValue) ->
	ArrayAddress = st:update_counter(array_address, 1),
	st:insert({array_dict, ArrayAddress}, ArrayValue),
	ArrayAddress.

%% get_vector - Retorna o valor do vetor da posição Address
%% Address - "posição de memória" do vetor
get_matrix(Address) ->
	Key = {array_dict, Address},
	ArrayValue = st:lookup(Key),
	ArrayValue.

%% ArrayIndex - índice da matrix, ArrayAddr - "posição de memória" da matrix
%% É preciso pegar o valor do array do array por isso a consulta pelo elemento é realizado Duas vezes
%% Primeiro linha depois coluna
access_matrix(Line, Column ,ArrayAddr) ->	
	Array = get_matrix(ArrayAddr),
	ValueTemp = array:get(Line, Array),
	Value = array:get(Column, ValueTemp),
	Value.

set_matrix(Line, Column, ArrayValue, ArrayAddress) ->
	Array = get_matrix(ArrayAddress),
	%%Captura o vetor que é determinada linha
	ValueTemp1 = array:get(Line, Array),
 	%%Atualiza o valor da coluna do vetor
	ValueTemp2 = array:set(Column, ArrayValue, ValueTemp1),
	%%Atualiza matriz
	NewArray = array:set(Line, ValueTemp2, Array),
	st:insert({array_dict, ArrayAddress}, NewArray),
	ArrayAddress.

