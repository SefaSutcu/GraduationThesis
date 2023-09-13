answer = "['noun', 'thirdposs', 'loc', 'rel']"


answer_list = []
for i in answer.split(','):
    answer_list.append(i.split("'")[1])
    
answer = 'false'
print(answer_list)





