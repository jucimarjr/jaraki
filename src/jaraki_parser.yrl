%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%%			Eden ( edenstark@gmail.com )
%%			Helder Cunha Batista ( hcb007@gmail.com )
%%			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%%			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%%			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Definições das regras do analisador sintatico do compilador

Nonterminals
start_parser
import_list				import_declaration
qualified_identifier
class_declaration		class_body			class_list
method_declaration		field_declaration	modifiers
constructor_declaration
block_statements		block
method_invocation		field_access

%% variables
local_variable_declaration_statement		element_value			type
variable_list								element_value_pair

%% arrays
array_declaration_list		array_declaration_list2		array_declaration_list3
array_initializer			array_access
new_stmt

%% expressions
comparation_expr	add_expr	mult_expr	modulus_expr	unary_expr
literal				bool_expr	sqrt_stmt	length_stmt

%% functions
print_stmt		print_content	next_int_stmt	next_float_stmt
next_line_stmt	read_stmt		write_stmt		close_stmt

%% statements
if_stmt		if_else_stmt		if_else_no_trailing		no_short_if_stmt
for_stmt	for_no_trailing		no_trailing_stmt		return_statement
parameter	parameters_list		while_stmt				while_no_trailing
do_while_stmt
for_update	post_increment_expr

try_catch_stmt

argument	argument_list
catches		catch_clause break_stmt

statement.

Terminals
package import class public static void extends
return sqrt random print scanner
length
'(' ')' '[' ']' '{' '}' ';' '=' '.' '.*' ','
string_t int_t long_t float_t double_t boolean_t char_t
next_int	next_line	next_float	new this system_in
'if' 'else' true false
for while	'do'	try catch break exception
io_exception 'throws'
file_reader	file_writer	write  read  close
integer float
identifier text singles_quotes
add_op mult_op modulus_op increment_op
comparation_op	bool_op.

Rootsymbol start_parser.

%% TODO: interpretar pacotes e imports na análise semântica
start_parser -> class_list											: '$1'.
start_parser -> package qualified_identifier class_list				:
					[{line('$1'), {package,'$2'}, {class_list, '$3'}}].
start_parser -> package qualified_identifier import_list class_list	: '$4'.
start_parser -> import_list class_list								: '$2'.

qualified_identifier -> identifier ';'						: [unwrap('$1')].
qualified_identifier -> identifier '.' qualified_identifier	:
														[unwrap('$1') | '$3'].

import_list -> import import_declaration				: ['$2'] .
import_list -> import import_declaration import_list	: ['$2' | '$3'].

import_declaration -> identifier ';'					: ['$1'].
import_declaration -> identifier '.*' ';'				: [{'$1', '$2'}].
import_declaration -> identifier '.' import_declaration	: ['$1' | '$3'].
import_declaration -> scanner ';' : ['$1'].
import_declaration -> random ';' : ['$1'].
import_declaration -> file_reader ';' : ['$1'].
import_declaration -> file_writer ';' : ['$1'].
import_declaration -> io_exception ';' : ['$1'].

class_list -> class_declaration				: ['$1'].
class_list -> class_declaration class_list	: ['$1' | '$2'].

class_declaration -> public class identifier '{' class_body '}':
	Parent = {parent,  null},
	{class, {line('$3'), {name, unwrap('$3')}, Parent, {body, '$5'}}}.

class_declaration -> public class identifier
							extends identifier '{' class_body '}':
	Name   = {name, unwrap('$3')},
	Parent = {parent,  unwrap('$5')},
	Body   = {body, '$7'},
	{class, {line('$3'), Name, Parent, Body}}.

%% MethodOrFieldDecl
class_body -> method_declaration			: ['$1'].
class_body -> field_declaration				: ['$1'].
class_body -> constructor_declaration		: ['$1'].
class_body -> method_declaration class_body	: ['$1' | '$2'].
class_body -> field_declaration class_body	: ['$1' | '$2'].
class_body -> constructor_declaration class_body	: ['$1' | '$2'].

field_declaration -> local_variable_declaration_statement:
	'$1'.

modifiers -> public static : [unwrap('$1'), unwrap('$2')].
modifiers -> public : [unwrap('$1')].

