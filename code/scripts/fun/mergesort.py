#!/usr/bin/env python


def merge(seq1, seq2):
    out = []
    while seq1 and seq2:
        if seq1[0] < seq2[0]:
            out.append(seq1.pop(0))
        else:
            out.append(seq2.pop(0))
        if not seq1:
            out.extend(seq2)
        if not seq2:
            out.extend(seq1)
    return out


def merge_sort(seq):
    if len(seq) > 1:
        p = int(len(seq) / 2)
        left = seq[:p]
        right = seq[p:]
        return merge(merge_sort(left), merge_sort(right))
    else:
        return seq

print merge_sort([1, 4, 2, 3, 4, 1, 9, 4])
