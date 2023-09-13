% :- include('analyzer/morph_analyzer.pl').
:- op(500, xfy, '=>').

% Lexicon
[[noun,[çocuk, ne, neler, kim,kimler,hangisi,hangileri]]] => [çocuk].
[noun,plur] => [çocuklar].
[[noun,[elma, ne, neler, kim,kimler,hangisi,hangileri]]] => [elma].
[[verb, [[yiyor, neyaptý]]]] => [yiyor].
[[verb, [[geldi, neyaptý]]]] => [geldi].

% Phrase Structure Rules
[verb, [Element1|List2]] => ([noun, Element1], [verb, List2]).
% [verb|Rest] =>  ([verb|Rest], [noun|_]).


%%% PARSER
% Base
sr_parse([[_,[List1, List2]]], []):-
          generate_questions(List1, List2, List),
          writeln(List).

% Shift
sr_parse(Stack, [Word|Words]):-
  [Cat] => [Word],
%  parse(Word, Cat),
  sr_parse([Cat|Stack], Words).
  
% Reduce
sr_parse([Y, X|Rest], String):-
  Z => (X, Y),
  sr_parse([Z|Rest], String).



generate_questions([], _, []).

generate_questions([X|Qs], List, List_Out):-
    generate_questions2(X, List, List_Out1),
    generate_questions(Qs, List,List_Out2),
    append(List_Out1,List_Out2,List_Out).
    
    
generate_questions2(_, [], []).

generate_questions2(X, [Y|Ys], [[X,Y]|Rest]):-
   generate_questions2(X, Ys,Rest).