%% declaração de construtores
constructor_declaration -> public identifier '(' ')' block:
	Name = {name, unwrap('$2')},
	Modifier = {visibility, '$1'},
	{constructor, {line('$2'), Name, Modifier, [], '$5'}}.

constructor_declaration -> public identifier '(' parameters_list ')' block:
	Name = {name, unwrap('$2')},
	Modifier = {visibility, '$1'},
	{constructor, {line('$2'), Name, Modifier, '$4', '$6'}}.

%% declaração de métodos
method_declaration -> modifiers type identifier '(' ')' block:
	Return = {return, '$2'},
	Name = {name, unwrap('$3')},
	Modifiers = {modifiers, '$1'},
	{method, {line('$3'), Return, Name, Modifiers, [], '$6'}}.

method_declaration -> modifiers type identifier
					'(' parameters_list ')' block:
	Return = {return, '$2'},
	Name   = {name, unwrap('$3')},
	Modifiers = {modifiers, '$1'},
	{method, {line('$3'), Return, Name, Modifiers, '$5', '$7'}}.

%% IOexception
method_declaration -> modifiers type identifier
					'(' parameters_list ')' 'throws' io_exception block:
	Return = {return, '$2'},
	Name   = {name, unwrap('$3')},
	Modifiers = {modifiers, '$1'},
	{method, {line('$3'), Return, Name, Modifiers, '$5', '$9'}}.

%% Vector
method_declaration -> modifiers type '[' ']' identifier '(' ')' block:
	Return = {return, make_array_type('$2')},
	Name   = {name, unwrap('$5')},
	Modifiers = {modifiers, '$1'},
	{method, {line('$5'), Return, Name, Modifiers, [], '$8'}}.

method_declaration -> modifiers type '[' ']' identifier
					'(' parameters_list ')' block:

	Return = {return, make_array_type('$2')},
	Name   = {name, unwrap('$5')},
	Modifiers = {modifiers, '$1'},
	{method, {line('$5'), Return, Name, Modifiers, '$7', '$9'}}.

%% Matriz
method_declaration -> modifiers type '[' ']' '[' ']'
										identifier '(' ')' block:
	Return = {return, make_matrix_type('$2')},
	Name   = {name, unwrap('$7')},
	Modifiers = {modifiers, '$1'},
	{method, {line('$7'), Return, Name, Modifiers, [], '$10'}}.

method_declaration -> modifiers type '[' ']' '[' ']' identifier
					'(' parameters_list ')' block:
	Return = {return, make_matrix_type('$2')},
	Name   = {name, unwrap('$7')},
	Modifiers = {modifiers, '$1'},
	{method, {line('$7'), Return, Name, Modifiers, '$9', '$11'}}.

%% método main na análise sintática obsoleto
%% method_declaration ->
%% 	public static type main
%% 	'(' string_t '[' ']' identifier ')' block:
%% 		{line('$4'), '$3',
%% 			{method, unwrap('$4')},
%% 			[{line('$9'),
%% 				{var_type, {line('$6'), unwrap('$6')}},
%% 				{parameter, unwrap('$9')}}
%% 			], '$11'}.

parameters_list -> parameter				: ['$1'].
parameters_list -> parameter ',' parameters_list	: ['$1' | '$3'].

parameter -> type identifier: {line('$2'), {var_type, '$1'},
						{parameter, unwrap('$2')}}.

%% Vetor
parameter -> type '[' ']' identifier:
			{line('$4'),
				{var_type, make_array_type('$1')},
				{parameter, unwrap('$4')}}.

parameter -> type identifier '[' ']':
			{line('$2'),
				{var_type, make_array_type('$1')},
				{parameter, unwrap('$2')}}.

%% Matriz
parameter -> type '[' ']' '[' ']' identifier:
			{line('$6'),
				{var_type, make_matrix_type('$1')},
				{parameter, unwrap('$6')}}.

parameter -> type identifier '[' ']' '[' ']':
			{line('$2'),
				{var_type, make_matrix_type('$1')},
				{parameter, unwrap('$2')}}.


block -> '{' block_statements '}'	: {block, element(2, '$1'), '$2'}.
block -> '{' '}': {block, element(2, '$1'), []}.

block_statements -> statement					: ['$1'].
block_statements -> statement block_statements	: ['$1'| '$2'].

%% expression: expressoes com trailing (if, while, for)
%%             ou sem trailing (no_trailing_expr)

