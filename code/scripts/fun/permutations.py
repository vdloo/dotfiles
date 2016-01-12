#!/usr/bin/env python

def copy_append(seq, item):
    new_list = seq + [item]
    return new_list

def copy_extend(seq, item):
    new_list = list(seq)
    new_list.extend(item)
    return new_list

def copy_remove(seq, item):
    new_list = list(seq)
    new_list.remove(item)
    return new_list

def flatten_while(seq, proc):
    return reduce(lambda p, n: copy_extend(p, flatten_while(n, proc) if proc(n) else n), seq, list())

def permutations_iter(seq, prev=list()):
    if seq:
        return map(lambda x: permutations_iter(copy_remove(seq, x), prev=copy_append(prev, x)), seq)
    else:
        return prev

def permutations(seq):
    return flatten_while(permutations_iter(seq), lambda x: isinstance(x[0][0], list))

print permutations([1, 2])
print permutations([1, 2, 2])
