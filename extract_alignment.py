#use/env/python
import sys
import os

def similarity(a, b):
    score = 0
    for i, j in zip(a, b):
        if i == j:
            score += 1
    return score / len(a)

if __name__ == "__main__":
    short = sys.argv[1]
    long = sys.argv[2]
    for i in range(0, len(long)-len(short)+1):
        sub = long[i:i+len(short)]
        simi = similarity(sub, short)
        print(sub, simi, sep="\t")
