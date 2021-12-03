import sys
import fileinput


def solve_1(power_levels):
    max_total_level = 0
    corner_x = 0
    corner_y = 0
    m = {}
    for s in range(1, 4):
        print(s, end="\r")
        for y in range(1, 301-s):
            for x in range(1, 301-s):
                level = square_level(m, power_levels, s, x, y)
                if s == 3 and level > max_total_level:
                    max_total_level = level
                    corner_x = x
                    corner_y = y
    return corner_x, corner_y


def solve_2(power_levels):
    """
    1234.
    2234.
    3334.
    4444.
    .....
    """
    max_total_level = 0
    corner_x = 0
    corner_y = 0
    size = 0
    m = {}
    for s in range(1, 301):
        print(s, end="\r")
        for y in range(1, 301-s):
            for x in range(1, 301-s):
                level = square_level(m, power_levels, s, x, y)
                if level > max_total_level:
                    max_total_level = level
                    corner_x = x
                    corner_y = y
                    size = s

    return corner_x, corner_y, size


def square_level(m, power_levels, n, x, y):
    prev = m.get((n-1, x, y))
    if prev is None:
        level = sum(square(power_levels, n, x, y))
        m[(n, x, y)] = level
        return level
    else:
        result = prev + power_levels[y+n-2][x+n-2]
        for i in range(1, n):
            result += power_levels[y+n-2][x+i-2] + power_levels[y+i-2][x+n-2]
        m[(n, x, y)] = result
        return result


def square(power_levels, w, x_1, y_1):
    return [power_levels[y-1][x-1] for x in range(x_1, x_1+w) for y in range(y_1, y_1+w)]


def power_level(sn, x, y):
    rack_id = x + 10
    result = rack_id*y + sn
    result *= rack_id
    result //= 100
    result -= 10*(result//10) + 5
    return result


if __name__ == '__main__' and not sys.flags.interactive:
    sn = int(next(fileinput.input()).strip())
    power_levels = [[power_level(sn, x, y) for x in range(1, 301)] for y in range(1, 301)]
    print(solve_1(power_levels))
    print(solve_2(power_levels))