statement -> method_invocation ';'	: '$1'.
statement -> for_stmt				: '$1'.
statement -> while_stmt				: '$1'.
statement -> if_stmt				: '$1'.
statement -> if_else_stmt			: '$1'.
statement -> try_catch_stmt			: '$1'.
statement -> break_stmt				: '$1'.
statement -> no_trailing_stmt		: '$1'.

no_short_if_stmt -> for_no_trailing						: '$1'.
no_short_if_stmt -> while_no_trailing					: '$1'.
no_short_if_stmt -> no_trailing_stmt					: '$1'.
no_short_if_stmt -> if_else_no_trailing					: '$1'.

no_trailing_stmt -> block								: '$1'.
no_trailing_stmt -> local_variable_declaration_statement: '$1'.
no_trailing_stmt -> element_value_pair					: '$1'.
no_trailing_stmt -> print_stmt							: '$1'.
no_trailing_stmt -> post_increment_expr					: '$1'.
no_trailing_stmt -> return_statement					: '$1'.
no_trailing_stmt -> write_stmt							: '$1'.
no_trailing_stmt -> close_stmt							: '$1'.
no_trailing_stmt -> do_while_stmt							: '$1'.

%% Declaração de variáveis
local_variable_declaration_statement -> type variable_list ';':
	{var_declaration, {var_type, '$1'}, {var_list, '$2'}}.

%% declaração de variáveis de referência (para objetos)
local_variable_declaration_statement -> identifier variable_list ';':
	Type = {line('$1'), unwrap('$1')},
	{var_declaration, {var_type, Type}, {var_list, '$2'}}.

%% declaração de variáveis de referência
%% (para objetos random, scanner e FileReader)
local_variable_declaration_statement -> random variable_list ';':
	Type = {line('$1'), unwrap('$1')},
	{var_declaration, {var_type, Type}, {var_list, '$2'}}.

local_variable_declaration_statement -> scanner variable_list ';':
	Type = {line('$1'), unwrap('$1')},
	{var_declaration, {var_type, Type}, {var_list, '$2'}}.

local_variable_declaration_statement -> file_reader variable_list ';':
	Type = {line('$1'), unwrap('$1')},
	{var_declaration, {var_type, Type}, {var_list, '$2'}}.


local_variable_declaration_statement -> file_writer variable_list ';':
	Type = {line('$1'), unwrap('$1')},
	{var_declaration, {var_type, Type}, {var_list, '$2'}}.
%%-------------

variable_list -> identifier '=' element_value			:
		[{{var, unwrap('$1')}, {var_value, '$3'}}].
variable_list -> identifier '=' element_value ',' variable_list	:
		[{{var, unwrap('$1')}, {var_value, '$3'}} | '$5'].
variable_list -> identifier	:
		[{{var, unwrap('$1')},{var_value, undefined}}].
variable_list -> identifier	',' variable_list:
		[{{var, unwrap('$1')}, {var_value, undefined}} | '$3'].

%% Declaração de vetor
%% TODO: verificar array_initializer
%%       verificar regras repetidas - otimizar
%%		 verificar tipo matrix
local_variable_declaration_statement ->  type '[' ']' array_declaration_list';':
	{var_declaration,
		{var_type, make_array_type('$1')},
		{var_list, '$4'}}.

local_variable_declaration_statement ->  type '[' ']' '[' ']'
									array_declaration_list';':
	{var_declaration,
		{var_type, make_matrix_type('$1')},
		{var_list, '$6'}}.

local_variable_declaration_statement ->  type  array_declaration_list2';':
	{var_declaration,
		{var_type, make_array_type('$1')},
		{var_list, '$2'}}.

local_variable_declaration_statement ->  type  array_declaration_list3';':
	{var_declaration,
		{var_type, make_matrix_type('$1')},
		{var_list, '$2'}}.

%% ------------------------------------------
array_declaration_list -> identifier:
				[{{var, unwrap('$1')},{var_value, undefined}}].

array_declaration_list -> identifier ',' array_declaration_list:
		[{{var, unwrap('$1')}, {var_value, undefined}} | '$3'].

array_declaration_list -> identifier '=' '{' array_initializer '}':
			[{{var, unwrap('$1')}, {var_value, {array_initializer, '$4'}}}].

