:-include('includes.pl').
:-include('question_generator1.pl').

:-encoding(utf8).
:- set_prolog_flag(stack_limit, 2_147_483_648).

:- op(500, xfy, '==>').

% Phrase Structure Rules
List ==> (List1, List2):- append(List1, List2, List).

%%% PARSER
% Top-Level

parse(Answer):- tokenize(Answer, List_of_Words),
                findall(Qs,sr_parse(List_of_Words, Qs),Questions),
                writeln(Questions).
                
sr_parse(Answer, Questions):-
          sr_parse([], Answer, Cat),
          generate_questions(Cat, [_|Questions]).

% Base
sr_parse([Cat], [], Cat).

% Shift
sr_parse(Stack, [Word|Words], R):-
  analyze(Word,_,Cat),
  generate_q_lists(Cat, Qs),
  append([Word],Qs,Qs1),
  sr_parse([[Qs1]|Stack], Words, R).

% Reduce
sr_parse([Y, X|Rest], String, R):-
  Z ==> (X, Y),
  sr_parse([Z|Rest], String, R).
