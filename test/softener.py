# -*- coding: utf-8 -*-

def vowel(x):
    if (x in 'aeiıuüoö'):
        return True
    return False

def sert(x):
    if (x=='p'):
        return 'b'
    elif (x=='ç'):
        return 'c'
    elif (x=='t'):
        return 'd'
    elif (x=='k'):
        return 'ğ'
    
    return 'x'

istisna_list = []

with open('../allomorphs.pl', encoding='utf-8') as f:
    lines = f.readlines()
    for x in lines:
        y = x[11:].split("'")
        word = y[0]
        try:
            if ('noun' == y[1][1:5]):
                last_char = word[-1]
                soft_char = sert(last_char)
                if (soft_char != 'x' and len(word)>3):
                    nt = (word[:len(word)-1] + soft_char, 'noun', last_char)
                    istisna_list.append(nt)
            if ('verb' == y[1][1:5]):
                if (word[-1] in 'aeoö'):
                    lenw = len(word)
                    for i in range(lenw-1):
                        j=lenw-i-2
                        vw = word[j]
                        if (vowel(vw)):
                            replace_vowel = vw
                            if (vw == 'a'):
                                replace_vowel ='ı'
                            elif (vw == 'e'):
                                replace_vowel ='i'
                            elif (vw == 'o'):    
                                replace_vowel ='u'
                            elif (vw == 'ö'):    
                                replace_vowel ='ü'
                            nt = (word[:lenw-1] + replace_vowel, 'verb', word[-1])
                            istisna_list.append(nt)
                            break
                    else:
                        print('Wrong Word ', end='')
                        print(word+'????????')
        except:
            print('EXCEPTION ', end='')
            print(y)
print('xxxxxxxxxxxxxxxxxxxxxxxxxxx',end='\n')
# print(istisna_list)



f = open("soft_allomorphs.pl", "a", encoding='utf-8')
for i in range(len(istisna_list)):
    f.write(f"\nallomorph('{istisna_list[i][0]}',soft{istisna_list[i][1]}).")
f.close()