array_declaration_list -> identifier '=' new_stmt:
			[{{var, unwrap('$1')}, {var_value, '$3'}}].

% declaração vetor
% TODO: element_value - erro de shift reduce
new_stmt -> 'new' type '[' integer ']':
		{new, array, {type, '$2'}, {index, '$4'}}.

new_stmt -> 'new' type '[' identifier ']':
		{new, array, {type, '$2'}, {index, {var, line('$4'), unwrap('$4')}}}.

new_stmt -> 'new' type '[' length_stmt ']':
		{new, array, {type, '$2'}, {index, '$4'}}.

% declaração matriz
new_stmt -> 'new' type '[' integer ']' '[' integer ']':
		{new, array, {type, '$2'}, {index, {row, '$4'}, {column, '$7'}}}.

new_stmt -> 'new' type '[' identifier ']' '[' identifier ']': {new, array,
			{type, '$2'}, {index, {row, {var, line('$4'), unwrap('$4')} },
						{column, {var, line('$7'), unwrap('$7')}} } }.

new_stmt -> 'new' type '[' identifier ']' '[' integer ']': {new, array,
			{type, '$2'}, {index, {row, {var, line('$4'), unwrap('$4')}},
						{column, '$7'} } }.

new_stmt -> 'new' type '[' integer ']' '[' identifier ']': {new, array,
			{type, '$2'}, {index, {row, '$4'}, {column,
						{var, line('$7'), unwrap('$7')}} } }.

% declaração de instâncias de classes predefinidas
% (Scanner, Random e FileReader)
new_stmt -> 'new' scanner '(' ')':
		Type = {line('$2'), unwrap('$2')},
		{new, object, {type, Type}}.

new_stmt -> 'new' random '(' ')':
		Type = {line('$2'), unwrap('$2')},
		{new, object, {type, Type}}.

new_stmt -> 'new' scanner '(' system_in ')':
		Type = {line('$2'), unwrap('$2')},
		{new, object, {type, Type}}.

new_stmt -> 'new' file_reader '(' text ')':
		Type = {line('$2'), unwrap('$2')},
		{new, object, {type, Type}, {file_reader, unwrap('$4')}}.

new_stmt -> 'new' file_writer '(' text ',' true ')':
		Type = {line('$2'), unwrap('$2')},
		{new, object, {type, Type}, {file_writer, unwrap('$4')}}.

%% Funcoes da classe FileReader e FileWrite

read_stmt -> identifier '.' read '(' ')' :
					{read, line('$1'),  unwrap('$1')}.


write_stmt -> identifier '.' write '(' text ')' ';':
					{write, line('$1'),  unwrap('$1'),
						{write_text, unwrap('$5')}}.

write_stmt -> identifier '.' write '(' identifier ')' ';':
					{write, line('$1'),  unwrap('$1'),
							{write_text, unwrap('$5')}}.

close_stmt -> identifier '.' close '(' ')' ';':
				{close, line('$1'), unwrap('$1')}.


% instanciação de objetos de qualquer classe, CONSTRUTOR PADRÃO
new_stmt -> 'new' identifier '(' ')':
		{new, object, {class, line('$2'), unwrap('$2')}}.

% instanciação de objetos de qualquer classe
new_stmt -> 'new' identifier '(' argument_list ')':
		{new, object, {class, line('$2'), unwrap('$2'), {arguments, '$4'}}}.

%% Array com tipo após identifier
%% ------------------------------------------
array_declaration_list2 -> identifier '[' ']':
				[{{var, unwrap('$1')},{var_value, undefined}}].

array_declaration_list2 -> identifier '[' ']' ',' array_declaration_list:
		[{{var, unwrap('$1')}, {var_value, undefined}} | '$5'].

array_declaration_list2 -> identifier '[' ']' '=' '{' array_initializer '}':
			[{{var, unwrap('$1')}, {var_value, {array_initializer, '$6'}}}].

array_declaration_list2 -> identifier '[' ']' '=' new_stmt:
			[{{var, unwrap('$1')}, {var_value, '$5'}}].


array_declaration_list3 -> identifier '[' ']' '[' ']':
				[{{var, unwrap('$1')},{var_value, undefined}}].

array_declaration_list3 -> identifier '['']' '[' ']' ',' array_declaration_list:
		[{{var, unwrap('$1')}, {var_value, undefined}} | '$7'].

