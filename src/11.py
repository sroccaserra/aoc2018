import sys
import fileinput


def solve_1(sn):
    max_total_level = 0
    corner_x = 0
    corner_y = 0
    for y in range(1, 298):
        for x in range(1, 298):
            square_level = sum(square(sn, x, y))
            if square_level > max_total_level:
                max_total_level = square_level
                corner_x = x
                corner_y = y
    return corner_x, corner_y


def square(sn, x_1, y_1):
    w = 3
    h = 3
    return [power_level(sn, x, y) for x in range(x_1, x_1+w) for y in range(y_1, y_1+h)]


def power_level(sn, x, y):
    rack_id = x + 10
    result = rack_id*y + sn
    result *= rack_id
    result //= 100
    result -= 10*(result//10) + 5
    return result


if __name__ == '__main__' and not sys.flags.interactive:
    sn = int(next(fileinput.input()).strip())
    print(solve_1(sn))
