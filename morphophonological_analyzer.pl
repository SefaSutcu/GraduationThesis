:- include('C:/Users/ABRA/Desktop/MorphoPhonological/weak_vowel_harmonizer.pl').

initial(qv0).
final(qv1).
final(qv2).
final(qv3a).
final(qv3b).
final(qv3c).
final(qv3d).
final(qv4a).
final(qv4b).
final(qv5).

t(qv0,verb,qv1).

t(qv1,tDefPast,qv3a).
t(qv1,tInDefPast,qv3b).
t(qv1,tProg,qv3b).
t(qv1,tAor,qv3b).
t(qv1,tFut,qv3b).
t(qv1,tNec,qv3b).
t(qv1,tCon,qv3c).
t(qv1,tOpt,qv3d).
t(qv1,neg,qv2).

t(qv2,tDefPast,qv3a).
t(qv2,tInDefPast,qv3b).
t(qv2,tProg,qv3b).
t(qv2,tAor,qv3b).
t(qv2,tFut,qv3b).
t(qv2,tNec,qv3b).
t(qv2,tCon,qv3c).
t(qv2,tOpt,qv3d).

t(qv3a,aCon,qv4a).
t(qv3a,aDefPast,qv4a).
t(qv3a,pDefInd�c,qv5).

t(qv3b,pInd�c,qv5).
t(qv3b,aDefPast,qv4a).
t(qv3b,aInDefPast,qv4b).
t(qv3b,aCon,qv4a).

t(qv3c,aDefPast,qv4a).
t(qv3c,aInDefPast,qv4b).
t(qv3c,pDefInd�c,qv5).

t(qv3d,aDefPast,qv4a).
t(qv3d,aInDefPast,qv4b).

t(qv4a,pDefInd�c,qv5).

t(qv4b,pInd�c,qv5).

allomorph(git,verb).
allomorph(bul,verb).
allomorph(g�r,verb).
allomorph(otur,verb).
allomorph(ol,verb).

allomorph(ma,neg).
allomorph(me,neg).
allomorph(m�,neg).
allomorph(mi,neg).
allomorph(mu,neg).
allomorph(m�,neg).

allomorph(d�,tDefPast).
allomorph(di,tDefPast).
allomorph(t�,tDefPast).
allomorph(ti,tDefPast).
allomorph(du,tDefPast).
allomorph(d�,tDefPast).
allomorph(tu,tDefPast).
allomorph(t�,tDefPast).

allomorph(m��,tInDefPast).
allomorph(mi�,tInDefPast).
allomorph(mu�,tInDefPast).
allomorph(m��,tInDefPast).

allomorph(yor,tProg).
allomorph(�yor,tProg).
allomorph(iyor,tProg).
allomorph(uyor,tProg).
allomorph(�yor,tProg).

allomorph(ecek,tFut).
allomorph(acak,tFut).

allomorph(�r,tAor).
allomorph(ir,tAor).
allomorph(ur,tAor).
allomorph(�r,tAor).
allomorph(ar,tAor).
allomorph(er,tAor).

allomorph(meli,tNec).
allomorph(mal�,tNec).

allomorph(se,tCon).
allomorph(sa,tCon).

allomorph(e,tOpt).
allomorph(a,tOpt).

allomorph(se,aCon).
allomorph(sa,aCon).

allomorph(d�,aDefPast).
allomorph(di,aDefPast).
allomorph(t�,aDefPast).
allomorph(ti,aDefPast).
allomorph(du,aDefPast).
allomorph(d�,aDefPast).
allomorph(tu,aDefPast).
allomorph(t�,aDefPast).

allomorph(m��,aInDefPast).
allomorph(mi�,aInDefPast).
allomorph(mu�,aInDefPast).
allomorph(m��,aInDefPast).

allomorph(�m,pInd�c).
allomorph(im,pInd�c).
allomorph(um,pInd�c).
allomorph(�m,pInd�c).
allomorph(s�n,pInd�c).
allomorph(sin,pInd�c).
allomorph(sun,pInd�c).
allomorph(s�n,pInd�c).
allomorph(�z,pInd�c).
allomorph(iz,pInd�c).
allomorph(uz,pInd�c).
allomorph(�z,pInd�c).
allomorph(s�n�z,pInd�c).
allomorph(siniz,pInd�c).
allomorph(sunuz,pInd�c).
allomorph(s�n�z,pInd�c).
allomorph(ler,pInd�c).
allomorph(lar,pInd�c).

