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

-vsn(0.005).
-author('uea_ludus@googlegroups.com').

-compile(export_all).

-include("../include/records.hrl").

%%-----------------------------------------------------------------------------
%% Escreve o codigo em erlang a partir do java.
%% TODO: tratar múltiplos arquivos, ou seja, múltiplas classes
	write_erlang_from_jaraki(JavaFileName) ->
	JavaAST = get_jast(JavaFileName),
	[{_Line, {class, ClassName}, _ClassBody}] = JavaAST,
	ModuleName = list_to_atom(string:to_lower(atom_to_list(ClassName))),
	ErlangFileName = atom_to_list(ModuleName) ++ ".erl",

	ErlangAST = transform_jast_to_east(JavaAST, ModuleName),
	ErlangCode = erl_prettypr:format(erl_syntax:form_list(ErlangAST)),

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
	{ok, JavaAST} = jaraki_parser:parse(Tokens),
	JavaAST.

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
	{_Line, _ClassName, {class_body, ClassBody}} = Class,
	lists:map(fun(Method) -> transform_method(Method) end, ClassBody).

%%-----------------------------------------------------------------------------
%% Converte o metodo java em funcao erlang.
%% TODO: Tratar metodos genericos...
transform_method({Line, {method, 'main'}, Arguments, 
					{method_body, MethodBody}} = Method) ->
		[{_Line, {class_identifier, ArgClass}, _ArgName}] = Arguments,
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
		[{var, Line, ArgName} || 
			{Line, _ClassIdentifier, {argument, ArgName}} <- ArgumentsList],

	MapFun = fun({VarLine, var_declaration, Type, Name}) ->
						store_variable(VarLine, Type, Name);
					 (Expression) ->
						match_expression(Expression)
				  end,
	TransformedExpressions = lists:map( MapFun, MethodBody ),
	TransformedExpressions2 =
		[Element || Element <- TransformedExpressions,
											Element =/= no_operation],
	[{clause, Line, TransformedArgumentsList, [], TransformedExpressions2}].

%%-----------------------------------------------------------------------------
%% transformacoes de expressoes em java para erlang

%% transforma expressoes do tipo System.out.print( texto ) em Erlang
match_expression({Line, print, {text, Text}}) ->
	create_print_function(Line, text, Text);

%% transforma expressoes System.out.println( texto ) em Erlang
match_expression({Line, println, {text, Text}}) ->
	create_print_function(Line, text, Text ++ "~n");

%% transforma expressoes do tipo System.out.print( texto ) em Erlang
match_expression({Line, print, {var, VarName}}) ->
	create_print_function(Line, print, var, VarName);

%% transforma expressoes System.out.println( texto ) em Erlang
match_expression({Line, println, {var, VarName}}) ->
	create_print_function(Line, println, var, VarName);

%% Casa expressoes do tipo varivel = valor
match_expression({Line, attribution,
			{var, VarName}, {var_value, VarValue}}) ->
	create_attribution(Line, VarName, VarValue).

%%-----------------------------------------------------------------------------
%% Insere variavel na tabela de simbolos - dicionario do processo
store_variable( Line, {var_type, Type}, {identifier, Name} ) ->
	VarRecord = #var{java_name = atom_to_list(Name), type = Type},
	set_variable(Name, VarRecord),
	no_operation.

set_variable(VarName, NewVarRecord) ->
	put({vars, VarName}, NewVarRecord).

find_variable(VarName) ->
	case get({vars, VarName}) of
		undefined ->
			throw({error, "Variable not declared"});
		VarRecord ->
			{ok, VarRecord}
	end.

match_attr_expr({op, Line, Op, RightExp}=UnaryOp) ->
	{op, Line, Op, match_attr_expr(RightExp)};
match_attr_expr({integer, _Line, _Value} = Element) ->
	Element;
match_attr_expr({float, _Line, _Value} = Element) ->
	Element;
match_attr_expr({op, Line, Op, LeftExp, RightExp}) ->
	{op, Line, Op, match_attr_expr(LeftExp), match_attr_expr(RightExp)};
match_attr_expr({var, Line, VarName}) ->
	{ok, VarRecord} = find_variable(VarName),
	case VarRecord#var.counter of
		0 ->
			throw({error, "Variable in expression never used"});
		_ ->
			ok
	end,
	Counter = VarRecord#var.counter,
	ErlangName = "Var_" ++ VarRecord#var.java_name ++ integer_to_list(Counter),
	{var, Line, list_to_atom(ErlangName)}.

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
		[{string, Line,"~p"}, 
			{cons, Line, {var, Line, list_to_atom(ErlangName)}, {nil, Line}}]};

create_print_function(Line, println, var, VarName) ->
	{ok, VarRecord} = find_variable(VarName),
	ErlangName = VarRecord#var.erl_name,
	{call, Line, {remote, Line,
		{atom, Line, io}, {atom, Line, format}},
		[{string, Line,"~p~n"}, 
			{cons, Line, {var, Line, list_to_atom(ErlangName)}, {nil, Line}}]}.

%%-----------------------------------------------------------------------------
%% Cria o elemento da east para atribuiçao de variaveis do java
create_attribution(Line, VarName, VarValue) ->
	{ok, VarRecord} = find_variable(VarName),

	Counter = VarRecord#var.counter + 1,
	ErlangName = "Var_" ++ VarRecord#var.java_name ++ integer_to_list(Counter),
	NewVarRecord = VarRecord#var{erl_name = ErlangName, counter = Counter},

	Transformed_VarValue = match_attr_expr(VarValue),

	set_variable(VarName, NewVarRecord),

	{match, Line, {var, Line, list_to_atom(ErlangName)}, Transformed_VarValue}.

%%-----------------------------------------------------------------------------
%% Cria o modulo a partir do east.
create_module(Name, ErlangAST) ->
	[{attribute, 1, module, Name},
		{attribute,1,compile,export_all}] ++ hd(ErlangAST)
		++ [{eof, 1}].



%%-----------------------------------------------------------------------------
%% As funcoes a seguir sao utilitarios, nao fazem parte da compilacao

%%-----------------------------------------------------------------------------
%% Transforma o código erlang em Abstract Syntax Tree
transform_erlang_to_ast(Path) ->
	case epp:parse_file(Path, [], []) of
	{ok, Tree} -> Tree;
	Error -> throw(Error)
	end.

%%-----------------------------------------------------------------------------
%% Imprime a árvore do java gerada análise sintática do compilador
print_jast(JavaFileName) ->
	io:format("Generating Syntax Analysis... "),

	JavaAST = get_jast(JavaFileName),

	io:format("done!~n"),
	io:format("Jaraki Syntax Tree from ~p:~n", [JavaFileName]),
	io:format("~p~n", [JavaAST]).

%%-----------------------------------------------------------------------------
%% Imprime os tokens do java gerados pela análise léxica do compilador
print_tokens(JavaFileName) ->
	io:format("Generating Lexical Analysis... "),

	{ok, FileContent} = file:read_file(JavaFileName),
	Program = binary_to_list(FileContent),
	{ok, Tokens, _EndLine} = jaraki_lexer:string(Program),

	io:format("done!~n"),
	io:format("Jaraki Tokens from ~p:~n", [JavaFileName]),
	io:format("~p~n", [Tokens]).
