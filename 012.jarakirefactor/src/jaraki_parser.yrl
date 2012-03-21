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
class_definition class_body class_list
method_definition
block block_expressions
function_call function_call_expr
var_declaration var_value var_type var_list
add_expr mult_expr rem_expr
unary_expr literal
comp_expr bool_expr
attribution
sqrt_expr
print_expr print_content if_expr if_else_expr if_else_no_trailing
return_expr
for_expr for_no_trailing
while_expr while_no_trailing
no_trailing_expr no_short_if_expr
parameters_list	parameter
argument argument_list
increment_expr_for increment_expr
expression.

Terminals
package import class public static void main return sqrt print println
'(' ')' '[' ']' '{' '}' ';' '=' '.' '.*' ','
int_t long_t float_t double_t boolean_t
'if' 'else' true false
for while
integer float
identifier text
add_op mult_op rem_op inc_op
comp_op	bool_op.
%% and_op or_op not_op.

Rootsymbol start_parser.

%% TODO: interpretar pacotes e imports na análise semântica
start_parser -> class_list	 				: '$1'.
start_parser -> package pack_path class_list			: '$3'.
start_parser -> package pack_path import_list class_list	: '$4'.
start_parser -> import_list class_list				: '$2'.

pack_path -> identifier ';'		: ['$1'].
pack_path -> identifier '.' pack_path	: ['$1' | '$3'].

import_list -> import import_path		: ['$2'] .
import_list -> import import_path import_list	: ['$2' | '$3'].

import_path -> identifier ';'			: ['$1'].
import_path -> identifier '.*' ';'		: [{'$1', '$2'}].
import_path -> identifier '.' import_path	: ['$1' | '$3'].

class_list -> class_definition			: ['$1'].
class_list -> class_definition class_list	: ['$1' | '$2'].

class_definition -> public class identifier '{' class_body '}':
	{line('$3'), {class, unwrap('$3')}, {class_body, '$5'}}.

class_body -> method_definition			: ['$1'].
class_body -> method_definition class_body	: ['$1' | '$2'].

method_definition -> public static var_type identifier '(' ')' block:
			{line('$4'), '$3', {method, unwrap('$4')}, [], '$7'}.

method_definition -> public static var_type identifier '(' parameters_list ')' block:
			{line('$4'), '$3', {method, unwrap('$4')}, '$6', '$8'}.

method_definition ->
	public static var_type main
	'(' identifier '[' ']' identifier ')' block:
		{line('$4'), '$3',
			{method, unwrap('$4')},
			[{line('$9'),
				{var_type, {line('$6'), unwrap('$6')}},
				{parameter, unwrap('$9')}}
			], '$11'}.

parameters_list -> parameter				: ['$1'].
parameters_list -> parameter ',' parameters_list	: ['$1' | '$3'].

parameter -> var_type identifier: {line('$2'), {var_type, '$1'},
						{parameter, unwrap('$2')}}.

block -> '{' block_expressions '}'	: {block, '$2'}.
block -> '{' '}': {block, []}.

block_expressions -> expression				: ['$1'].
block_expressions -> expression block_expressions	: ['$1'| '$2'].

%% expression: expressoes com trailing (if, while, for)
%%             ou sem trailing (no_trailing_expr)

expression -> function_call_expr: '$1'.
expression -> for_expr		: '$1'.
expression -> while_expr	: '$1'.
expression -> if_expr		: '$1'.
expression -> if_else_expr	: '$1'.
expression -> no_trailing_expr	: '$1'.


no_short_if_expr -> for_no_trailing	: '$1'.
no_short_if_expr -> while_no_trailing	: '$1'.
no_trailing_expr -> block		: '$1'.
no_trailing_expr -> var_declaration	: '$1'.
no_trailing_expr -> attribution 	: '$1'.
no_trailing_expr -> print_expr 		: '$1'.
no_trailing_expr -> increment_expr	: '$1'.
no_trailing_expr -> return_expr		: '$1'.
no_short_if_expr -> no_trailing_expr 	: '$1'.
no_short_if_expr -> if_else_no_trailing : '$1'.

%% Declaração de variáveis
var_declaration -> var_type var_list ';':
	{var_declaration, {var_type, '$1'}, {var_list, '$2'}}.
var_list -> identifier '=' var_value			:
		[{{var, unwrap('$1')}, {var_value, '$3'}}].
var_list -> identifier '=' var_value ',' var_list	:
		[{{var, unwrap('$1')}, {var_value, '$3'}} | '$5'].
var_list -> identifier	: [{{var, unwrap('$1')},{var_value, undefined}}].
var_list -> identifier	',' var_list:
		[{{var, unwrap('$1')}, {var_value, undefined}} | '$3'].

%% Atribuições
attribution ->	identifier '=' var_value ';':
	{line('$1'),
		attribution, {var, unwrap('$1')}, {var_value, '$3'}}.

sqrt_expr -> sqrt '(' var_value ')': {sqrt, line('$1'), '$3'}.

