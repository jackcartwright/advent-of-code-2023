const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const puzzle_input = @embedFile("day-01");

    const part1_output: usize = try part1(puzzle_input);
    const part2_output: usize = part2(puzzle_input);

    try stdout.print("Part 1 Answer: {d}\n", .{part1_output});
    try stdout.print("Part 2 Answer: {d}\n", .{part2_output});
}

fn part1(input: []const u8) !usize {
    var lines = std.mem.splitScalar(u8, input, '\n');
    var accumulator: usize = 0;

    while (lines.next()) |line| {
        var is_first = true;
        var first: u8 = 0;
        var last: u8 = 0;
        for (line) |char| {
            if (std.ascii.isDigit(char) and is_first) {
                first = try std.fmt.charToDigit(char, 10);
                last = first;
                is_first = false;
            } else if (std.ascii.isDigit(char)) {
                last = try std.fmt.charToDigit(char, 10);
            }
        }
        accumulator += first * 10 + last;
    }

    return accumulator;
}

fn part2WordToNum(input: []const u8) u8 {
    if (std.mem.startsWith(u8, input, "one")) {
        return 1;
    } else if (std.mem.startsWith(u8, input, "two")) {
        return 2;
    } else if (std.mem.startsWith(u8, input, "three")) {
        return 3;
    } else if (std.mem.startsWith(u8, input, "four")) {
        return 4;
    } else if (std.mem.startsWith(u8, input, "five")) {
        return 5;
    } else if (std.mem.startsWith(u8, input, "six")) {
        return 6;
    } else if (std.mem.startsWith(u8, input, "seven")) {
        return 7;
    } else if (std.mem.startsWith(u8, input, "eight")) {
        return 8;
    } else if (std.mem.startsWith(u8, input, "nine")) {
        return 9;
    } else {
        return std.fmt.charToDigit(input[0], 10) catch 10;
    }
}

fn part2(input: []const u8) usize {
    var lines = std.mem.splitScalar(u8, input, '\n');
    var accumulator: usize = 0;

    while (lines.next()) |line| {
        var is_first = true;
        var first: u8 = 0;
        var last: u8 = 0;
        for (line, 0..) |_, i| {
            var num: u8 = part2WordToNum(line[i..line.len]);
            if (num != 10 and is_first) {
                first = num;
                last = first;
                is_first = false;
            } else if (num != 10) {
                last = num;
            }
        }
        accumulator += first * 10 + last;
    }

    return accumulator;
}

test "Part 1 Example" {
    const example_input =
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
    ;
    try std.testing.expect(try part1(example_input) == 142);
}

test "Part 2 Example" {
    const example_input =
        \\two1nine
        \\eightwothree
        \\abcone2threexyz
        \\xtwone3four
        \\4nineeightseven2
        \\zoneight234
        \\7pqrstsixteen
    ;
    try std.testing.expect(part2(example_input) == 281);
}
