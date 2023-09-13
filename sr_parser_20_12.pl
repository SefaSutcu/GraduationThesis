:- include('morph_analyzer.pl').
:- include('generate_word.pl').
:- include('find_last_suffix.pl').
:- encoding(utf8).
:- op(500, xfy, '==>').
% Lexicon
possible_last_word(amaç).
possible_last_word(avrupa).

[noun] ==> [ne, kim, hangi, neler, kimler, hangiler].
% [locative_morpheme] ==> [nere].
[verb] ==> [neyap].
[adverb] ==> [nasıl].
[adverb_time] ==> [nezaman].
[adjective_char] ==> [nasıl, hangi].
[adjective_mark] ==> [hangi].
[adjective_number] ==> [kaç].
[adjective_number_placement] ==> [kaçıncı].
[adjective_number_ct] ==> [kaçar].
[conj] ==> [].
% [] ==> [kaç, kaçta, nekadar, nezaman]
% [] ==> [niye, neden, niçin].

% Phrase Structure Rules
List ==> (List1, List2):- append(List1, List2, List).

[vp, Pros] ==> ([vp, List_QuestionWords_1], [vp, List_QuestionWords_2]):-
       append([List_QuestionWords_1], [List_QuestionWords_2], Pros),
       writeln(Pros).

[verb, Pros] ==> ([noun|List_QuestionWords_1], [verb, List_QuestionWords_2]):-
       append([List_QuestionWords_1], List_QuestionWords_2, Pros).
       
[verb, Pros] ==> ([adverb|List_QuestionWords_1], [verb, List_QuestionWords_2]):-
       append([List_QuestionWords_1], List_QuestionWords_2, Pros).

[verb, Pros] ==> ([adverb_time|List_QuestionWords_1], [verb, List_QuestionWords_2]):-
       append([List_QuestionWords_1], List_QuestionWords_2, Pros).
       
[verb, Pros] ==> ([adjective_char|List_QuestionWords_1], [verb, List_QuestionWords_2]):-
       append([List_QuestionWords_1], List_QuestionWords_2, Pros).

[verb, Pros] ==> ([adjective_mark|List_QuestionWords_1], [verb, List_QuestionWords_2]):-
       append([List_QuestionWords_1], List_QuestionWords_2, Pros).

[verb, Pros] ==> ([adjective_number_placement|List_QuestionWords_1], [verb, List_QuestionWords_2]):-
       append([List_QuestionWords_1], List_QuestionWords_2, Pros).

[verb, Pros] ==> ([adjective_number_ct|List_QuestionWords_1], [verb, List_QuestionWords_2]):-
       append([List_QuestionWords_1], List_QuestionWords_2, Pros).

[verb, Pros] ==> ([conj|List_QuestionWords_1], [verb, List_QuestionWords_2]):-
       append([List_QuestionWords_1], List_QuestionWords_2, Pros).



%%% PARSER

sr_parse(Sentence_L, Questions_LL):-
   sr_parse([], Sentence_L, [], Questions_LL).

% Base
sr_parse(Q_LL, [], _, Questions):-

  reverse(Q_LL, Q_LLL),
  %writeln(Q_LLL),
  cartesian_product_of_LLL(Q_LLL, Questions),
  length(Questions, Len),
  %write_list_lines(Questions),
  write(Len),
  writeln(" Questions are created"),!.



% Shift
sr_parse(Stack, [Word|Words], Phrase_Word_Stack, QANS):-

  parse(Word, [Root_Morpheme|Rest_Morphemes], _),
  
  % check_if_locative(Rest_Morphemes, Root_Morpheme_),
  % ((Root_Morpheme == locative_morpheme) -> true; Root_Morpheme_ = Root_Morpheme),

  [Root_Morpheme] ==> Qs,

  (
  (Root_Morpheme == noun) -> find_last_suffix(Rest_Morphemes, Last_Morpheme),
  (var(Last_Morpheme) -> generate_interrogative3(Qs, Question_Words); generate_interrogative2(Qs, Last_Morpheme, Question_Words)); true
  ), %%eğer kelime isim ise son gelen eki bulur ve soru kelimelerini o ekle beraber üretiriz, ek yok ise pas geçer
  
  (
  (Root_Morpheme == verb) -> generate_interrogative(Qs, Rest_Morphemes, Question_Words); true
  ), %% eğer kelime fiil ise fiile gelen bütün ekleri soru kelimelerine ekleriz

  (
  var(Question_Words) -> (Question_Words=Qs); true
  ), %% eğer question words değişkeni tanımlanmamışsa (kelimemiz isim veya fiil değildi) soru kelimeleri eksiz tanımlanır


  append([Word], Question_Words, List_Question_Words),
  append(Phrase_Word_Stack, [List_Question_Words], List_Phrase_Words),
  %writeln(List_Phrase_Words),
  (
  ((possible_last_word(Word),!); (nonvar(Last_Morpheme),!); Root_Morpheme==verb) ->
  (
  generate_phrase_questions(List_Phrase_Words, Phrase_Questions_LL),
  write('PHRASE = '),
  writeln(Phrase_Questions_LL),
  
  %((Root_Morpheme = verb) -> append([Root_Morpheme], [[List_Question_Words]], Pro_Word); append([Root_Morpheme], List_Question_Words, Pro_Word)),
  %append([vp], List_Phrase_Questions, Phrase_Question_LL),
  
  sr_parse([Phrase_Questions_LL|Stack], Words, [], QANS)
  )
  ;
  sr_parse(Stack, Words, List_Phrase_Words, QANS)
  ).

