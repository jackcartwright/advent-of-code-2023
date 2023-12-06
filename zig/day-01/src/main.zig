const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const puzzle_input = @embedFile("day-01");

    const output: usize = try part1(puzzle_input);

    try stdout.print("Part 1 Answer: {d}\n", .{output});
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

test "Part 1 Example" {
    const example_input =
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
    ;
    try std.testing.expect(try part1(example_input) == 142);
}
