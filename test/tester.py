# -*- coding: utf-8 -*-

from pyswip import Prolog

prolog = Prolog()
prolog.consult("../morph_analyzer.pl") 

total_test = 0
true_test = 0
false_test = 0
false_tests_false = []
false_tests_true = []

with open ('test_words.txt', encoding='utf-8') as f:
    lines = f.readlines()
    len_list = len(lines)
    for i in range(len_list):
        line_list = lines[i].split(';')
        word = line_list[0]
        answer_string = line_list[1][1:]

        y = list(prolog.query(f'parse({word.lower()},X,_)'))
        leny = len(y)
        total_test += 1
        if (leny==0):
            if (answer_string == 'false\n'):
                true_test += 1
            else:
                false_test += 1
                false_test_s = f"{word}=>found answer = false, true answer = {answer_string}"
                false_tests_false.append(false_test_s)
            continue
        found_answers = []
        answer_list = []
        if (answer_string != 'false\n' and answer_string != 'false???\n' and answer_string != 'false'):
            for i in answer_string.split(','):
                answer_list.append(i.split("'")[1])
        flag = 1
        for j in range(leny):
            #print(f"{i} = {y[j]['X']}, {word}", end="") 
            found_answers.append(y[j]['X'])
            if (y[j]['X'] == answer_list):
                flag = 0
                true_test += 1
                break
        if (flag):
            false_test += 1
            false_test_s = f"{word}=>found answers = {found_answers}, true answer = {answer_string}"
            false_tests_true.append(false_test_s)

for i in false_tests_true:
    print(i)
for i in false_tests_false:
    print(i)
print(f"total number of test = {total_test}")
print(f"number of true test = {true_test}")
print(f"number of false test = {false_test}")




