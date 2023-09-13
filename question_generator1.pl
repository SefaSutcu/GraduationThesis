
generate_questions([X], Result) :-
   cartesian_product1([[]], X, Result).
   
generate_questions([X | Rest], Result) :-
   generate_questions(Rest, R),
   cartesian_product1(R, X, Result).


cartesian_product1([], _, []).

cartesian_product1([X | Xs], Y, Result) :-
   cartesian_product2(X, Y, R2),
   cartesian_product1(Xs, Y, R1),
   append(R2, R1, Result).
   
cartesian_product2(_, [], []).

cartesian_product2(X, [Y | Ys], [List | Rest]) :-
   append([Y], X, List),
   cartesian_product2(X, Ys, Rest).

generate_q_lists([noun],
                 [kim, ne, hangisi, kimler, hangileri, neler]).

generate_q_lists([noun, acc],
                 [kimi, neyi, hangisini, kimleri, hangilerini, neleri]).

generate_q_lists([noun, abl],
                 [kimden, neden, hangisinden, kimlerden, hangilerinden, nelerden]).
     
generate_q_lists([noun, loc],
                 [kimde, nede, neyde, hangisinde, kimlerde, hangilerinde, nelerde]).
     
generate_q_lists([noun, loc, rel],
                 [kimdeki, nedeki, neydeki, hangisindeki, kimlerdeki, hangilerindeki, nelerdeki]).
     
generate_q_lists([noun, inst],
                 [kiminle, kimle, neyle, hangisiyle, kimlerle, hangileriyle, nelerle]).
     
generate_q_lists([noun, poss],
                 [ne, neler]).

generate_q_lists([verb, tDefPast],
                 ['ne yaptı']).
     
generate_q_lists([verb, tAor],
                 ['ne yapar']).
     
generate_q_lists([verb, tProg],
                 ['ne yapıyor']).
     
generate_q_lists([verb, tProg],
                 ['ne yapmakta']).
     
generate_q_lists([verb, tProg],
                 ['ne yapmaktadır']).
