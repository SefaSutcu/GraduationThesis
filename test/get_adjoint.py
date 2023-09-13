adjs = []
with open ('zarf.txt', encoding='utf-8') as f:
    lines = f.readlines()
    ct=0
    for i in range(len(lines)):
        if lines[i]=='\n':break
        if lines[i].find(' ')<0:
            print(lines[i])
            adj = 'allomorph(' + lines[i].split("\n")[0].lower() + ', adverb).\n'
            ct+=1
            adjs.append(adj)
        # if i==3:break
    print(ct)

f = open("adverbs.pl", "a", encoding='utf-8')
for i in range(len(adjs)):
    f.write(adjs[i])
f.close()