array_declaration_list3 -> identifier '['']' '['']' '='
								'{' array_initializer '}':
			[{{var, unwrap('$1')}, {var_value, {array_initializer, '$8'}}}].

array_declaration_list3 -> identifier '[' ']' '[' ']' '=' new_stmt:
			[{{var, unwrap('$1')}, {var_value, '$7'}}].

%% ------------------------------------------
array_initializer -> literal : [{array_element, '$1'}].

array_initializer -> literal ',' array_initializer:
		[{array_element, '$1'} | '$3'].


array_initializer -> '{' array_initializer '}' :
		[{matrix_element, '$2'}].

array_initializer -> '{' array_initializer '}' ',' array_initializer:
		[{matrix_element, '$2'} | '$5'].

%% Atribuições
%%TODO: Verificar element value
element_value_pair ->	identifier '=' element_value ';':
	{line('$1'), attribution, {var, unwrap('$1')}, {var_value, '$3'}}.

%% Atribuição de array
element_value_pair ->  identifier '[' element_value ']' '=' element_value ';':
	{line('$1'), array_attribution,
			{{var, unwrap('$1')},{index, '$3'}}, {var_value, '$6'}}.

element_value_pair ->  identifier '[' element_value ']' '[' element_value ']''='
									 element_value ';':
	{line('$1'), array_attribution,
			{{var, unwrap('$1')},{index, {row, '$3'}, {column, '$6'}} },
					 {var_value, '$9'}}.

%% atribuição de membros de objetos (atributos)
element_value_pair ->	identifier '.' identifier '=' element_value ';':
	VarName = {field_attribution, {unwrap('$1'), unwrap('$3')}},
	{line('$1'), attribution, {var, VarName}, {var_value, '$5'}}.

element_value_pair ->	this '.' identifier '=' element_value ';':
	VarName = {field_attribution, {unwrap('$1'), unwrap('$3')}},
	{line('$1'), attribution, {var, VarName}, {var_value, '$5'}}.

%%--------------
length_stmt -> identifier '.' length : {length, line('$1'), unwrap('$1')}.

sqrt_stmt -> sqrt '(' element_value ')': {sqrt, line('$1'), '$3'}.

next_int_stmt -> identifier '.' next_int '(' ')' :
					{next_int, line('$1'), unwrap('$1')}.

next_int_stmt -> identifier '.' next_int '(' integer ')' :
					{next_int, line('$1'), unwrap('$1'), '$5'}.

next_float_stmt -> identifier '.' next_float '(' ')' :
					{next_float, line('$1'),  unwrap('$1')}.

next_line_stmt -> identifier '.' next_line '(' ')' :
					{next_line, line('$1'),  unwrap('$1')}.


%% trata expressoes do tipo [ System.out.print( texto + identificador ) ]
%% print e println têm o MESMO TOKEN, mas diferentes valores!!!
print_stmt -> print '(' print_content ')' ';':
	   {line('$1'), unwrap('$1'), '$3'}.

print_content -> text : ['$1'].

print_content -> identifier : ['$1'].

print_content -> identifier '.' identifier :
				[{field_access, unwrap('$1'), unwrap('$3')}].

print_content -> identifier '.' identifier add_op print_content :
				[{field_access, unwrap('$1'), unwrap('$3')} | '$5'].

print_content -> text add_op print_content : ['$1' | '$3'].

print_content -> identifier add_op print_content : ['$1' | '$3'].

print_content -> array_access : ['$1'].

print_content -> array_access add_op print_content : ['$1' | '$3'].

%% trata expressoes do tipo try...catch

try_catch_stmt -> try block catches	: {line('$1'), try_catch, '$2', '$3'}.

catches -> catch_clause	: ['$1'].
catches -> catch_clause catches : ['$1'|'$2'].

catch_clause -> catch '(' exception identifier ')' block : 
			[{line('$1'), {catch_clause, '$1'}, {var_exception, '$4'}, '$6'}].

%% trata expressoes do break

break_stmt	-> break ';'	: {line('$1'), break}.

%% Estrutura vetor
%% TOD: Verificar ele como um array
array_access ->
	 identifier '[' element_value ']' :
			{{var, line('$1'), unwrap('$1')},
					{index, '$3'}}.

