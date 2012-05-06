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

-vsn(0.002).
-author('uea_ludus@googlegroups.com').

-compile(export_all).

%%-----------------------------------------------------------------------------
%% Escreve o codigo em erlang em um arquivo.
write_erlang_from_jaraki(String) ->
	Module = get_module_name(get_tree(String)),
	FileName = atom_to_list(Module) ++ ".erl",
	{ok, WriteDescriptor} = file:open(FileName, [raw, write]),
	file:write(WriteDescriptor, build_erlang_from_ast(String)),
	file:close(WriteDescriptor).

%%-----------------------------------------------------------------------------
%% Constroi o codigo em erlang a partir do ast.
build_erlang_from_ast(String) ->
	AbstractSyntaxTree = get_abstract_syntax_tree(String),
	erl_prettypr:format(erl_syntax:form_list(AbstractSyntaxTree)).

%%-----------------------------------------------------------------------------
%% Recebe o Abstract Form do codigo.
get_abstract_syntax_tree(String) ->
	Tree = get_tree(String),
	ModuleName = get_module_name(Tree),
	get_module(ModuleName,
		lists:map(fun(Class) -> transform_class(Class) end, Tree)).

%%-----------------------------------------------------------------------------
%% Gera a arvore sintatica do codigo.
get_tree(Name) ->
	{ok, Content} = file:read_file(Name),
	Program = binary_to_list(Content),
	{ok, Tokens, _EndLine} = jaraki_lexer:string(Program),
	{ok, Tree} = jaraki_parser:parse(Tokens),
	Tree.

%%-----------------------------------------------------------------------------
%% Recebe o nome do modulo.
get_module_name([{_, {class, ModuleName}, _}]) ->
	ModuleName.

%%-----------------------------------------------------------------------------
%% Recebe o modulo.
get_module(Name, AbstractSyntaxTree) ->
	get_module(Name, AbstractSyntaxTree, 1).

get_module(Name, AbstractSyntaxTree, EndofLine) ->
	[{attribute,1,module,Name},
		{attribute,1,compile,export_all}] ++ hd(AbstractSyntaxTree)
		++ [{eof, EndofLine}].

%%-----------------------------------------------------------------------------
%% Converte a classe em erlang.
transform_class({_, _, {class_body, ClassBody}}) ->
	transform_class_body(ClassBody).

%%-----------------------------------------------------------------------------
%% Converte o corpo da classe em erlang.
transform_class_body(ClassBody) ->
	lists:map(fun(Method) -> transform_method(Method) end, ClassBody).

%%-----------------------------------------------------------------------------
%% Converte o metodo em erlang.
transform_method({Line, {method, Method = 'main'},
		[{_, {class_identifier, _ = 'String'}, _}] = ArgumentList,
					{method_body, MethodBody}}) ->
	TransformMethodBody =
		transform_method_body(Line, MethodBody, ArgumentList),
		build_method(Method, Line, length(ArgumentList), TransformMethodBody);
transform_method(_) ->
	throw({error, "O método não está de acordo com o método main"}).

%%-----------------------------------------------------------------------------
%% Constroi a funcao em erlang.
build_method(Name, Line, Arity, AbstractSyntaxTree) ->
	{function, Line, Name, Arity, AbstractSyntaxTree}.

%%-----------------------------------------------------------------------------
%% Converte o corpo do metodo em erlang.
transform_method_body(Line, MethodBody, ArgumentList) ->
	[ build_method_body
		(
			[transform_argument(Arg) || Arg <- ArgumentList],
			Line,
			lists:map
			(
				fun(L) -> transform_expression(L) end,
				MethodBody
			)
	   	)
	].

%%-----------------------------------------------------------------------------
%% Converte o argumento em erlang.
transform_argument({Line, _, {argument, Var}}) -> {var, Line, Var}.

%%-----------------------------------------------------------------------------
%% Converte a expressao em erlang.
transform_expression({Line, print, Text}) ->
	transform_print(Line, Text);
transform_expression({Line, println, Text}) ->
	transform_print(Line, Text ++ "~n").

%%-----------------------------------------------------------------------------
%%Constroi o io:format.
transform_print(Line, Text) ->
	{call, Line, {remote, Line,
		{atom, Line, io}, {atom, Line, format}}, [{string, Line, Text}]}.

%%-----------------------------------------------------------------------------
%% Constroi o corpo da funcao em erlang.
build_method_body(Pattern, Line, Body) ->
	{clause, Line, Pattern, [], Body}.

%% Desabilitado porque nao esta sendo usando
%%-----------------------------------------------------------------------------
%%from_erlang(Path) ->
%%	case epp:parse_file(Path, [], []) of
%%	{ok, Tree} -> Tree;
%%	Error -> throw(Error)
%%	end.
