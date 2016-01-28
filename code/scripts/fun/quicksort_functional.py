#!/usr/bin/env python
import random, string

random_digits = map(lambda _ : random.randint(0, 10), range(0, 10))


def quicksort(seq):
    if len(seq) > 1:
        left = filter(lambda x: x < seq[0], seq[1:])
        middle = seq[:1]
        right = filter(lambda x: x >= seq[0], seq[1:])
        return quicksort(left) + middle + quicksort(right)
    else:
        return seq

print quicksort(random_digits)
