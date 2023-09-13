find_last_suffix([], _).

find_last_suffix([X|Rest], O):-
   (
   ((X==acc,!); (X==inst,!); (X==gen); (X == loc,!); (X == abl,!); (X == dat)) -> (var(O) -> O=X;true); true
   ),
   find_last_suffix(Rest, O).
