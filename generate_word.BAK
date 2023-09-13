

generate_word(Input_Word, Suffix_List, Output_Word):-
    generate_word(Input_Word, Input_Word, Suffix_List, Output_Word).

generate_word(Output_Word, _, [], Output_Word).

generate_word(Gen_Word, Input_Word, [Morpheme|Rest], Output_Word):-
    allomorph(X, Morpheme),
    concat(Gen_Word, X, Word),
    parse(Word, _, [Input_Word|_]),
    generate_word(Word, Input_Word, Rest, Output_Word),
    !.