array_access ->
	 identifier '[' element_value ']' '[' element_value ']' :
			{{var, line('$1'), unwrap('$1')},
					{index, {row, '$3'}, {column, '$6'} } }.

%%
for_update -> identifier increment_op :
				Var = {var, line('$1'), unwrap('$1')},
				{inc_op, line('$1'), unwrap('$2'), Var}.

%% Vetor
for_update -> array_access increment_op :
				Var = '$1',
				{inc_op, line('$2'), unwrap('$2'), Var}.


post_increment_expr -> identifier increment_op ';':
				Var = {var, line('$1'), unwrap('$1')},
				{inc_op, line('$1'), unwrap('$2'), Var}.

%% BEGIN_FOR
for_stmt -> for '(' int_t identifier '=' bool_expr ';' bool_expr ';'
				for_update  ')'  statement :
			{line('$1'), for,
				{for_init, {var_type, unwrap('$3')}, {var_name, unwrap('$4')}},
				{for_start, '$6'}, {condition_expr, '$8'},
				{inc_expr, '$10'}, {for_body, '$12'}}.

for_no_trailing -> for '(' int_t identifier '=' bool_expr ';'
					bool_expr ';'
					for_update ')'  no_short_if_stmt :
			{line('$1'), for,
				{for_init, {var_type, unwrap('$3')}, {var_name, unwrap('$4')}},
				{for_start, '$6'}, {condition_expr, '$8'},
				{inc_expr, '$10'}, {for_body, '$12'}}.
%% END_FOR

%% BEGIN_FOR Vetor
for_stmt -> for '(' array_access '=' bool_expr ';' bool_expr ';'
				for_update  ')'  statement :
			{line('$1'), for,
				{for_init , {var_name, '$3'}},
				{for_start, '$5'}, {condition_expr, '$7'},
				{inc_expr, '$9'}, {for_body, '$11'}}.

for_no_trailing -> for '(' array_access '=' bool_expr ';'
					bool_expr ';'
					for_update ')'  no_short_if_stmt :
			{line('$1'), for,
				{for_init,  {var_name, unwrap('$3')}},
				{for_start, '$5'}, {condition_expr, '$7'},
				{inc_expr, '$9'}, {for_body, '$11'}}.
%% END_FOR

%%BEGIN WHILE
while_stmt -> while '(' bool_expr ')' statement:
	{line('$1'), while, {condition_expr, '$3'}, {while_body, '$5'}}.

while_no_trailing -> while '(' bool_expr ')' no_short_if_stmt:
	{line('$1'), while, {condition_expr, '$3'}, {while_body, '$5'}}.
%%END WHILE


%%BEGIN DO_WHILE
do_while_stmt -> do no_short_if_stmt while '(' bool_expr ')' ';':
	{line('$1'), do_while,  {do_while_body, '$2'}, {condition_expr, '$5'}}.
%%END DO_WHILE


%% BEGIN_IF
if_stmt -> 'if' '(' bool_expr ')' statement:
	{line('$1'), 'if', {bool_expr, '$3'}, {if_expr, '$5'}}.

if_else_stmt -> 'if' '(' bool_expr ')' no_short_if_stmt 'else' statement :
	{line('$1'), 'if', {bool_expr, '$3'}, {if_expr, '$5'}, {else_expr, '$7'}}.

if_else_no_trailing -> 'if' '(' bool_expr ')' no_short_if_stmt
						'else' no_short_if_stmt :
	{line('$1'), 'if', {bool_expr, '$3'}, {if_expr, '$5'}, {else_expr, '$7'}}.
%% END_IF

%% BEGIN_FUNCTION

%% TODO trocar para method_invocation
method_invocation -> identifier '(' ')':
			{function_call, {line('$1'), unwrap('$1')},
					{argument_list, []}}.

method_invocation -> identifier '(' argument_list ')':
			{function_call, {line('$1'), unwrap('$1')},
				{argument_list, '$3'}}.

%% chamada a método estático, na realidade significado do nome é resolvido
%% na análise SEMÂNTICA
%% Owner é tanto o nome de uma Classe quanto de uma variável!!
%% Math.sqrt()   ou   b.trocaCor()
method_invocation -> identifier '.' identifier '(' ')':
	Owner = {owner, line('$1'), unwrap('$1')},
	Method = {method, line('$3'), unwrap('$3')},
	ArgumentList = {argument_list, []},
	{function_call, Owner, Method, ArgumentList}.

