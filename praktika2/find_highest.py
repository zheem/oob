def find_highest(arr: list):
    unique = set(map(lambda x : x[0], arr))
    rv = sorted([max(filter(lambda x : i in x, arr)) for i in unique])
    return [(i,len(i)) for i in rv]
print(find_highest(["a","aa","aaaaa","b","bbb","bbbbbbbb"]))
print(find_highest(["a","aaaaaaaaa","c","ccc","cccc","aaaaa","b","bbb","bbbbbbbb"]))
print(find_highest(["c","ccc","cccc","ccccc","aaaaa","b","bbb","bbbbbbbb"]))