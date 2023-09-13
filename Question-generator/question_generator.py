# -*- coding: utf-8 -*-

from pyswip import Prolog
import random

prolog = Prolog()
prolog.consult("../sr_parser_20_12.pl") 
# 'Bu ilk süreç olan Şark Meselesinde temel amaç Türkleri Anadolu’ya sokmamak'
# , '[bu,ilk,süreç,olan,şark,meselesinde,temel,amaç,türkleri,anadoluya,sokmamak]'
sentence_string = ['Şark meselesi temel hatlarıyla iki önemli süreçten oluşmaktadır.', 'Bu tarihler arasında Avrupa, Türklere karşı savunmaya geçmiş,', ]
sentences_list = ['[şark,meselesi,temel,hatlarıyla,iki,önemli,meseleden,oluşmaktadır]', '[bu,tarihler,arasında,avrupa,türklere,karşı,savunmaya,geçmiş]']
context = """Şark meselesi temel hatlarıyla iki önemli süreçten oluşmaktadır. Bunlardan birincisi ’1071-1683’ yılları arasındaki Şark Meselesi’dir . Bu tarihler arasında Avrupa, Türklere karşı savunmaya geçmiş, Türkler ise fetihlere hız kazandırarak akıncılarını Avrupa topraklarına göndermiştir. Bu ilk süreç olan Şark Meselesinde temel amaç Türkleri Anadolu’ya sokmamak, Türklerin Anadolu’daki ilerleyişini durdurmak ve Türklerin Rumeli’ye girişini engellemektir. İstanbul’un Türkler tarafından fethini engellemek isteyen Avrupa devletleri, Türklerin Balkanlar üzerinden Avrupa içlerine doğru ilerleyişine engel olmak için birçok politikalar izlemişler ve bu politikalarda Şark Meselesinin ilk planlı durdurma safhasını oluşturmaktadır."""



sentences_len = len(sentences_list)
qas = []
ct=1
questions_len = 0
for s_ct in range(sentences_len):
    y = list(prolog.query(f'sr_parse({sentences_list[s_ct]},X)'))
    
    
    s = sentences_list[s_ct][1:-1]
    sentence_L = s.split(',')
    questions_len += len(y[0]['X'])
    for i in y[0]['X']:
        f = 0
        for j in i:
            if j not in sentence_L:
                f = 1
                break
        q = ' '.join(i)
        q= q+'?'
        #if not f:
        #    print(i,end="\n")
        if f:
            question_json = {
                "question": q,
                "id":ct,
                "answers":[
                {
                    "answer_start": context.find(sentence_string[s_ct]),
                    "text": sentence_string[s_ct]
                }
                ]
            }
            qas.append(question_json)
            ct+=1
            # print(i,end="\n")
    # print(qas)

import json

random.shuffle(qas)
print(type(questions_len))
print(questions_len)
questions_len_test = questions_len//5
train_qas = qas[questions_len_test:]
test_qas = qas[:questions_len_test]

# Data to be written
dictionary_train = {
    "data": [
        {
            "title":"Şark Meselesi",
            "paragraphs":[
                {
                    "context":context,
                    "qas":train_qas
                }
            ]
        }
    ]
}

dictionary_test = {
    "data": [
        {
            "title":"Şark Meselesi",
            "paragraphs":[
                {
                    "context":context,
                    "qas":test_qas
                }
            ]
        }
    ]
}

# Serializing json
json_train = json.dumps(dictionary_train, indent=4, ensure_ascii=False)
json_test = json.dumps(dictionary_test, indent=4, ensure_ascii=False)
 
# Writing to sample.json
with open("train.json", "w", encoding='utf-8') as outfile:
    outfile.write(json_train)

with open("test.json", "w", encoding='utf-8') as outfile:
    outfile.write(json_test)
