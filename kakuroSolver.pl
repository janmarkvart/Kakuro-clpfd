:- use_module(library(clpfd)).

%input -> 2D array representing board (see examples below)
kakuroMain(Board) :-
    kakuroSlice(Board,RulesetRows),
    transpose(Board, TransBoard),
    kakuroSlice(TransBoard,RulesetCols),
    append(RulesetRows,RulesetCols,Ruleset),
    kakuro(Ruleset).

%cuts board line by line
kakuroSlice([],[]).
kakuroSlice([Line|Rest],Sliced) :-
    kakuroDice(Line,[],DicedPart),
    kakuroSlice(Rest,NewSlicedPart),
    append(DicedPart,NewSlicedPart,Sliced).

%find rules on a line, by going over each element 
%first argument - line to be processed
%second argument - variable list to be added as a rule
%third argument - list of found rules
kakuroDice([], [], []).
kakuroDice([H|T], [], Rest) :- %list element is number, but buffer is empty, so no new rule is generated
    number(H),
    kakuroDice(T,[], Rest).
kakuroDice([H|T], [], [podminka([BH|Buff],H)|Rest]) :- %list element is number, gets vars from buffer
    number(H),
    kakuroDice(T,[BH|Buff], Rest).
kakuroDice([H|T], [H|Buff], Rest) :- %is not number, adds to buffer
    \+ number(H),
    kakuroDice(T,Buff, Rest).

% Finds bindings for the kakuro constraints.
kakuro(Podminky) :-
	kakuroSolve(Podminky, Variables),
	label(Variables).

%recursive helper function to find bindings
kakuroSolve([], []).
kakuroSolve([podminka(Vars, Sum)|Podminky], Left) :-
	Vars ins 1..9,
	sum(Vars, #=, Sum),
	all_distinct(Vars),
	append(Vars, NewLeft, Left),
	kakuroSolve(Podminky, NewLeft).

%example rulesets
%2*3 - kakuro([podminka([X,Y],3)]).
%3*4 - kakuro([podminka([A1,A2,A3],13),podminka([B1,B2,B3],8),podminka([A1,B1],6),podminka([A2,B2],6),podminka([A3,B3],9)]).

%example boards
%2*2 - kakuroMain([[0,2],[2,A]]).
%2*3 - kakuroMain([[0,6,6,9],[13,A1,A2,A3],[8,B1,B2,B3]]).