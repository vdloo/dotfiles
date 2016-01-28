#!/usr/bin/env python
import random, string

random_digits = map(lambda _ : random.randint(0, 10), range(0, 10))


def partition(seq, low, high):
    pivot = seq[low]
    left = low + 1

    while True:
        while left <= high and seq[left] <= pivot:
            left = left + 1

        while seq[high] >= pivot and high >= left:
            high = high - 1

        if high < left:
            break
        else:
            seq[high], seq[left] = seq[left], seq[high]
    seq[high], seq[low] = seq[low], seq[high]

    return high


def quicksort_loop(seq, low, high):
    if low < high:
        part = partition(seq, low, high)
        quicksort_loop(seq, low, part - 1)
        quicksort_loop(seq, part + 1, high)
    return seq


def quicksort(seq):
    return quicksort_loop(seq, 0, len(seq) - 1)

print quicksort(random_digits)