allomorph(m,pDefInd�c).
allomorph(n,pDefInd�c).
allomorph(k,pDefInd�c).
allomorph(n�z,pDefInd�c).
allomorph(niz,pDefInd�c).
allomorph(nuz,pDefInd�c).
allomorph(n�z,pDefInd�c).
allomorph(ler,pDefInd�c).
allomorph(lar,pDefInd�c).

analyze(String, List_of_Allomorph):-
   initial(State),
   analyze(String, State, List_of_Allomorph, []).

analyze('', State, [], _):- final(State).

analyze(String, CurrentState, [Prefix|Rest_Allomorphs], Prev_Allomorph):-
   concat(Prefix, Suffix, String),
   allomorph(Prefix, Morpheme),
   t(CurrentState, Morpheme, NextState),
   append(Prev_Allomorph, [Prefix], Allomorphs),
   ((Morpheme == 'tProg') -> progHarmonize(Allomorphs); harmonize(Allomorphs)),
   analyze(Suffix, NextState, Rest_Allomorphs, [Prefix]).

progHarmonize([Allomorph1, Allomorph2]):-
   string_to_list(Allomorph1, LCodes),
   string_to_list(Allomorph2, RCodes),
   vowel_vowel_progHarmony(LCodes, RCodes),
   consonant_consonant_harmony(LCodes, RCodes),
   vowel_consonant_harmony(LCodes, RCodes),
   consonant_vowel_harmony(LCodes, RCodes).

vowel_vowel_progHarmony(LCodes, [RCode1, RCode2|_]):-
   reverse(LCodes, [LCode1|_]),
   char_code(LChar1, LCode1),
   char_code(RChar1, RCode1),
   char_code(RChar2, RCode2),
   vowel(LChar1),
   consonant(RChar1),
   vowel(RChar2),
   (LChar1 = �; LChar1 = i; LChar1 = u; LChar1 = �).

vowel_vowel_progHarmony(LCodes, [RCode1|_]):-
   reverse(LCodes, [LCode1,LCode2|_]),
   char_code(LChar1, LCode1),
   char_code(LChar2, LCode2),
   char_code(RChar1, RCode1),
   consonant(LChar1),
   vowel(LChar2),
   vowel(RChar1),
   (((LChar2 = a; LChar2 = �), (RChar1 = a; RChar1 = �));
   ((LChar2 = o; LChar2 = u), (RChar1 = a; RChar1 = u));
   ((LChar2 = e; LChar2 = i), (RChar1 = e; RChar1 = i));
   ((LChar2 = �; LChar2 = �), (RChar1 = e; RChar1 = �))
   ).
   

harmonize([_]).

harmonize([Allomorph1, Allomorph2]):-
   string_to_list(Allomorph1, LCodes),
   string_to_list(Allomorph2, RCodes),
   vowel_vowel_harmony(LCodes, RCodes),
   consonant_consonant_harmony(LCodes, RCodes),
   vowel_consonant_harmony(LCodes, RCodes),
   consonant_vowel_harmony(LCodes, RCodes).

vowel_vowel_harmony(_, [RCode1|_]):-
   char_code(RChar1, RCode1),
   consonant(RChar1).

vowel_vowel_harmony(LCodes, [RCode1, RCode2|_]):-
   reverse(LCodes, [LCode1|_]),
   char_code(LChar1, LCode1),
   char_code(RChar1, RCode1),
   char_code(RChar2, RCode2),
   vowel(LChar1),
   consonant(RChar1),
   vowel(RChar2),
  (((LChar1 = a; LChar1 = �), (RChar2 = a; RChar2 = �));
   ((LChar1 = o; LChar1 = u), (RChar2 = a; RChar2 = u));
   ((LChar1 = e; LChar1 = i), (RChar2 = e; RChar2 = i));
   ((LChar1 = �; LChar1 = �), (RChar2 = e; RChar2 = �))
   ).
   
vowel_vowel_harmony(LCodes, [RCode1, RCode2|_]):-
   reverse(LCodes, [LCode1, LCode2|_]),
   char_code(LChar1, LCode1),
   char_code(LChar2, LCode2),
   char_code(RChar1, RCode1),
   char_code(RChar2, RCode2),
   consonant(LChar1),
   vowel(LChar2),
   consonant(RChar1),
   vowel(RChar2),
  (((LChar2 = a; LChar2 = �), (RChar2 = a; RChar2 = �));
   ((LChar2 = o; LChar2 = u), (RChar2 = a; RChar2 = u));
   ((LChar2 = e; LChar2 = i), (RChar2 = e; RChar2 = i));
   ((LChar2 = �; LChar2 = �), (RChar2 = e; RChar2 = �))
   ).
   
