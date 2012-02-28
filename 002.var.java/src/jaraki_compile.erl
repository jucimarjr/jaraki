%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% Aluno  : Eden ( edenstark@gmail.com )
%% Aluno  : Helder Cunha Batista ( hcb007@gmail.com )
%% Aluno  : Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% Aluno  : Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% Aluno  : Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Gerar os analisadores lexico e sintatico e compilar o compilador

-module(jaraki_compile).

-vsn(0.004).
-author('uea_ludus@googlegroups.com').

-compile(export_all).

-include("records.hrl").

%%-----------------------------------------------------------------------------
%% Escreve o codigo em erlang a partir do java.
%% TODO: tratar múltiplos arquivos, ou seja, múltiplas classes
write_erlang_from_jaraki(JavaFileName) ->
	JavaSyntaxTree = get_jast(JavaFileName),
	[{_, {class, ModuleNameTemp}, _}] = JavaSyntaxTree,
	ModuleName = list_to_atom(string:to_lower(atom_to_list(ModuleNameTemp))),
	ErlangFileName = atom_to_list(ModuleName) ++ ".erl",

	ErlangSyntaxTree = transform_jast_to_east(JavaSyntaxTree, ModuleName),
	ErlangCode = erl_prettypr:format(erl_syntax:form_list(ErlangSyntaxTree)),

	{ok, WriteDescriptor} = file:open(ErlangFileName, [raw, write]),
	file:write(WriteDescriptor, ErlangCode),
	file:close(WriteDescriptor).

%%-----------------------------------------------------------------------------
%% Gera e retorna a arvore sintatica do codigo java.
%%   jast -> arvore sintatica do java.
%% TODO: tratar múltiplos arquivos, ou seja, múltiplas classes
get_jast(JavaFileName) ->
	{ok, FileContent} = file:read_file(JavaFileName),
	Program = binary_to_list(FileContent),
	{ok, Tokens, _EndLine} = jaraki_lexer:string(Program),
	{ok, JavaSyntaxTree} = jaraki_parser:parse(Tokens),
	JavaSyntaxTree.

%%-----------------------------------------------------------------------------
%% Converte o jast em east.
%%   east -> arvore sintatica do erlang.
%% TODO: tratar múltiplos arquivos, ou seja, múltiplas classes
transform_jast_to_east(JavaAST, ModuleName) ->
	ErlangAST = lists:map(fun(Class) -> transform_class(Class) end, JavaAST),
	create_module(ModuleName, ErlangAST).

%%-----------------------------------------------------------------------------
%% Converte a classe do java em modulo erlang.
%% TODO: Tratar atributos ("variáveis globais") da classe...
transform_class(Class) ->
	{_, _, {class_body, ClassBody}} = Class,
	lists:map(fun(Method) -> transform_method(Method) end, ClassBody).

%%-----------------------------------------------------------------------------
%% Converte o metodo java em funcao erlang.
%% TODO: Tratar metodos genericos...
transform_method({Line, {method, 'main'}, Arguments, {_, MethodBody}}=Method) ->
	[{_, {class_identifier, ArgClass}, _}] = Arguments,
	case ArgClass of
		'String' ->
					ok;
		_ ->
			throw({error, "The args of the \"main method\" is not String"})
	end,

	TransformedMethodBody =
		transform_method_body(Line, MethodBody, Arguments),
	{function, Line, 'main', length(Arguments), TransformedMethodBody};
transform_method(_) ->
	throw({error, "The method defined is not a \"main method\""}).

%%-----------------------------------------------------------------------------
%% Converte o corpo do metodo java em funcao erlang.
%% TODO: Verificar melhor forma de detectar "{nil, Line}".
transform_method_body(Line, MethodBody, ArgumentsList) ->
	TransformedArgumentsList =
		[{var, ArgLine, Arg} || {ArgLine,_,{argument, Arg}} <- ArgumentsList],

	MapFun = fun({VarLine, var_declaration, Type, Name}) ->
						store_variable(VarLine, Type, Name);
					 (Expression) ->
						match_exp(Expression)
				  end,
	TransformedExpressions = lists:map( MapFun, MethodBody ),
	TransformedExpressions2 =
		[Element || Element <- TransformedExpressions, Element =/= nop],
	[{clause, Line, TransformedArgumentsList, [], TransformedExpressions2}].

