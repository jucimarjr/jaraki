%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% 			Eden ( edenstark@gmail.com )
%% 			Helder Cunha Batista ( hcb007@gmail.com )
%% 			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% 			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% 			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : 

%%-----------------------------------------------------------------------------
%% Definições dos tokens do analisador lexico do compilador

Definitions.

Class				= class
Public				= public
Static				= static
Void				= void
Main				= main
Integer				= int
Float				= float
Double				= double
Print				= System.out.print
Println				= System.out.println
Digit				= [0-9]
Identifier			= [a-zA-Z_][a-zA-Z0-9_]*

Text	 			= "(\\\^.|\\.|[^\"])*"

OpenParentheses		= \(
CloseParentheses	= \)
OpenBrackets		= \[
CloseBrackets		= \]
OpenKeys			= \{
CloseKeys			= \}
Comma				= ,
Semicolon			= ;
Equal				= =
AddOp				= (\+|-)
MultOp				= (\*|/)
WhiteSpace			= [\s|\n|\t]

Rules.

{Class}				: {token, {class,	TokenLine, list_to_atom(TokenChars)}}.
{Public}			: {token, {public,	TokenLine, list_to_atom(TokenChars)}}.
{Static}			: {token, {static,	TokenLine, list_to_atom(TokenChars)}}.
{Void}				: {token, {void,	TokenLine, list_to_atom(TokenChars)}}.
{Main}				: {token, {main,	TokenLine, list_to_atom(TokenChars)}}.
{Integer}			: {token, {int_t,	TokenLine, list_to_atom(TokenChars)}}.
{Float}				: {token, {float_t,	TokenLine, list_to_atom(TokenChars)}}.
{Double}			: {token, {double_t,TokenLine, list_to_atom(TokenChars)}}.
{Print}				: {token, {print,	TokenLine, list_to_atom(TokenChars)}}.
{Println}			: {token, {println,	TokenLine, list_to_atom(TokenChars)}}.

{OpenParentheses}	: {token, {list_to_atom(TokenChars), TokenLine}}.
{CloseParentheses}	: {token, {list_to_atom(TokenChars), TokenLine}}.
{OpenBrackets}		: {token, {list_to_atom(TokenChars), TokenLine}}.
{CloseBrackets}		: {token, {list_to_atom(TokenChars), TokenLine}}.
{OpenKeys}			: {token, {list_to_atom(TokenChars), TokenLine}}.
{CloseKeys}			: {token, {list_to_atom(TokenChars), TokenLine}}.
{Comma}				: {token, {list_to_atom(TokenChars), TokenLine}}.
{Semicolon}			: {token, {list_to_atom(TokenChars), TokenLine}}.
{Equal}				: {token, {list_to_atom(TokenChars), TokenLine}}.
{AddOp}				: {token, {add_op, TokenLine, list_to_atom(TokenChars)}}.
{MultOp}			: {token, {mult_op, TokenLine, list_to_atom(TokenChars)}}.

{Digit}+		: {token, {integer, TokenLine, list_to_integer(TokenChars)}}.
{Digit}+\.{Digit}+	: {token, {float, TokenLine, list_to_float(TokenChars)}}.

{Identifier}	: {token, {identifier, TokenLine, list_to_atom(TokenChars)}}.
{WhiteSpace}+	: skip_token.
{Text} 			: build_text(text, TokenChars, TokenLine, TokenLen).

Erlang code.

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
		$\" -> $\";
		$\' -> $\';
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
