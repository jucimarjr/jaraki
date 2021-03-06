%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%%			Eden ( edenstark@gmail.com )
%%			Helder Cunha Batista ( hcb007@gmail.com )
%%			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%%			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%%			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Definições dos tokens do analisador lexico do compilador

Definitions.

Comment				= /\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+/
EndOfLineComment	= //.*\n

% Keyword: one of

Package				= package

Import				= import
ImportAll			= \.\*
Class				= class
Extends				= extends
Public				= public
Static				= static
Void				= void
Return				= return
String				= String
Integer				= int
Long				= long
Float				= float
Double				= double
Char				= char
Boolean				= boolean
If					= if
Else				= else
For					= for
While				= while
Do					= do
Try					= try
Catch				= catch
Break				= break
Throws				= throws
Exception			= Exception
IOException			= IOException


% End Keyword

% BooleanLiteral: one of

True	= true
False	= false

% End BooleanLiteral

%% Main				= main OBSOLETO
% TODO: incluir potencia;
Length				= length
Sqrt				= Math.sqrt
Print				= System.out.print
Println				= System.out.println
Random				= Random
Scanner				= Scanner
SystemIn			= System\.in
FileReader			= FileReader
Read				= read
FileWriter			= FileWriter
Write				= write
Close				= close
NextInt				= nextInt
NextFloat			= nextFloat
NextLine			= nextLine
New					= new
This				= this
Super				= super
Digit				= [0-9]
Identifier			= [a-zA-Z_][a-zA-Z0-9_]*

StringLiteral		= "(\\\^.|\\.|[^\"])*"
SinglesQuotesLiteral= '[a-zA-Z0-9_]'

% Separator: one of

OpenParentheses		= \(
CloseParentheses	= \)
OpenBrackets		= \[
CloseBrackets		= \]
OpenKeys			= \{
CloseKeys			= \}
Dot					= \.
Comma				= ,
Semicolon			= ;

% End Separator

% Operator: one of
AttributionOp	= =
ComparatorOp	= (<|<=|==|>=|>|!=)
BooleanOp		= (\&\&|!|\s*\|\|\s*)
AddOp			= (\+|-)
MultOp			= (\*|/)
ModulusOp		= (\%)
IncrementOp		= (\+\+|--)

% End Operator

WhiteSpace	= [\r|\s|\n|\t|\f]

Rules.

{Comment}			: skip_token.
{EndOfLineComment}	: skip_token.

{Package}	: {token, {package,	TokenLine, list_to_atom(TokenChars)}}.
{Import}	: {token, {import,	TokenLine, list_to_atom(TokenChars)}}.
{Class}		: {token, {class,	TokenLine, list_to_atom(TokenChars)}}.
{Extends}	: {token, {extends, TokenLine, list_to_atom(TokenChars)}}.
{Public}	: {token, {public,	TokenLine, list_to_atom(TokenChars)}}.
{Static}	: {token, {static,	TokenLine, list_to_atom(TokenChars)}}.
{Void}		: {token, {void,	TokenLine, list_to_atom(TokenChars)}}.
{Return}	: {token, {return,	TokenLine, list_to_atom(TokenChars)}}.
{String}	: {token, {string_t,TokenLine, list_to_atom(TokenChars)}}.
{Integer}	: {token, {int_t,	TokenLine, list_to_atom(TokenChars)}}.
{Long}		: {token, {long_t,	TokenLine, list_to_atom(TokenChars)}}.
{Float}		: {token, {float_t,	TokenLine, list_to_atom(TokenChars)}}.
{Double}	: {token, {double_t,	TokenLine, list_to_atom(TokenChars)}}.
{Boolean}	: {token, {boolean_t,	TokenLine, list_to_atom(TokenChars)}}.
{Char}		: {token, {char_t,	TokenLine, list_to_atom(TokenChars)}}.
{If}		: {token, {'if',	TokenLine, list_to_atom(TokenChars)}}.
{Else}		: {token, {'else',	TokenLine, list_to_atom(TokenChars)}}.
{For}		: {token, {'for',	TokenLine, list_to_atom(TokenChars)}}.
{While}		: {token, {'while',	TokenLine, list_to_atom(TokenChars)}}.
{Do}		: {token, { 'do',	TokenLine, list_to_atom(TokenChars)}}.
{Try}		: {token, {'try',	TokenLine, list_to_atom(TokenChars)}}.
{Catch}		: {token, {'catch',	TokenLine, list_to_atom(TokenChars)}}.
{Break}		: {token, {'break',	TokenLine, list_to_atom(TokenChars)}}.
{Throws}	: {token, {'throws',	TokenLine, list_to_atom(TokenChars)}}.
{Exception}	: {token, {exception,	TokenLine, list_to_atom(TokenChars)}}.
{IOException}	: {token, {io_exception,	TokenLine, list_to_atom(TokenChars)}}.
{Length}	: {token, {length,	TokenLine, list_to_atom(TokenChars)}}.
{Sqrt}		: {token, {sqrt,	TokenLine, list_to_atom(TokenChars)}}.
{Print}		: {token, {print,	TokenLine, unwrap_print(TokenChars)}}.
{Println}	: {token, {print,	TokenLine, unwrap_print(TokenChars)}}.
{Random}	: {token, {random,	TokenLine, list_to_atom(TokenChars)}}.
{Scanner}	: {token, {scanner,	TokenLine, list_to_atom(TokenChars)}}.
{SystemIn}	: {token, {system_in,	TokenLine, list_to_atom(TokenChars)}}.
{NextInt}	: {token, {next_int,		TokenLine, list_to_atom(TokenChars)}}.
{NextFloat}	: {token, {next_float,	TokenLine, list_to_atom(TokenChars)}}.
{NextLine}	: {token, {next_line,	TokenLine, list_to_atom(TokenChars)}}.
{FileReader}	: {token, {file_reader,	TokenLine, list_to_atom(TokenChars)}}.
{Read}		: {token, {read,	TokenLine, list_to_atom(TokenChars)}}.
{FileWriter}	: {token, {file_writer,	TokenLine, list_to_atom(TokenChars)}}.
{Write}		: {token, {write,	TokenLine, list_to_atom(TokenChars)}}.
{Close}		: {token, {close,	TokenLine, list_to_atom(TokenChars)}}.
{New}		: {token, {new,	TokenLine, list_to_atom(TokenChars)}}.
{This}		: {token, {this,	TokenLine, list_to_atom(TokenChars)}}.
{Super}		: {token, {super,	TokenLine, list_to_atom(TokenChars)}}.
{True}		: {token, {true,	TokenLine, list_to_atom(TokenChars)}}.
{False}		: {token, {false,	TokenLine, list_to_atom(TokenChars)}}.

