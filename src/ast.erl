%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%% 			Eden ( edenstark@gmail.com )
%% 			Helder Cunha Batista ( hcb007@gmail.com )
%% 			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%% 			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%% 			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Gerar a arvore sintatica a java a partir de um codigo-fonte
%% Objetivo : Gerar os tokens java a partir de um codigo-fonte

-module(ast).
-export([get_java_ast/1, get_java_tokens/1, get_class_info/1]).

%%-----------------------------------------------------------------------------
%% Extrai a Java Abstract Syntax Tree de um arquivo .java
%% o parser armazena no dicionario de processos informações da classe!
get_java_ast(JavaFileName) ->
	JavaTokens = get_java_tokens(JavaFileName),
	{ok, JavaAST} = jaraki_parser:parse(JavaTokens),
	JavaAST.

%%-----------------------------------------------------------------------------
%% Extrai a lista de Tokens de um arquivo .java
get_java_tokens(JavaFileName) ->
	{ok, FileContent} = file:read_file(JavaFileName),
	Program = binary_to_list(FileContent),
	{ok, JavaTokens, _EndLine} = jaraki_lexer:string(Program),
	JavaTokens.

%% Dicionario de classes
%% Estrutura do dicionario:
%% Chave:
%%		{oo_classes, Classe}
%% Valor:
%%		[Campo1, Campo2, ...], [Metodo1, Metodo2, ...]}
%%
%% Variáveis:
%%		Classe		  => atom()
%%		Campo		  => {Nome, Tipo,		Modificadores}
%%		Metodo		  => {Nome, TipoRetorno, Parametros, Modificadores}
%%		Nome		  => atom()
%%		Tipo		  => atom()
%%		Modificadores => [ atom() ]
%%		Parametros    => { Nome, Tipo }
%%
%% Extrai informações da classe e seus  membros (campos e métodos)
get_class_info(JavaAST) ->
	[{_, {class, ClassName}, {class_body, ClassBody}}] = JavaAST,
	{FieldsInfo, MethodsInfo} = get_members_info(ClassBody),
	{ClassName, lists:flatten(FieldsInfo), MethodsInfo}.

get_members_info(ClassBody) ->
	get_members_info(ClassBody, [], []).

get_members_info([], FieldsInfo, MethodsInfo) ->
	{FieldsInfo, MethodsInfo};

get_members_info([Member | Rest], FieldsInfo, MethodsInfo) ->
	case Member of
		{_,{_, ReturnType}, {method, MethodName}, ParameterList, _} ->
			ParametersInfo = get_parameters_info(ParameterList),
			NewMethod = {MethodName, ReturnType, ParametersInfo, []},
			get_members_info(Rest, FieldsInfo, [NewMethod | MethodsInfo]);

		{var_declaration, {var_type, TypeJast}, {var_list, VarJastList}} ->
			{_line, VarType} = TypeJast,
			NewField = get_fields_info(VarJastList, VarType),
			get_members_info(Rest, [NewField | FieldsInfo], MethodsInfo)
	end.

get_parameters_info(ParameterList) ->
	[ {Name, Type} || {_, {_, {_, Type}}, {_, Name}} <- ParameterList ].

get_fields_info(VarJastList, VarType) ->
	[ {VarName, VarType, []} || {{var, VarName}, _VarValue} <- VarJastList ].
