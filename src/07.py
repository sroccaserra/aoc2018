import fileinput
import sys
from collections import defaultdict


def solve(lines):
    scheduler = Scheduler(lines)
    while len(scheduler.options()) > 0:
        scheduler.step()
    return scheduler.path


class Scheduler:
    def __init__(self, lines):
        deps = [(line[5], line[36]) for line in lines]
        self.chars = set([d[0] for d in deps] + [d[1] for d in deps])
        self.m = defaultdict(set)
        for dep in deps:
            self.m[dep[1]].add(dep[0])
        self.path = ''

    def options(self):
        return [c for c in self.chars if len(self.m[c]) == 0]

    def choose(self):
        possible_values = self.options()
        if len(possible_values) == 0:
            return None
        return sorted(self.options())[0]

    def step(self):
        choice = self.choose()
        self.path += choice
        self.chars.remove(choice)
        for c in self.chars:
            for k, v in self.m.items():
                self.m[k].discard(choice)
        return self

    def __str__(self):
        return f'Schedule(path: {repr(self.path)}, map: {self.m}, chars: {self.chars})'


if __name__ == '__main__' and not sys.flags.interactive:
    lines = [line.strip() for line in fileinput.input()]
    print(solve(lines))
