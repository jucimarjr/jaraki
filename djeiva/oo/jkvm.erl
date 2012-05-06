-module(jkvm).
-export([start/1]).

%% recebe as classes e os atributos de classes (se existirem)
%%	Dicionário "dict" (chave:valor \n significado)
%%		object_counter : interger()
%%			gera identificadores de objeto únicos
%%		{object_var, ObjectID, VarName} : {VarType, VarValue}
%%			representa um atributo de um objeto específico
%%		{object, ObjectID} : {ClassName, SuperClasses}
%%			representa um objeto, com sua classe e suas superclasses
%%			as superclasses vêm em uma lista em ordem hierárquica crescente
%%			(da superclasse menos genérica para a mais genérica)
start(_StaticClassesFields) ->
	ets:new(dict, [named_table]),
	ets:insert(dict, {object_counter, 0}).
	%% ets:new(class_dict, [named_table]). %% armazenar atributos static