% Reduce
%sr_parse([Y, X|Rest], [], _):-
%  Z ==> (X, Y),
%  writeln(Z),
%  sr_parse([Z|Rest], [], _).


check_if_locative([], _).
check_if_locative([X|Rest], R):-
   (((X == loc,!); (X == abl,!); (X == dat)) -> R = locative_morpheme; true),
   check_if_locative(Rest, R).

generate_interrogative([], _, []).

generate_interrogative([W|Rest_words], Morphemes, [Output_Word|Generated_words]):-
   Morphemes_ = Morphemes,
   generate_word(W, Morphemes_, Output_Word),
   generate_interrogative(Rest_words, Morphemes, Generated_words).


generate_interrogative2([], _, []).

generate_interrogative2([W|Rest_words], Morpheme, [Output_Word|Generated_words]):-

   (
   ((W==hangi, !); W==hangiler) -> append([thirdposs], [Morpheme], Morpheme_); Morpheme_ = [Morpheme]
   ),
   generate_word(W, Morpheme_, Output_Word),
   generate_interrogative2(Rest_words, Morpheme, Generated_words).

generate_interrogative3([], []).

generate_interrogative3([W|Rest_words], [Output_Word|Generated_words]):-

   (
   ((W==hangi, !); W==hangiler) -> Morpheme_ = [thirdposs]; Morpheme_ = []
   ),
   generate_word(W, Morpheme_, Output_Word),
   generate_interrogative3(Rest_words, Generated_words).

generate_phrase_questions([], []).

generate_phrase_questions([X|Rest], Final_Q_LL):-
    cartesian_type_1(X, Rest, Output_Q_LL),
    generate_phrase_questions(Rest, Generated_Qs),
    append(Output_Q_LL, Generated_Qs, Final_Q_LL).
    
cartesian_type_1(L, [], LL):-
    make_list_all_elements(L, LL).

cartesian_type_1(X, [[F|_]|Rest], Gen_Outputs):-
    car(X, [F], Output),
    cartesian_append(Output, Rest, Gen_Outputs).

cartesian_append(Final_List, [], Final_List).

cartesian_append(X, [[Y|_]|Rest], Output):-
    append_all(X, [Y], Appended_list),
    cartesian_append(Appended_list, Rest, Output).

append_all([], _, []).

append_all([X_LL|Rest], Y_L, [O_LL|Outputs]):- %
    append(X_LL, Y_L, O_LL),
    append_all(Rest, Y_L, Outputs).

make_list_all_elements([], []).

make_list_all_elements([X|Rest], [[X]|LL]):-
     make_list_all_elements(Rest, LL).


generate_questions([], []).

generate_questions([X,Y|Qs], List_Out2):-
    car(X, Y, List_Out1),
    generate_questions2(List_Out1, Qs, List_Out2).
    
generate_questions2(Questions, [], Questions).

generate_questions2(List_Out1, [X|Qs], List_Out2) :-
    car3(List_Out1, X, List_Out3),
    generate_questions2(List_Out3, Qs, List_Out2).


car([], _, []).

car([X|Qs], List, List_Out):-
    car2(X, List, List_Out1),
    car(Qs, List, List_Out2),
    append(List_Out1,List_Out2,List_Out).

car2(_, [], []).

car2(X, [Y|Ys], [[X,Y]|Rest]):-
   car2(X, Ys, Rest).
   
car3([], _, []).

car3([X|Qs], List, List_Out):-
    car4(X, List, List_Out1),
    car3(Qs, List, List_Out2),
    append(List_Out1,List_Out2,List_Out).


car4(_, [], []).

car4(X, [Y|Ys], [O|Rest]):-
   append(X, [Y], O),
   car4(X, Ys, Rest).

cartesian_product_of_LLL([X|Rest], X):- Rest=[],!.
cartesian_product_of_LLL([X,Y|Rest], Output_LL_2):-
   cartesian_LLxLL(X, Y, Output_LL),
   cartesian_LLxLLL(Output_LL, Rest, Output_LL_2).

cartesian_LLxLLL(Final_LL, [], Final_LL).

cartesian_LLxLLL(X_LL, [Y_LL|Rest], Final_LL):-
   cartesian_LLxLL(X_LL, Y_LL, Output_LL),
   cartesian_LLxLLL(Output_LL, Rest, Final_LL).

cartesian_LLxLL(_, [], []).
cartesian_LLxLL(X_LL, [Y_L|Rest], Output_LL):-
    append_all(X_LL, Y_L, A_Output_LL),
    cartesian_LLxLL(X_LL, Rest, Outputs),
    append(A_Output_LL, Outputs, Output_LL).

write_list_lines([]).
write_list_lines([X|Rest]):-
   writeln(X),
   write_list_lines(Rest).



