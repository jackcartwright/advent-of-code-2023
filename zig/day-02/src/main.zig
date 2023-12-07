const std = @import("std");

const max_red = 12;
const max_green = 13;
const max_blue = 14;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const puzzle_input = @embedFile("day-02");

    const part1_output: usize = try part1(puzzle_input);
    const part2_output: usize = try part2(puzzle_input);

    try stdout.print("Part 1 Answer: {d}\n", .{part1_output});
    try stdout.print("Part 2 Answer: {d}\n", .{part2_output});
}

fn part1(input: []const u8) !usize {
    var accumulator: usize = 0;

    var lines = std.mem.splitScalar(u8, input, '\n');

    while (lines.next()) |line| {
        const colon_index: usize = std.mem.indexOfScalar(u8, line, ':') orelse continue;
        const game_num = try std.fmt.parseInt(usize, line[5..colon_index], 10);
        var rounds = std.mem.splitSequence(u8, line[colon_index + 2 .. line.len], "; ");

        const result = game: while (rounds.next()) |round| {
            var color_counts = std.mem.splitSequence(u8, round, ", ");
            while (color_counts.next()) |color_count| {
                const space_index = std.mem.indexOfScalar(u8, color_count, ' ') orelse continue;
                const count = try std.fmt.parseInt(usize, color_count[0..space_index], 10);
                if (std.mem.endsWith(u8, color_count, "red") and count > max_red) {
                    break :game false;
                } else if (std.mem.endsWith(u8, color_count, "green") and count > max_green) {
                    break :game false;
                } else if (std.mem.endsWith(u8, color_count, "blue") and count > max_blue) {
                    break :game false;
                }
            }
        } else true;

        if (result) {
            accumulator += game_num;
        }
    }

    return accumulator;
}

fn part2(input: []const u8) !usize {
    var accumulator: usize = 0;

    var lines = std.mem.splitScalar(u8, input, '\n');

    while (lines.next()) |line| {
        var min_red: usize = 0;
        var min_green: usize = 0;
        var min_blue: usize = 0;

        const colon_index: usize = std.mem.indexOfScalar(u8, line, ':') orelse continue;
        var rounds = std.mem.splitSequence(u8, line[colon_index + 2 .. line.len], "; ");

        while (rounds.next()) |round| {
            var color_counts = std.mem.splitSequence(u8, round, ", ");
            while (color_counts.next()) |color_count| {
                const space_index = std.mem.indexOfScalar(u8, color_count, ' ') orelse continue;
                const count = try std.fmt.parseInt(usize, color_count[0..space_index], 10);
                if (std.mem.endsWith(u8, color_count, "red") and count > min_red) {
                    min_red = count;
                } else if (std.mem.endsWith(u8, color_count, "green") and count > min_green) {
                    min_green = count;
                } else if (std.mem.endsWith(u8, color_count, "blue") and count > min_blue) {
                    min_blue = count;
                }
            }
        }

        accumulator += min_red * min_green * min_blue;
    }

    return accumulator;
}

test "Part 1 Example" {
    const example_input =
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ;
    try std.testing.expect(try part1(example_input) == 8);
}

test "Part 2 Example" {
    const example_input =
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ;
    try std.testing.expect(try part2(example_input) == 2286);
}
