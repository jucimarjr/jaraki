%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% Aluno  : Eden ( edenstark@gmail.com )
%% Aluno  : Helder Cunha Batista ( hcb007@gmail.com )
%% Aluno  : Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% Aluno  : Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% Aluno  : Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Gerar os analisadores lexico e sintatico e compilar o compilador

%%-vsn(0.004).
%%-author('uea_ludus@googlegroups.com').

%%-----------------------------------------------------------------------------
%% Definições das regras do analisador sintatico do compilador
Nonterminals
start_parser
class_definition	class_body
method_definition	method_body
var_value	var_type
%%argument argument_list
expression.

Terminals
class public static void main print println
'(' ')' '[' ']' '{' '}' ';' '=' %% ','
int float double
integer real
identifier text.

Rootsymbol start_parser.

start_parser -> class_definition				: ['$1'].
start_parser -> class_definition start_parser	: ['$1' | '$2'].

class_definition -> public class identifier '{' class_body '}':
	{line('$3'), {class, unwrap('$3')}, {class_body, '$5'}}.

class_body -> method_definition					: ['$1'].
class_body -> method_definition class_body  	: ['$1' | '$2'].

method_definition ->
	public static void main
	'(' identifier '[' ']' identifier ')' '{' method_body '}':
		{line('$4'),
			{method, unwrap('$4')},
			[{line('$9'),
				{class_identifier, unwrap('$6')},
				{argument, unwrap('$9')}}
			], {method_body, '$12'}}.

%%argument_list -> argument 					: ['$1'].
%%argument_list -> argument ',' argument_list	: ['$1' | '$2'].

%%argument -> identifier '[' ']' identifier:
%%{line('$4'), {type, '$1'}, {argument, unwrap('$4')}}.
%%Desabilitado porque o método main deverá ter apenas um argumento.

method_body -> expression 				: ['$1'].
method_body -> expression method_body	: ['$1' | '$2'].

expression ->	var_type identifier ';':
	{line('$2'),
		var_declaration, {var_type, '$1'}, {identifier, unwrap('$2')}}.

%% trata expressoes do tipo [ identificador = valor ]
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

var_type ->	int		:	unwrap('$1').
var_type ->	float	:	unwrap('$1').
var_type ->	double	:	unwrap('$1').

var_value ->	integer 	: '$1'.
var_value ->	real		: '$1'.


Erlang code.

unwrap({_, _, V})	-> V.
line({_, Line, _}) 	-> Line.
