# -*- coding: utf-8 -*-

from pyswip import Prolog

prolog = Prolog()
prolog.consult("../morph_analyzer.pl") 

total_test = 0
true_test = 0
false_test = 0
false_tests_false = []
false_tests_true = []

write_ = []

with open ('yeni_test.txt', encoding='utf-8') as f:
    lines = f.readlines()
    total_test = len(lines)
    for i in range(total_test):
        word = lines[i].split("\n")[0]

        y = list(prolog.query(f'parse({word.lower()},X,_)'))
        leny = len(y)

        if (leny==0):
            print(f"no answer found for {word}\n")
            write_.append(f"no answer found for {word}\n")
            continue
        
        for j in range(leny):
            print(f"{word}; {y[j]['X']}", end="\n")
            write_.append(f"{word}; {y[j]['X']}\n")
        write_.append("\n")
        print("")

f = open("test_new.txt", "a", encoding='utf-8')
for i in write_:
    f.write(i)
f.close()
