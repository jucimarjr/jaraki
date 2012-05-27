%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%%			Eden ( edenstark@gmail.com )
%%			Helder Cunha Batista ( hcb007@gmail.com )
%%			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%%			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%%			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
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

%%-----------------------------------------------------------------------------
%% Extrai informações da classe e seus  membros (campos e métodos)
%%
%% Estrutura do retorno:
%%		[Classe1, Classe2, ... ]
%%
%% ClasseN: {Nome, Campos, Metodos}
%%
%% Campos:  [Campo1, Campo2, ...]
%% Metodos: [Metodo1, Metodo2, ...]
%%
%% CampoN:
%%		{Nome, CampoValue}
%%			   |
%%			   |> {Tipo, Modificadores}
%%
%% MetodoN:
%%		{ MethodKey, MethodValue}
%%		  |			 |
%%		  |			 |> {TipoRetorno, Modificadores}
%%		  |
%%		  |> {Nome, Parametros}
%%
%% Outros:
%%		Tipo			=> atom()
%%		Nome			=> atom()
%%		Modificadores	=> [ atom() ]
%%		Parametros		=> [ Tipo ]

%%-----------------------------------------------------------------------------
%% info das classes
get_class_info(JavaAST) ->
	[{_, {class, ClassName}, {class_body, ClassBody}}] = JavaAST,
	{FieldsInfo, MethodsInfo} = get_members_info(ClassBody),
	{ClassName, lists:flatten(FieldsInfo), MethodsInfo}.

%%-----------------------------------------------------------------------------
%% info de membros (método ou campo)
get_members_info(ClassBody) ->
	get_members_info(ClassBody, [], []).

get_members_info([], FieldsInfo, MethodsInfo) ->
	{lists:reverse(FieldsInfo, []), lists:reverse(MethodsInfo, [])};

%% TODO: Tratar Modificadores
get_members_info([Member | Rest], FieldsInfo, MethodsInfo) ->
	case Member of
		{_,{_, ReturnType}, {method, MethodName}, ParameterList, _} ->
			NewMethod = get_method_info(MethodName, ReturnType, ParameterList),
			get_members_info(Rest, FieldsInfo, [NewMethod | MethodsInfo]);

		{var_declaration, {var_type, TypeJast}, {var_list, VarJastList}} ->
			{_line, VarType} = TypeJast,
			NewField = get_fields_info(VarJastList, VarType),
			get_members_info(Rest, [NewField | FieldsInfo], MethodsInfo)
	end.

%%-----------------------------------------------------------------------------
%% info de métodos
get_method_info(MethodName, ReturnType, ParameterList) ->
	ParametersInfo = get_parameters_info(ParameterList),
	MethodKey      = {MethodName, ParametersInfo},
	MethodValue    = {ReturnType, []}, %% TODO: [] = Modifiers
	{MethodKey, MethodValue}.

get_parameters_info(ParameterList) ->
	[ Type || {_, {_, {_, Type}}, {_, _}} <- ParameterList ].

%%-----------------------------------------------------------------------------
%% info de campos
get_fields_info(VarJastList, VarType) ->
	get_fields_info(VarJastList, VarType, []).

get_fields_info([], _, FieldsInfo) ->
	lists:reverse(FieldsInfo, []);
get_fields_info([VarJast | Rest], VarType, FieldsInfo) ->
	{{var, VarName}, _VarValue} = VarJast,
	VarKey = VarName,
	VarValue = {VarType, []}, %% TODO: [] = Modifiers
	NewFieldInfo = {VarKey, VarValue},
	get_fields_info(Rest, VarType, [ NewFieldInfo | FieldsInfo ]).
