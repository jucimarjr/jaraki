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
import_list import_declaration
qualified_identifier
class_declaration class_body class_list
method_declaration
block block_statements
method_invocation
local_variable_declaration_statement element_value type variable_list
array_declaration_list array_declaration_list2 array_initializer array_access
new_stmt
add_expr mult_expr modulus_expr
unary_expr literal
comparation_expr bool_expr
element_value_pair
sqrt_stmt length_stmt
print_stmt print_content if_stmt if_else_stmt if_else_no_trailing
object_declaration class_initializer 
next_int_stmt next_float_stmt next_line_stmt
return_statement
for_stmt for_no_trailing
while_stmt while_no_trailing
no_trailing_stmt no_short_if_stmt
parameters_list	parameter
argument argument_list
for_update post_increment_expr
try_catch_stmt catches catch_clause
statement.

Terminals
package import class public static void %% main, obsoleto
return sqrt random print scanner
length
'(' ')' '[' ']' '{' '}' ';' '=' '.' '.*' ','
string_t int_t long_t float_t double_t boolean_t
next_int	next_line	next_float	'new'	system_in
'if' 'else' true false
for while	try catch exception
integer float
identifier text
add_op mult_op modulus_op increment_op
comparation_op	bool_op.
%% and_op or_op not_op.

Rootsymbol start_parser.

%% TODO: interpretar pacotes e imports na análise semântica
start_parser -> class_list											: '$1'.
start_parser -> package qualified_identifier class_list				: '$3'.
start_parser -> package qualified_identifier import_list class_list	: '$4'.
start_parser -> import_list class_list								: '$2'.

qualified_identifier -> identifier ';'						: ['$1'].
qualified_identifier -> identifier '.' qualified_identifier	: ['$1' | '$3'].

import_list -> import import_declaration				: ['$2'] .
import_list -> import import_declaration import_list	: ['$2' | '$3'].

import_declaration -> identifier ';'					: ['$1'].
import_declaration -> identifier '.*' ';'				: [{'$1', '$2'}].
import_declaration -> identifier '.' import_declaration	: ['$1' | '$3'].
import_declaration -> scanner ';' : ['$1'].
import_declaration -> random ';' : ['$1'].

class_list -> class_declaration				: ['$1'].
class_list -> class_declaration class_list	: ['$1' | '$2'].

class_declaration -> public class identifier '{' class_body '}':
	{line('$3'), {class, unwrap('$3')}, {class_body, '$5'}}.

%% MethodOrFieldDecl
class_body -> method_declaration			: ['$1'].
class_body -> method_declaration class_body	: ['$1' | '$2'].

method_declaration -> public static type identifier '(' ')' block:
			{line('$4'), '$3', {method, unwrap('$4')}, [], '$7'}.

method_declaration -> public static type identifier
					'(' parameters_list ')' block:
			{line('$4'), '$3', {method, unwrap('$4')}, '$6', '$8'}.

method_declaration -> public static type '[' ']' identifier '(' ')' block:
			{line('$6'),
				make_array_type('$3'),
				{method, unwrap('$6')}, [], '$9'}.

method_declaration -> public static type '[' ']' identifier
					'(' parameters_list ')' block:
			{line('$6'),
				make_array_type('$3'),
				{method, unwrap('$6')}, '$8', '$10'}.


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

parameter -> type '[' ']' identifier:
			{line('$4'),
				{var_type, make_array_type('$1')},
				{parameter, unwrap('$4')}}.
