import sys
import fileinput

from queue import SimpleQueue
from types import SimpleNamespace

s = 0

def solve(ns):
    q = SimpleQueue()
    for n in ns:
        q.put(n)
    tree = makeTree(q)
    return tree, s


#  2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
#  A----------------------------------
#      B----------- C-----------
#                       D-----

def makeTree(q):
    tree = SimpleNamespace()
    c = q.get()
    n = q.get()
    tree.c = c
    tree.n = n
    tree.children = []
    tree.sum = 0
    global s
    for _ in range(c):
        tree.children.append(makeTree(q))
    for _ in range(n):
        tree.sum += q.get()
    s += tree.sum
    return tree


if __name__ == '__main__' and not sys.flags.interactive:
    line = next(fileinput.input())
    ns = [int(s) for s in line.split()]
    print(solve(ns))
