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
%% Objetivo : Montar informações de uma classe para ser usado durante a análise

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
%% ClasseN: {NomePai, Nome, Campos, Metodos, Construtores}
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
%% ConstrutorN:
%%		{ ConsrutorKey, ConstrutorValue }
%%		  |             |
%%		  |             |> Visibilidade
%%		  |> Parametros
%%
%% Outros:
%%		Tipo			=> atom()
%%		Nome			=> atom()
%%		Modificadores	=> [ atom() ]
%%		Parametros		=> [ Tipo ]
%%		Visibilidade    => atom()

%%-----------------------------------------------------------------------------
%% info das classes
get_class_info(JavaAST) ->
	case JavaAST of
		[{Line, {package,PackageName}, {class_list, [{class, ClassData}]}}] ->
			{ok,DirAtual} = file:get_cwd(),
			Package = get_packge_struct(PackageName),
			Dir = DirAtual ++ "/java_src/" ++ Package,

			case file:list_dir(list_to_atom(Dir)) of
				{error, eacces} ->
					jaraki_exception:handle_error(Line, 16),
					io:format("diretorio sem permissão de acesso!\n\n");
				{error, enoent} ->
					jaraki_exception:handle_error(Line, 14),
					io:format("diretorio inexistente!\n\n");
				{ok, FileList} ->
					{_Line2, NameJast, ParentJast, BodyJast} = ClassData,
					{name, ClassName}    = NameJast,
					{parent, ParentName} = ParentJast,
					{body, ClassBody}    = BodyJast,

					Retorno = get_file_exists(FileList,
									atom_to_list(ClassName)++".java"),

					case Retorno of
						true ->
							{FieldsInfo, MethodsInfo, ConstrInfo} =
								get_members_info(ClassBody),
							LowerClassName = to_lower_atom(ClassName),
							ParentName2    = to_lower_atom(ParentName),
							FieldsInfo2    = lists:flatten(FieldsInfo),
							{LowerClassName, ParentName2,
								FieldsInfo2,MethodsInfo,ConstrInfo};
						false ->
							jaraki_exception:handle_error(Line, 15),
							io:format("O aquivo nao consta no diretorio!\n\n")
					end
					%io:format("bbbbb  ~p~n~n~n", [FileList])
			end;

			%	false ->
			%			jaraki_exception:handle_error(Line, 15),
			%			io:format("O aquivo nao consta no diretorio!\n\n")
			%end;

		[{class, ClassData}] ->
			{_Line3, NameJast, ParentJast, BodyJast} = ClassData,
			{name, ClassName}    = NameJast,
			{parent, ParentName} = ParentJast,
			{body, ClassBody}    = BodyJast,

			{FieldsInfo, MethodsInfo, ConstrInfo} = get_members_info(ClassBody),
			LowerClassName  = to_lower_atom(ClassName),
			ParentName2 = to_lower_atom(ParentName),
			FieldsInfo2     = lists:flatten(FieldsInfo),
			{LowerClassName, ParentName2, FieldsInfo2, MethodsInfo, ConstrInfo}
	end.


%%-----------------------------------------------------------------------------
%% Monta a estrutura do pacote
get_packge_struct([Head|Rest])	->
	get_packge_struct(Rest, atom_to_list(Head)).

get_packge_struct([], Struct)	->
	Struct;

get_packge_struct([Head|Rest], Struct)	->
	get_packge_struct(Rest,Struct++"/"++atom_to_list(Head)).

get_file_exists([Head|[]], File) ->
	
	case Head of
		File -> true;
		_	-> false
	end;

get_file_exists([Head|Rest], File) ->
	case Head of
		File -> true;
		_	-> get_file_exists(Rest,File)
	end.

%%-----------------------------------------------------------------------------
%% info de membros (método ou campo) e construtores
get_members_info(ClassBody) ->
	get_members_info(ClassBody, [], [], []).

get_members_info([], FieldsInfo, MethodsInfo, ConstructorsInfo) ->
	FieldsInfo2 = lists:reverse(FieldsInfo, []),
	MethodsInfo2 = lists:reverse(MethodsInfo, []),
	ConstructorsInfo2 = lists:reverse(ConstructorsInfo, []),
	{FieldsInfo2, MethodsInfo2, ConstructorsInfo2};

get_members_info([{method, MethodData} | Rest],
						FieldsInfo, MethodsInfo, ConstInfo) ->
	{_, ReturnJast, NameJast, ModifiersJast, ParameterList, _} = MethodData,
	{return, {_, Return}} = ReturnJast,
	{name, Name} = NameJast,
	{modifiers, ModifierList} = ModifiersJast,
	NewMethod = get_method_info(Name, ModifierList, Return, ParameterList),
	get_members_info(Rest, FieldsInfo, [NewMethod | MethodsInfo], ConstInfo);

%% TODO: Tratar Modificadores de campos
get_members_info([{var_declaration, VarTypeJast, VarList} | Rest],
						FieldsInfo, MethodsInfo, ConstInfo) ->
	{var_type, TypeJast}    = VarTypeJast,
	{var_list, VarJastList} = VarList,
	{_line, VarType} = TypeJast,
	NewField = get_fields_info(VarJastList, VarType),
	get_members_info(Rest, [NewField | FieldsInfo], MethodsInfo, ConstInfo);

%% checagem nome da classe x nome do construtor decladado realizada depois
get_members_info([{constructor, ConstData} | Rest],
						FieldsInfo, MethodsInfo, ConstInfo) ->
	{_, _Name, VisibilityJast, ParameterList, _} = ConstData,
	{visibility, Visibility} = VisibilityJast,
	NewConst = get_constructor_info(Visibility, ParameterList),
	get_members_info(Rest, FieldsInfo, MethodsInfo, [NewConst | ConstInfo]).

%%-----------------------------------------------------------------------------
%% info de métodos
get_method_info(MethodName, ModifierList, ReturnType, ParameterList) ->
	ParametersInfo = get_parameters_info(ParameterList),
	MethodKey      = {MethodName, ParametersInfo},
	MethodValue    = {ReturnType, ModifierList},
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

%%-----------------------------------------------------------------------------
%% construtores
get_constructor_info(Visibility, ParameterList) ->
	ParametersInfo = get_parameters_info(ParameterList),
	ConstructorKey = ParametersInfo,
	ConstructorValue    = Visibility,
	{ConstructorKey, ConstructorValue}.

%%-----------------------------------------------------------------------------
%% normaliza o nome da classe
to_lower_atom(Atom) ->
	list_to_atom(string:to_lower(atom_to_list(Atom))).