method_invocation -> identifier '.' identifier '(' argument_list ')':
	Owner = {owner, line('$1'), unwrap('$1')},
	Method = {method, line('$3'), unwrap('$3')},
	ArgumentList = {argument_list, '$5'},
	{function_call, Owner, Method, ArgumentList}.

%% END_FUNCTION

%% BEGIN_FIELD

field_access -> identifier '.' identifier:
	{field_access, {line('$1'), unwrap('$1'), unwrap('$3')}}.

field_access -> this '.' identifier:
	{field_access, {line('$1'), unwrap('$1'), unwrap('$3')}}.

%% END_FIELD

%% BEGIN_RETURN

return_statement -> return element_value ';' : {line('$1'), return, '$2'}.

%% END_RETURN

argument_list ->	argument			: ['$1'].
argument_list ->	argument ',' argument_list	: ['$1' | '$3'].

argument ->		element_value			: '$1'.

type -> string_t: {line('$1'), unwrap('$1')}.
type -> void	: {line('$1'), unwrap('$1')}.
type -> int_t	: {line('$1'), unwrap('$1')}.
type -> long_t	: {line('$1'), unwrap('$1')}.
type -> float_t	: {line('$1'), unwrap('$1')}.
type -> double_t	: {line('$1'), unwrap('$1')}.
type -> boolean_t	: {line('$1'), unwrap('$1')}.
type -> char_t	: {line('$1'), unwrap('$1')}.

%% -Trata expressoes matematicas (numericas).
%% TODO: acrescentar tipo boolean e tratar precedencia de op booleanos
%% TODO: tratar o not (!)

element_value -> bool_expr : '$1'.

bool_expr -> comparation_expr bool_op bool_expr	:
			{op, line('$2'), unwrap('$2'), '$1', '$3'}.

bool_expr -> comparation_expr						: '$1'.

comparation_expr -> add_expr comparation_op comparation_expr		:
			{op, line('$2'), unwrap('$2'), '$1', '$3'}.
comparation_expr -> add_expr						: '$1'.

add_expr -> mult_expr add_op add_expr		:
			{op, line('$2'), unwrap('$2'), '$1', '$3'}.
add_expr -> mult_expr						: '$1'.

mult_expr -> modulus_expr mult_op mult_expr	:
			{op, line('$2'), unwrap('$2'), '$1', '$3'}.
mult_expr -> modulus_expr						: '$1'.

modulus_expr -> unary_expr modulus_op modulus_expr		:
			{op, line('$2'), 'rem', '$1', '$3'}.
modulus_expr -> unary_expr						: '$1'.

unary_expr -> add_op literal    : {op, line('$1'), unwrap('$1'), '$2'}.
unary_expr -> literal           : '$1'.
unary_expr -> bool_op literal	:
			{op, line('$1'), unwrap('$1'), '$2'}.

literal -> method_invocation	: '$1'.
literal -> field_access			: '$1'.
literal -> sqrt_stmt			: '$1'.
literal -> singles_quotes		: '$1'.
literal -> text					: '$1'.
literal -> integer				: '$1'.
literal -> float				: '$1'.
literal -> identifier			: {var, line('$1'), unwrap('$1')}.
%literal -> identifier '.' identifier : {field_access, '$1', '$3'}.
literal -> '(' bool_expr ')'	: '$2'.
literal -> true					: {atom, line('$1'), true}.
literal -> false				: {atom, line('$1'), false}.
literal -> next_int_stmt		: '$1'.
literal -> next_float_stmt		: '$1'.
literal -> next_line_stmt		: '$1'.
literal -> read_stmt			: '$1'.
literal -> array_access			: '$1'.
literal -> length_stmt			: '$1'.
literal -> new_stmt				: '$1'.

Erlang code.

unwrap({_, _, Value})	-> Value.
line({_, Line, _})	-> Line;
line(X) ->
	Msg = "Erro ao usar funcao line no parser! " ++
		  "Aki:  " ++ lists:flatten(io_lib:format("~p", [X])),
	throw(Msg).
make_array_type({Line, PrimitiveType}) -> {Line, {array, PrimitiveType}}.

make_matrix_type({Line, PrimitiveType}) -> {Line, {matrix, PrimitiveType}}.
