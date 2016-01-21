#!/usr/bin/env python

def bubblesort(seq):
    if seq:
        for i in range(1, len(seq)):
            j = i - 1
            seq[j], seq[i] = (seq[i], seq[j]) if seq[j] > seq[i] else (seq[j], seq[i])
        previous = bubblesort(seq[:-1]) or []
        previous.append(seq[-1])
        return previous

print bubblesort([5,4,2,1,3])

        
