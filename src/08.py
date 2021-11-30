import sys
import fileinput

from queue import SimpleQueue
from types import SimpleNamespace

def solve_part_one(ns):
    q = SimpleQueue()
    for n in ns:
        q.put(n)
    return walk_tree_1(q)


def solve_part_two(ns):
    q = SimpleQueue()
    for n in ns:
        q.put(n)
    tree = build_tree_2(q)
    return tree.sum


#  2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
#  A----------------------------------
#      B----------- C-----------
#                       D-----


def walk_tree_1(q):
    c = q.get()
    n = q.get()
    s = 0
    for _ in range(c):
        s += walk_tree_1(q)
    for _ in range(n):
        s += q.get()
    return s


def build_tree_2(q):
    tree = SimpleNamespace()
    c = q.get()
    n = q.get()
    tree.c = c
    tree.n = n
    tree.sum = 0
    tree.children = []
    for _ in range(c):
        tree.children.append(build_tree_2(q))
    for i in range(n):
        if c == 0:
            tree.sum += q.get()
        else:
            i = q.get()
            if 0 < i and i <= len(tree.children):
                tree.sum += tree.children[i-1].sum
    return tree


if __name__ == '__main__' and not sys.flags.interactive:
    line = next(fileinput.input())
    ns = [int(s) for s in line.split()]
    print(solve_part_one(ns))
    print(solve_part_two(ns))
