%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%%			Eden ( edenstark@gmail.com )
%%			Helder Cunha Batista ( hcb007@gmail.com )
%%			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%%			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%%			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Array

-module(matrix).
-export(
	[
	new_matrix/1, access_matrix/3, set_matrix/4,
	size_matrix/1, creation_matrix/2, creation_vector/4]).
-import(st, [update_counter/2, lookup/1, insert/2]).

%% new - Cria o endereço para o vetor declarado
new_matrix(ArrayValue) ->
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
%% É preciso pegar o valor do array do array por isso a consulta pelo elemento
%% é realizado Duas vezes
%% Primeiro linha depois coluna
access_matrix(Row, Column ,ArrayAddr) ->
	Array = get_matrix(ArrayAddr),
	ValueTemp = array:get(Row, Array),
	Value = array:get(Column, ValueTemp),
	Value.

set_matrix(Row, Column, ArrayValue, ArrayAddress) ->
	Array = get_matrix(ArrayAddress),
	%%Captura o vetor que é determinada linha
	ValueTemp1 = array:get(Row, Array),
 	%%Atualiza o valor da coluna do vetor
	ValueTemp2 = array:set(Column, ArrayValue, ValueTemp1),
	%%Atualiza matriz
	NewArray = array:set(Row, ValueTemp2, Array),
	st:insert({array_dict, ArrayAddress}, NewArray),
	ArrayAddress.

%% Criacao da matriz instanciada
creation_matrix(Row, Column) ->
	Array1 = array:new(Row, {default, 0}),
	Array2 = array:new(Column, {default, 0}),
	RowLength = array:size(Array1),
	%% Seta para cada linha um array
	Matrix = creation_vector(0, Array1, Array2, RowLength - 1),
	new_matrix(Matrix).

%% Criação do vetor interno de tamanho N
%% Para cada linha é criado um vetor que corresponde a coluna da matriz
%% X = Contador
%% Array = Vetor Linha
%% ArrayColumn = Vetor Coluna
creation_vector(X, Array, ArrayColumn, RowLength) ->
	ArrayTemp =  array:set(X, ArrayColumn, Array),
	case X of
		RowLength ->
				ArrayTemp;
		_-> creation_vector(X + 1, ArrayTemp, ArrayColumn, RowLength)
	end.

size_matrix(ArrayAddress)->
	Array = get_matrix(ArrayAddress),
	ArraySize = array:size(Array),
	ArraySize.
