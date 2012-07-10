%% LUDUS - Laboratorio de Projetos Especiais em Engenharia da Computacao
%% Aluno  : Daniel Henrique Braz Aquino ( dhbaquino@gmail.com )
%%			Eden Freitas Ramos ( edenstark@gmail.com )
%%			Helder Cunha Batista ( hcb007@gmail.com )
%%			Josiane Rodrigues da Silva ( josi.enge@gmail.com )
%%			Lídia Lizziane Serejo de Carvalho ( lidializz@gmail.com )
%%			Rodrigo Barros Bernardino ( rbbernardino@gmail.com )
%% Orientador : Prof Jucimar Jr ( jucimar.jr@gmail.com )
%% Objetivo : Funções auxiliares usadas em diferentes partes da semântica

-module(helpers).
-export([get_variable_context/2]).

%%-----------------------------------------------------------------------------
%% Ao usar uma variável, determina se está sendo feito referência a uma variável
%% local (do método) ou do objeto
%%
%% TODO: a próxima função poderia ir e um módulo separado (tree_helpers)
get_variable_context(Scope, VarName) ->
	{ScopeClass, ScopeMethod} = Scope,

	IsDeclaredVar  = st:is_declared_var(Scope, VarName),
	IsStaticMethod = st:is_static_method(ScopeClass, ScopeMethod, []),
	ExistField     = st:exist_field(ScopeClass, VarName),

	case IsDeclaredVar of
		true  -> {ok, local};
		false ->
			case IsStaticMethod of
				true ->
					case ExistField of
						true  -> {error, 10};
						false -> {error, 1}
					end;

				false ->
					case ExistField of
						true  -> {ok, object};
						false -> {error, 1}
					end
			end
	end.
