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
					{_Line2, {name, ClassName}, {body, ClassBody}} = ClassData,
					Retorno = get_file_exists(FileList, atom_to_list(ClassName)++".java"),
					
					case Retorno of
						true ->
							{FieldsInfo, MethodsInfo} = get_members_info(ClassBody),
							LowerClassName = to_lower_atom(ClassName),
							{LowerClassName, lists:flatten(FieldsInfo), MethodsInfo};
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
			{_Line3, {name, ClassName}, {body, ClassBody}} = ClassData,
			{FieldsInfo, MethodsInfo} = get_members_info(ClassBody),
			LowerClassName = to_lower_atom(ClassName),
			{LowerClassName, lists:flatten(FieldsInfo), MethodsInfo}
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
%% info de membros (método ou campo)
get_members_info(ClassBody) ->
	get_members_info(ClassBody, [], []).

get_members_info([], FieldsInfo, MethodsInfo) ->
	{lists:reverse(FieldsInfo, []), lists:reverse(MethodsInfo, [])};

%% TODO descomentar ParameterList...
get_members_info([{method, MethodData} | Rest], FieldsInfo, MethodsInfo) ->
	{_, ReturnJast, NameJast, ModifiersJast, ParameterList, _} = MethodData,
	{return, {_, Return}} = ReturnJast,
	{name, Name} = NameJast,
	{modifiers, ModifierList} = ModifiersJast,
	NewMethod = get_method_info(Name, ModifierList, Return, ParameterList),
	get_members_info(Rest, FieldsInfo, [NewMethod | MethodsInfo]);

%% TODO: Tratar Modificadores de campos
get_members_info([{var_declaration, VarTypeJast, VarList} | Rest],
					FieldsInfo, MethodsInfo) ->
	{var_type, TypeJast}    = VarTypeJast,
	{var_list, VarJastList} = VarList,
	{_line, VarType} = TypeJast,
	NewField = get_fields_info(VarJastList, VarType),
	get_members_info(Rest, [NewField | FieldsInfo], MethodsInfo).

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
%% normaliza o nome da classe
to_lower_atom(Atom) ->
	list_to_atom(string:to_lower(atom_to_list(Atom))).
