words = []
with open ('yenites-.txt', encoding='utf-8') as f:
    lines = f.readlines()
    for i in lines:
        stringl = list(i)
        stringl[i.find(',')] = ';'
        words.append(''.join(stringl))


f = open("test_new.txt", "a", encoding='utf-8')
for i in words:
    f.write(i)
f.close()