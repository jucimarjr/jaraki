%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% Aluno  : Eden ( edenstark@gmail.com )
%% Aluno  : Helder Cunha Batista ( hcb007@gmail.com )
%% Aluno  : Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% Aluno  : Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% Aluno  : Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Gerar os analisadores lexico e sintatico e compilar o compilador

%%-vsn(0.002).
%%-author('uea_ludus@googlegroups.com').

%%-----------------------------------------------------------------------------
%%Definições dos tokens do analisador lexico do compilador

Definitions.

Identifier			= [a-zA-Z_][a-zA-Z0-9_]*
Class				= class
Public				= public
Static				= static
Void				= void
Main				= main
Print				= System.out.print
Println				= System.out.println

Text	 			= "(\\\^.|\\.|[^\"])*"

OpenParentheses		= \(
CloseParentheses	= \)
OpenBrackets		= \[
CloseBrackets		= \]
OpenKeys			= \{
CloseKeys			= \}
Comma				= ,
Semicolon			= ;
WhiteSpace			= [\s|\n|\t]

Rules.

{Class}				: {token, {class,	TokenLine, list_to_atom(TokenChars)}}.
{Public}			: {token, {public,	TokenLine, list_to_atom(TokenChars)}}.
{Static}			: {token, {static,	TokenLine, list_to_atom(TokenChars)}}.
{Void}				: {token, {void,	TokenLine, list_to_atom(TokenChars)}}.
{Main}				: {token, {main,	TokenLine, list_to_atom(TokenChars)}}.
{Print}				: {token, {print,	TokenLine, list_to_atom(TokenChars)}}.
{Println}			: {token, {println,	TokenLine, list_to_atom(TokenChars)}}.

{OpenParentheses}	: {token, {list_to_atom(TokenChars), TokenLine}}.
{CloseParentheses}	: {token, {list_to_atom(TokenChars), TokenLine}}.
{OpenBrackets}		: {token, {list_to_atom(TokenChars), TokenLine}}.
{CloseBrackets}		: {token, {list_to_atom(TokenChars), TokenLine}}.
{OpenKeys} 			: {token, {list_to_atom(TokenChars), TokenLine}}.
{CloseKeys}			: {token, {list_to_atom(TokenChars), TokenLine}}.
{Comma}				: {token, {list_to_atom(TokenChars), TokenLine}}.
{Semicolon}			: {token, {list_to_atom(TokenChars), TokenLine}}.

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
