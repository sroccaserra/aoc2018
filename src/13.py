import fileinput


DIRECTIONS = ['^', '>', 'v', '<']
TURNS = {'/': {'^': '>', '>': '^', 'v': '<', '<': 'v'}, '\\': {'^': '<', '>': 'v', 'v': '>', '<': '^'}}
FIXES = {'^': '|', '>': '-', 'v': '|', '<': '-'}
INCREMENTS = {'^': (-1, 0), '>': (0, 1), 'v': (1, 0), '<': (0, -1)}


def solve_1(grid, carts):
    result = 0
    occupied = {(cart.i, cart.j) for cart in carts}
    while True:
        for cart in sorted(carts, key=lambda c: (c.i, c.j)):
            moved_cart = cart.move_on(grid)
            if (moved_cart.i, moved_cart.j) in occupied:
                return (moved_cart.j, moved_cart.i)
            occupied.remove((cart.i, cart.j))
            cart.become(moved_cart)
            occupied.add((cart.i, cart.j))


class Cart:
    def __init__(self, i, j, direction, state = 0):
        self.i = i
        self.j = j
        self.direction = direction
        self.state = state

    def __repr__(self):
        return repr((self.i, self.j, self.direction, self.state))

    def move_on(self, grid):
        (di, dj) = INCREMENTS[self.direction]
        (i, j) = (self.i+di, self.j+dj)
        target_c = grid[i][j]

        state = self.state
        if target_c in TURNS:
            direction = TURNS[target_c][self.direction]
        elif target_c == '+':
            dir_index = DIRECTIONS.index(self.direction)
            if state == 0:
                dir_index = (dir_index - 1) % 4
            elif state == 2:
                dir_index = (dir_index + 1) % 4
            direction = DIRECTIONS[dir_index]
            state = (self.state+1) % 3
        else:
            direction = self.direction
        return Cart(i, j, direction, state)

    def become(self, other):
        self.i = other.i
        self.j = other.j
        self.direction = other.direction
        self.state = other.state


grid = [list(line) for line in fileinput.input()]
carts = []
for i in range(len(grid)):
    row = grid[i]
    for j in range(len(row)):
        c = row[j]
        if c in {'^', '>', 'v', '<'}:
            carts.append(Cart(i, j, c))
            row[j] = FIXES[c]


print(solve_1(grid, carts))
