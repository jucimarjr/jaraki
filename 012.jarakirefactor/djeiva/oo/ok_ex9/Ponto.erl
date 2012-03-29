-module('Ponto').
-export([printPoint/1]).

printPoint(ObjectID) ->
	Scope = {printPoint, 'Ponto'},

	io:format("~s~p~s~p~n",
		[ "x ",
		oo:get_attribute(ObjectID, "x"),
		"    y: ",
		oo:get_attribute(ObjectID, "y")]).