%% trata expressoes do tipo [ System.out.print( texto + identificador ) ]
print_expr -> print '(' print_content ')' ';':
	   {line('$1'), print, '$3'}.

%% trata expressoes do tipo [ System.out.println( texto + identificador ) ]
print_expr -> println '(' print_content ')' ';':
	   	   {line('$1'), println, '$3'}.


print_content -> text : ['$1'].

print_content -> identifier : ['$1'].

print_content -> text add_op print_content : ['$1' | '$3'].

print_content -> identifier add_op print_content : ['$1' | '$3'].

increment_expr_for -> identifier inc_op :
				Var = {var, line('$1'), unwrap('$1')},
				{inc_op, line('$1'), unwrap('$2'), Var}.

increment_expr -> identifier inc_op ';':
				Var = {var, line('$1'), unwrap('$1')},
				{inc_op, line('$1'), unwrap('$2'), Var}.

%% BEGIN_FOR
for_expr -> for '(' int_t identifier '=' integer ';' bool_expr ';'
				increment_expr_for  ')'  expression :
			{line('$1'), for,
				{for_init, {var_type, unwrap('$3')}, {var_name, unwrap('$4')}},
				{for_start, '$6'}, {condition_expr, '$8'},
				{inc_expr, '$10'}, {for_body, '$12'}}.

for_no_trailing -> for '(' int_t identifier '=' integer ';'
					bool_expr ';'
					increment_expr_for  ')'  no_short_if_expr :
			{line('$1'), for,
				{for_init, {var_type, unwrap('$3')}, {var_name, unwrap('$4')}},
				{for_start, '$6'}, {condition_expr, '$8'},
				{inc_expr, '$10'}, {for_body, '$12'}}.
%% END_FOR

%%BEGIN WHILE
while_expr -> while '(' bool_expr ')' expression:
	{line('$1'), while, {condition_expr, '$3'}, {while_body, '$5'}}.

while_no_trailing -> while '(' bool_expr ')' no_short_if_expr:
	{line('$1'), while, {condition_expr, '$3'}, {while_body, '$5'}}.
%%END WHILE

%% BEGIN_IF
if_expr -> 'if' '(' bool_expr ')' expression :
	{line('$1'), 'if', {bool_expr, '$3'}, {if_expr, '$5'}}.

if_else_expr -> 'if' '(' bool_expr ')' no_short_if_expr 'else' expression :
 	{line('$1'), 'if', {bool_expr, '$3'}, {if_expr, '$5'}, {else_expr, '$7'}}.

if_else_no_trailing -> 'if' '(' bool_expr ')' no_short_if_expr
						'else' no_short_if_expr :
	{line('$1'), 'if', {bool_expr, '$3'}, {if_expr, '$5'}, {else_expr, '$7'}}.
%% END_IF

%% BEGIN_FUNCTION

function_call_expr -> function_call ';' : '$1'.

function_call -> identifier '(' ')': 
			{function_call, {line('$1'), unwrap('$1')}, 
					{argument_list, []}}.

function_call -> identifier '(' argument_list ')': 
			{function_call, {line('$1'), unwrap('$1')}, 
				{argument_list, '$3'}}.

%% END_FUNCTION

%% BEGIN_RETURN

return_expr -> return var_value ';' : {line('$1'), return, '$2'}. 

%% END_RETURN

argument_list ->	argument			: ['$1'].
argument_list ->	argument ',' argument_list	: ['$1' | '$3'].

argument ->		var_value   			: '$1'.

var_type -> void	: {line('$1'), unwrap('$1')}.
var_type -> int_t	: {line('$1'), unwrap('$1')}.
var_type -> long_t	: {line('$1'), unwrap('$1')}.
var_type -> float_t	: {line('$1'), unwrap('$1')}.
var_type -> double_t	: {line('$1'), unwrap('$1')}.
var_type -> boolean_t	: {line('$1'), unwrap('$1')}.

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

mult_expr -> rem_expr mult_op mult_expr	:
			{op, line('$2'), unwrap('$2'), '$1', '$3'}.
mult_expr -> rem_expr						: '$1'.

rem_expr -> unary_expr rem_op rem_expr		:
			{op, line('$2'), 'rem', '$1', '$3'}.
rem_expr -> unary_expr						: '$1'.

unary_expr -> add_op literal    : {op, line('$1'), unwrap('$1'), '$2'}.
unary_expr -> literal           : '$1'.

literal -> function_call: '$1'.
literal -> sqrt_expr : '$1'.
literal -> integer : '$1'.
literal -> float : '$1'.
literal -> identifier :  {var, line('$1'), unwrap('$1')}.
literal -> '(' add_expr ')' : '$2'.
literal -> true : {atom, line('$1'), true}.
literal -> false: {atom, line('$1'), false}.

Erlang code.

unwrap({_, _, Value})	-> Value.
line({_, Line, _})	-> Line.
