#!/usr/bin/env python2

# This file contains a function that returns the combinations of the carthesian product of a 
# list with items allowed to be repeated a specified amount of times. So basically it's all
# the possible orders of a list including missing and repeating items.

# Examples: 
# combinations_with_specified_repeat_of_a_powerset(['A', 'B'], 0)
# [['A'], ['B']]

# combinations_with_specified_repeat_of_a_powerset(['A', 'B'], 1)
# [['B'], ['A', 'B'], ['B']]

# combinations_with_specified_repeat_of_a_powerset(['A', 'B'], 2)
# [['B'], ['A', 'B'], ['A', 'A', 'B'], ['B', 'A', 'B'], ['B'], ['B', 'B'], ['A', 'B', 'B']]

# combinations_with_specified_repeat_of_a_powerset(['A', 'B', 'C'], 1)
# [['C'], ['B', 'C'], ['A', 'B', 'C'], ['C'], ['C'], ['B', 'C'], ['C'], ['C'], ['B', 'C'], ['C']]

# A powerset looks like: powerset([1, 2, 3]) -> [[1], [2], [3], [1, 2], [1, 3], [2, 3], [1, 2, 3]]
# A combination looks like: combinations([1, 2]) -> [[1, 2], [2, 1]]

# Because the builtin itertools combinations functions only differentiate between 
# "allowing individual elements to be repeated more than once" using the function 
# itertools.combinations_with_replacement and not allowing repeated elements using 
# itertools.combinations, there is no standard function that can give you all the 
# combinations of a list where repeats are allowed r times.

# This function takes a list s, and for every item in the list create combinations
# including missing and repeat items (until the repeated element is included r times 
# in that combination). Every recursive iteration calls the caller 
# (len(s) - len(<items that aren't allowed to be repeated anymore>)) times.

def combinations_with_specified_repeat_of_a_powerset(s, r, saved=list()):
        saved = saved or [[x] for x in s]
        if not s or r == 0:
            return saved
        combinations = list()
        for item in s:
            new_saved = list()
            new_saved.append([item])
            for combination in saved:
                if r > len(filter(lambda x: x == item, combination)):
                    new_combination = combination + [item]
                    new_saved.append(new_combination)
            out = combinations_with_specified_repeat_of_a_powerset(s[1:], r, saved=new_saved)
            combinations.extend(out)
        return combinations

print combinations_with_specified_repeat_of_a_powerset(['A', 'B'], 0)

print combinations_with_specified_repeat_of_a_powerset(['A', 'B'], 1)

print combinations_with_specified_repeat_of_a_powerset(['A', 'B'], 2)

print combinations_with_specified_repeat_of_a_powerset(['A', 'B', 'C'], 1)