{ImportAll}			: {token, {list_to_atom(TokenChars), TokenLine}}.
{OpenParentheses}	: {token, {list_to_atom(TokenChars), TokenLine}}.
{CloseParentheses}	: {token, {list_to_atom(TokenChars), TokenLine}}.
{OpenBrackets}		: {token, {list_to_atom(TokenChars), TokenLine}}.
{CloseBrackets}		: {token, {list_to_atom(TokenChars), TokenLine}}.
{OpenKeys}		: {token, {list_to_atom(TokenChars), TokenLine}}.
{CloseKeys}		: {token, {list_to_atom(TokenChars), TokenLine}}.
{Dot}			: {token, {list_to_atom(TokenChars), TokenLine}}.
{Comma}			: {token, {list_to_atom(TokenChars), TokenLine}}.
{Semicolon}		: {token, {list_to_atom(TokenChars), TokenLine}}.
{AttributionOp}	: {token, {list_to_atom(TokenChars), TokenLine}}.
{AddOp}			: {token, {add_op, TokenLine, list_to_atom(TokenChars)}}.
{MultOp}		: {token, {mult_op, TokenLine, list_to_atom(TokenChars)}}.
{ModulusOp}		: {token, {modulus_op, TokenLine, list_to_atom(TokenChars)}}.
{IncrementOp}	: {token, {increment_op, TokenLine, list_to_atom(TokenChars)}}.
{ComparatorOp}	: {token, {comparation_op, TokenLine, op(TokenChars)}}.
{BooleanOp}		: {token, {bool_op, TokenLine, bop(TokenChars)}}.
{Digit}+		: {token, {integer, TokenLine, list_to_integer(TokenChars)}}.
{Digit}+\.{Digit}+f	: {token, {float,TokenLine,list_to_float(TokenChars--"f")}}.
{Digit}+\.{Digit}+	: {token, {float, TokenLine, list_to_float(TokenChars)}}.

{Identifier}	: {token, {identifier, TokenLine, list_to_atom(TokenChars)}}.
{SinglesQuotesLiteral} :
				  build_char(singles_quotes, TokenChars, TokenLine, TokenLen).
{WhiteSpace}+	: skip_token.
{StringLiteral}	: build_text(text, TokenChars, TokenLine, TokenLen).

Erlang code.
build_char(Type, Chars, Line, Length) ->
	Chars1 = string:substr(Chars, 2, Length-2),
	Char = hd(Chars1),
	{token, {Type, Line, Char}}.

build_text(Type, Chars, Line, Length) ->
	Text = detect_special_char(lists:sublist(Chars, 2, Length - 2)),
	{token, {Type, Line, Text}}.

%% Detecta os caracteres especiais
detect_special_char(Text) ->
	detect_special_char(Text, []).
detect_special_char([], Output) ->
	lists:reverse(Output);
detect_special_char([$\\, SpecialChar | Rest], Output) ->
	Char = case SpecialChar of
		$\\	-> $\\;
		$/	-> $/;
		$\"	-> $\";
		$\'	-> $\';
		$b	-> $\b;
		$d	-> $\d;
		$e	-> $\e;
		$f	-> $\f;
		$n	-> $\n;
		$r	-> $\r;
		$s	-> $\s;
		$t	-> $\t;
		$v	-> $\v;
		_	->
			throw({error,
				{"unrecognized special character: ", [$\\, SpecialChar]}})
	end,
	detect_special_char(Rest, [Char|Output]);
detect_special_char([Char|Rest], Output) ->
	detect_special_char(Rest, [Char|Output]).

op(OpChar) ->
	case OpChar of
		"<=" -> '=<';
		"!=" -> '=/=';
		"&&" -> 'and';
		"||" -> 'or';
		"!"  -> 'not';
		_	->	list_to_atom(OpChar)
	end.

bop(OpChar) ->
	op(hd(string:tokens(OpChar, " "))).

unwrap_print("System.out." ++ Print) ->
	list_to_atom(Print).
