%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%%			Eden ( edenstark@gmail.com )
%%			Helder Cunha Batista ( hcb007@gmail.com )
%%			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%%			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%%			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo :

%%-----------------------------------------------------------------------------
%% Definições das regras do analisador sintatico do compilador
Nonterminals
start_parser
import_list import_path
pack_path
class_definition	class_body	class_list
method_definition	block
var_value	var_type	var_list
add_expr	mult_expr
unary_expr	literal
comp_expr	bool_expr
if_expr
if_expr1	if_expr2
%%argument argument_list
expression	any_expression.

Terminals
package import class public static void main print println
'(' ')' '[' ']' '{' '}' ';' '=' '.' '.*' ','
int_t float_t double_t
'if' 'else' %true false
integer float
identifier text
add_op	mult_op
comp_op	bool_op.
%% and_op	or_op	not_op.

Rootsymbol start_parser.

%% TODO: interpretar pacotes e imports na análise semântica
start_parser -> class_list									: '$1'.
start_parser -> package pack_path class_list				: '$3'.
start_parser -> package pack_path import_list class_list	: '$4'.
start_parser -> import_list class_list						: '$2'.

pack_path -> identifier ';'				: ['$1'].
pack_path -> identifier '.' pack_path	: ['$1' | '$3'].

import_list -> import import_path				: ['$2'] .
import_list -> import import_path import_list	: ['$2' | '$3'].

import_path -> identifier ';'				: ['$1'].
import_path -> identifier '.*' ';'			: [{'$1', '$2'}].
import_path -> identifier '.' import_path	: ['$1' | '$3'].

class_list -> class_definition				: ['$1'].
class_list -> class_definition class_list	: ['$1' | '$2'].

class_definition -> public class identifier '{' class_body '}':
	{line('$3'), {class, unwrap('$3')}, {class_body, '$5'}}.

class_body -> method_definition					: ['$1'].
class_body -> method_definition class_body		: ['$1' | '$2'].

method_definition ->
	public static void main
	'(' identifier '[' ']' identifier ')' '{' block '}':
		{line('$4'),
			{method, unwrap('$4')},
			[{line('$9'),
				{class_identifier, unwrap('$6')},
				{argument, unwrap('$9')}}
			], {block, '$12'}}.

%%argument_list -> argument						: ['$1'].
%%argument_list -> argument ',' argument_list	: ['$1' | '$2'].

%%argument -> identifier '[' ']' identifier:
%%{line('$4'), {type, '$1'}, {argument, unwrap('$4')}}.
%%Desabilitado porque o método main deverá ter apenas um argumento.

block -> any_expression			: ['$1'].
block -> any_expression block	: ['$1' | '$2'].

var_list -> identifier: [{identifier, unwrap('$1')}].
var_list -> identifier ',' var_list : [{identifier, unwrap('$1')} | '$3'].

any_expression -> if_expr : '$1'.
any_expression -> expression : '$1'.

%% trata expressoes do tipo [ identificador = valor ]
expression ->	var_type var_list ';':
	{var_declaration, {var_type, '$1'}, {var_list, '$2'}}.

expression ->	identifier '=' var_value ';':
	{line('$1'),
		attribution, {var, unwrap('$1')}, {var_value, '$3'}}.

%% trata expressoes do tipo [ System.out.print( texto )	]
expression ->	print	'(' text ')' ';':
	{line('$1'),	print,	{text, unwrap('$3')}}.

%% trata expressoes do tipo [ System.out.println( texto ) ]
expression ->	println '(' text ')' ';':
	{line('$1'),	println,	{text, unwrap('$3')}}.

%% trata expressoes do tipo [ System.out.print( identificador )	]
expression ->	print '(' identifier ')' ';':
	{line('$1'),	print,	{var, unwrap('$3')}}.

%% trata expressoes do tipo [ System.out.println( texto ) ]
expression ->	println '(' identifier ')' ';':
	{line('$1'),	println,	{var, unwrap('$3')}}.

%% Estruturas de controle
%%expression	-> block_expr: '$1'.

%% Expressoes do tipo "bloco", sao as estruturas de controle
% Sugestao de block_expr para control_expr
% block_expr	-> for_expr: '$1'.

%% expression nao contem if_expr

if_expr -> if_expr1 : '$1'.
if_expr -> if_expr2 : '$1'.

if_expr1 -> 'if' '(' bool_expr ')' if_expr1 'else' if_expr1 :
	{line('$1'), 'if', {bool_expr, '$3'}, {if_expr, '$5'}, {else_expr, '$7'}}.
if_expr1 -> 'if' '(' bool_expr ')' expression 'else' if_expr1 :
	{line('$1'), 'if', {bool_expr, '$3'}, {if_expr, '$5'}, {else_expr, '$7'}}.
if_expr1 -> 'if' '(' bool_expr ')' if_expr1 'else' expression :
	{line('$1'), 'if', {bool_expr, '$3'}, {if_expr, '$5'}, {else_expr, '$7'}}.
if_expr1 -> 'if' '(' bool_expr ')' expression 'else' expression :
	{line('$1'),'if',{bool_expr, '$3'}, {if_expr, '$5'}, {else_expr, '$7'}}.

if_expr1 -> '{' block '}'	: {block, '$2'}.

if_expr2 -> 'if' '(' bool_expr ')' if_expr :
	{line('$1'), 'if', {bool_expr, '$3'}, {if_expr, '$5'}}.
if_expr2 -> 'if' '(' bool_expr ')' if_expr1 'else' if_expr2 :
	{line('$1'), 'if', {bool_expr, '$3'}, {if_expr, '$5'}, {else_expr, '$7'}}.
if_expr2 -> 'if' '(' bool_expr ')' expression 'else' if_expr2 :
	{line('$1'), 'if', {bool_expr, '$3'}, {if_expr, '$5'}, {else_expr, '$7'}}.


var_type ->	int_t		:	{line('$1'), unwrap('$1')}.
var_type ->	float_t		:	{line('$1'), unwrap('$1')}.
var_type ->	double_t	:	{line('$1'), unwrap('$1')}.

%% -Trata expressoes matematicas (numericas).
%% TODO: acrescentar tipo boolean e tratar precedencia de op booleanos
%% TODO: tratar o not (!)
var_value -> bool_expr : '$1'.

bool_expr -> comp_expr bool_op bool_expr	:
			{op, line('$2'), unwrap('$2'), '$1', '$3'}.
bool_expr -> comp_expr						: '$1'.

comp_expr -> add_expr comp_op comp_expr		:
			{op, line('$2'), unwrap('$2'), '$1', '$3'}.
comp_expr -> add_expr						: '$1'.

add_expr -> mult_expr add_op add_expr		:
			{op, line('$2'), unwrap('$2'), '$1', '$3'}.
add_expr -> mult_expr						: '$1'.

mult_expr -> unary_expr mult_op mult_expr	:
			{op, line('$2'), unwrap('$2'), '$1', '$3'}.
mult_expr -> unary_expr						: '$1'.

unary_expr -> add_op literal    : {op, line('$1'), unwrap('$1'), '$2'}.
unary_expr -> literal           : '$1'.

literal -> integer : '$1'.
literal -> float : '$1'.
literal -> identifier :  {var, line('$1'), unwrap('$1')}.
literal -> '(' add_expr ')' : '$2'.


Erlang code.

unwrap({_, _, V})	-> V.
line({_, Line, _})	-> Line.