vowel_vowel_harmony(LCodes, [RCode1, RCode2|_]):-
   reverse(LCodes, [LCode1, LCode2, LCode3|_]),
   char_code(LChar1, LCode1),
   char_code(LChar2, LCode2),
   char_code(LChar3, LCode3),
   char_code(RChar1, RCode1),
   char_code(RChar2, RCode2),
   consonant(LChar1),
   consonant(LChar2),
   vowel(LChar3),
   consonant(RChar1),
   vowel(RChar2),
  (((LChar3 = a; LChar3 = �), (RChar2 = a; RChar2 = �));
   ((LChar3 = o; LChar3 = u), (RChar2 = a; RChar2 = u));
   ((LChar3 = e; LChar3 = i), (RChar2 = e; RChar2 = i));
   ((LChar3 = �; LChar3 = �), (RChar2 = e; RChar2 = �))
   ).
   
vowel_vowel_harmony(LCodes, [RCode1|_]):-
   reverse(LCodes, [LCode1, LCode2|_]),
   char_code(LChar1, LCode1),
   char_code(LChar2, LCode2),
   char_code(RChar1, RCode1),
   consonant(LChar1),
   vowel(LChar2),
   vowel(RChar1),
  (((LChar2 = a; LChar2 = �), (RChar1 = a; RChar1 = �));
   ((LChar2 = o; LChar2 = u), (RChar1 = a; RChar1 = u));
   ((LChar2 = e; LChar2 = i), (RChar1 = e; RChar1 = i));
   ((LChar2 = �; LChar2 = �), (RChar1 = e; RChar1 = �))
   ).

consonant_consonant_harmony(LCodes, [RCode1|_]):-
   reverse(LCodes, [LCode1|_]),
   char_code(LChar1, LCode1),
   char_code(RChar1, RCode1),
   ((not(consonant(LChar1)),!); not(consonant(RChar1))).
   
consonant_consonant_harmony(LCodes, [RCode1|_]):-
   reverse(LCodes, [LCode1|_]),
   char_code(LChar1, LCode1),
   char_code(RChar1, RCode1),
   consonant(LChar1),
   consonant(RChar1),
  ((consonant_type1(LChar1), consonant_type1(RChar1));
   (consonant_type1(LChar1), consonant_type2(RChar1));
   (consonant_type2(LChar1), consonant_type3(RChar1));
   (consonant_type2(LChar1), consonant_type2(RChar1));
   (consonant_type3(LChar1), consonant_type2(RChar1));
   (consonant_type3(LChar1), consonant_type3(RChar1))
   ).
   
vowel_consonant_harmony(LCodes, [RCode1|_]):-
   reverse(LCodes, [LCode1|_]),
   char_code(LChar1, LCode1),
   char_code(RChar1, RCode1),
   ((not(vowel(LChar1)),!); not(consonant(RChar1))).
   
vowel_consonant_harmony(LCodes, [RCode1|_]):-
   reverse(LCodes, [LCode1|_]),
   char_code(LChar1, LCode1),
   char_code(RChar1, RCode1),
   vowel(LChar1),
   consonant(RChar1),
   not(RChar1 = t).
   
consonant_vowel_harmony(LCodes, [RCode1|_]):-
   reverse(LCodes, [LCode1|_]),
   char_code(LChar1, LCode1),
   char_code(RChar1, RCode1),
   ((not(consonant(LChar1)),!); not(vowel(RChar1))).
   
consonant_vowel_harmony(LCodes, [RCode1|_]):-
   reverse(LCodes, [LCode1|_]),
   char_code(LChar1, LCode1),
   char_code(RChar1, RCode1),
   consonant(LChar1),
   vowel(RChar1),
   not(LChar1 = p),
   not(LChar1 = �),
   not(LChar1 = t),
   not(LChar1 = k).

consonant_type1(�).
consonant_type1(f).
consonant_type1(h).
consonant_type1(k).
consonant_type1(p).
consonant_type1(s).
consonant_type1(�).
consonant_type1(t).

consonant_type2(l).
consonant_type2(m).
consonant_type2(n).
consonant_type2(r).
consonant_type2(y).

consonant_type3(b).
consonant_type3(c).
consonant_type3(d).
consonant_type3(g).
consonant_type3(�).
consonant_type3(j).
consonant_type3(v).
consonant_type3(z).
   