%%-----------------------------------------------------------------------------
%% transformacoes de expressoes em java para erlang

%% transforma expressoes do tipo System.out.print( texto ) em Erlang
match_exp({Line, print, {text, Text}}) ->
	create_print_function(Line, text, Text);

%% transforma expressoes System.out.println( texto ) em Erlang
match_exp({Line, println, {text, Text}}) ->
	create_print_function(Line, text, Text ++ "~n");

%% transforma expressoes do tipo System.out.print( texto ) em Erlang
match_exp({Line, print, {var, VarName}}) ->
	create_print_function(Line, print, var, VarName);

%% transforma expressoes System.out.println( texto ) em Erlang
match_exp({Line, println, {var, VarName}}) ->
	create_print_function(Line, println, var, VarName);

%% Casa expressoes do tipo varivel = valor
%% TODO Nome ruim. Proposta match_exp
match_exp({Line, attribution,
			{var, VarName}, {var_value, VarValue}}) ->
	create_attribution(Line, VarName, VarValue).

%transform_expression({Line, println, {var, Var}}) ->
%    transform_print(Line, var, Var);

%%-----------------------------------------------------------------------------
%% Insere variavel na tabela de simbolos - dicionario do processo
store_variable( Line, {var_type, Type}, {identifier, Name} ) ->
	VarRecord = #var{java_name = atom_to_list(Name), type = Type},
	set_variable(Name, VarRecord),
	nop.

set_variable(VarName, NewVarRecord) ->
	put({vars, VarName}, NewVarRecord).

find_variable(VarName) ->
	case get({vars, VarName}) of
		undefined ->
			throw("Variable not declared");
		VarRecord ->
			{ok, VarRecord}
	end.

%%-----------------------------------------------------------------------------
%% Cria o elemento da east para as funcoes de impressao do java
create_print_function(Line, text, Text) ->
	{call, Line, {remote, Line,
		{atom, Line, io}, {atom, Line, format}}, [{string, Line, Text}]}.

create_print_function(Line, print, var, VarName) ->
	{ok, VarRecord} = find_variable(VarName),
	ErlangName = VarRecord#var.erl_name,
	{call, Line, {remote, Line,
		{atom, Line, io}, {atom, Line, format}},
		[{string, Line,"~p"}, {var, Line, list_to_atom(ErlangName)}]};

create_print_function(Line, println, var, VarName) ->
	{ok, VarRecord} = find_variable(VarName),
	ErlangName = VarRecord#var.erl_name,
	{call, Line, {remote, Line,
		{atom, Line, io}, {atom, Line, format}},
		[{string, Line,"~p~n"}, {var, Line, list_to_atom(ErlangName)}]}.

%%-----------------------------------------------------------------------------
%% Cria o elemento da east para atribuiçao de variaveis do java
create_attribution(Line, VarName, VarValue) ->
	{ok, VarRecord} = find_variable(VarName),

	Counter = VarRecord#var.counter + 1,
	ErlangName = "Var_" ++ VarRecord#var.java_name ++ integer_to_list(Counter),
	NewVarRecord = VarRecord#var{erl_name = ErlangName, counter = Counter},

	set_variable(VarName, NewVarRecord),

	{match, Line, {var, Line, list_to_atom(ErlangName)}, VarValue}.

%%-----------------------------------------------------------------------------
%% Cria o modulo a partir do east.
create_module(Name, ErlangAST) ->
	[{attribute, 1, module, Name},
		{attribute,1,compile,export_all}] ++ hd(ErlangAST)
		++ [{eof, 1}].

%% Desabilitado porque nao esta sendo usando
%%-----------------------------------------------------------------------------
from_erlang(Path) ->
	case epp:parse_file(Path, [], []) of
	{ok, Tree} -> Tree;
	Error -> throw(Error)
	end.