parameter -> type identifier '[' ']':
			{line('$2'),
				{var_type, make_array_type('$1')},
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
statement -> no_trailing_stmt		: '$1'.
statement -> try_catch_stmt			: '$1'.

no_short_if_stmt -> for_no_trailing						: '$1'.
no_short_if_stmt -> while_no_trailing					: '$1'.
no_trailing_stmt -> block								: '$1'.
no_trailing_stmt -> local_variable_declaration_statement: '$1'.
no_trailing_stmt -> element_value_pair					: '$1'.
no_trailing_stmt -> print_stmt							: '$1'.
no_trailing_stmt -> post_increment_expr					: '$1'.
no_trailing_stmt -> return_statement					: '$1'.
no_short_if_stmt -> no_trailing_stmt					: '$1'.
no_short_if_stmt -> if_else_no_trailing					: '$1'.

%% Declaração de variáveis
local_variable_declaration_statement -> type variable_list ';':
	{var_declaration, {var_type, '$1'}, {var_list, '$2'}}.
variable_list -> identifier '=' element_value			:
		[{{var, unwrap('$1')}, {var_value, '$3'}}].
variable_list -> identifier '=' element_value ',' variable_list	:
		[{{var, unwrap('$1')}, {var_value, '$3'}} | '$5'].
variable_list -> identifier	: [{{var, unwrap('$1')},{var_value, undefined}}].
variable_list -> identifier	',' variable_list:
		[{{var, unwrap('$1')}, {var_value, undefined}} | '$3'].

%% Declaração de vetor
%% TODO: verificar array_initializer

local_variable_declaration_statement ->  type '[' ']' array_declaration_list';':
	{var_declaration,
		{var_type, make_array_type('$1')},
		{var_list, '$4'}}.

local_variable_declaration_statement ->  type  array_declaration_list2';':
	{var_declaration,
		{var_type, make_array_type('$1')},
		{var_list, '$2'}}.

%%Instancia classes

local_variable_declaration_statement -> type object_declaration ';':
	{var_declaration, {var_type, '$1'}, {var_list, '$2'}}.


object_declaration -> identifier '=' new_stmt:
		[{{var, unwrap('$1')}, {var_value, undefined}}].


%% ------------------------------------------
array_declaration_list -> identifier:
				[{{var, unwrap('$1')},{var_value, undefined}}].

array_declaration_list -> identifier ',' array_declaration_list:
		[{{var, unwrap('$1')}, {var_value, undefined}} | '$3'].

array_declaration_list -> identifier '=' '{' array_initializer '}':
			[{{var, unwrap('$1')}, {var_value, {array_initializer, '$4'}}}].

array_declaration_list -> identifier '=' new_stmt:
			[{{var, unwrap('$1')}, {var_value, '$3'}}].

new_stmt -> 'new' type '[' integer ']':
		{new, array, {type, '$2'}, {index, '$4'}}.

new_stmt -> 'new' type '[' identifier ']':
		{new, array, {type, '$2'}, {index, {var, line('$4'), unwrap('$4')}}}.

new_stmt -> 'new' type '[' length_stmt ']':
		{new, array, {type, '$2'}, {index, '$4'}}.

%--------------------------------------------
new_stmt -> 'new' type '(' ')': 
		{new, object_class, {type, '$2'}}.

new_stmt -> 'new' type '(' class_initializer ')': 
		{new, object_class, {type, '$2'}}.

class_initializer -> system_in: no_operation.


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

%% ------------------------------------------
array_initializer -> literal : [{array_element, unwrap('$1')}].

array_initializer -> literal ',' array_initializer:
		[{array_element, unwrap('$1')} | '$3'].

%% Atribuições
%%TODO: Verificar element value
element_value_pair ->	identifier '=' element_value ';':
	{line('$1'), attribution, {var, unwrap('$1')}, {var_value, '$3'}}.

%% Atribuição de array
element_value_pair ->   identifier '[' element_value ']' '=' element_value ';':
	{line('$1'), array_attribution,
			{{var, unwrap('$1')},{index, '$3'}}, {var_value, '$6'}}.

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


%% Estrutura vetor
%% TOD: Verificar ele como um array
array_access ->
	 identifier '[' element_value ']' :
			{{var, line('$1'), unwrap('$1')},
					{index, '$3'}}.

%%
for_update -> identifier increment_op :
				Var = {var, line('$1'), unwrap('$1')},
				{inc_op, line('$1'), unwrap('$2'), Var}.

post_increment_expr -> identifier increment_op ';':
				Var = {var, line('$1'), unwrap('$1')},
				{inc_op, line('$1'), unwrap('$2'), Var}.

%% BEGIN_FOR
for_stmt -> for '(' int_t identifier '=' add_expr ';' bool_expr ';'
				for_update  ')'  statement :
			{line('$1'), for,
				{for_init, {var_type, unwrap('$3')}, {var_name, unwrap('$4')}},
				{for_start, '$6'}, {condition_expr, '$8'},
				{inc_expr, '$10'}, {for_body, '$12'}}.

for_no_trailing -> for '(' int_t identifier '=' add_expr ';'
					bool_expr ';'
					for_update ')'  no_short_if_stmt :
			{line('$1'), for,
				{for_init, {var_type, unwrap('$3')}, {var_name, unwrap('$4')}},
				{for_start, '$6'}, {condition_expr, '$8'},
				{inc_expr, '$10'}, {for_body, '$12'}}.


%% END_FOR

%%BEGIN WHILE
while_stmt -> while '(' bool_expr ')' statement:
	{line('$1'), while, {condition_expr, '$3'}, {while_body, '$5'}}.

while_no_trailing -> while '(' bool_expr ')' no_short_if_stmt:
	{line('$1'), while, {condition_expr, '$3'}, {while_body, '$5'}}.
%%END WHILE

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

%% chamada a método estático
method_invocation -> identifier '.' identifier '(' ')':
	Class = {class, line('$1'), unwrap('$1')},
	Method = {method, line('$3'), unwrap('$3')},
	ArgumentList = {argument_list, []},
	{function_call, Class, Method, ArgumentList}.

method_invocation -> identifier '.' identifier '(' argument_list ')':
	Class = {class, line('$1'), unwrap('$1')},
	Method = {method, line('$3'), unwrap('$3')},
	ArgumentList = {argument_list, '$5'},
	{function_call, Class, Method, ArgumentList}.

%% END_FUNCTION

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
type -> random		: {line('$1'), unwrap('$1')}.
type -> scanner		: {line('$1'), unwrap('$1')}.

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

literal -> method_invocation	: '$1'.
literal -> sqrt_stmt			: '$1'.
literal -> integer				: '$1'.
literal -> float				: '$1'.
literal -> identifier			:  {var, line('$1'), unwrap('$1')}.
literal -> '(' add_expr ')'		: '$2'.
literal -> true					: {atom, line('$1'), true}.
literal -> false				: {atom, line('$1'), false}.
literal -> next_int_stmt		: '$1'.
literal -> next_float_stmt		: '$1'.
literal -> next_line_stmt		: '$1'.
literal -> array_access			: '$1'.
literal -> length_stmt			: '$1'.

Erlang code.

unwrap({_, _, Value})	-> Value.
line({_, Line, _})	-> Line;
line(X) ->
	Msg = "Erro ao usar funcao line no parser! " ++
		  "Aki:  " ++ lists:flatten(io_lib:format("~p", [X])),
	throw(Msg).
make_array_type({Line, PrimitiveType}) -> {Line, {array, PrimitiveType}}.
