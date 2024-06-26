const std = @import("std");

const scores = std.ComptimeStringMap(u32, .{
    .{ "A X", 1 + 3 },
    .{ "A Y", 2 + 6 },
    .{ "A Z", 3 + 0 },
    .{ "B X", 1 + 0 },
    .{ "B Y", 2 + 3 },
    .{ "B Z", 3 + 6 },
    .{ "C X", 1 + 6 },
    .{ "C Y", 2 + 0 },
    .{ "C Z", 3 + 3 },
});

pub fn main() !void {
    const result = try solution(@embedFile("input.txt"));
    std.log.info("Part1: {}", .{result});

    const result2 = try solution2(@embedFile("input.txt"));
    std.log.info("Part2: {}", .{result2});
}

fn solution(input: []const u8) !u32 {
    var lines = std.mem.split(u8, input, "\n");

    var score: u32 = 0;

    while (lines.next()) |line| {
        score += scores.get(line) orelse 0;
    }

    return score;
}

const scores2 = std.ComptimeStringMap(u32, .{
    .{ "A X", 3 + 0 },
    .{ "A Y", 1 + 3 },
    .{ "A Z", 2 + 6 },
    .{ "B X", 1 + 0 },
    .{ "B Y", 2 + 3 },
    .{ "B Z", 3 + 6 },
    .{ "C X", 2 + 0 },
    .{ "C Y", 3 + 3 },
    .{ "C Z", 1 + 6 },
});

fn solution2(input: []const u8) !u32 {
    var lines = std.mem.split(u8, input, "\n");

    var score: u32 = 0;

    while (lines.next()) |line| {
        score += scores2.get(line) orelse 0;
    }

    return score;
}

test "solution1" {
    const want = 15;
    const got = try solution(@embedFile("input_test.txt"));
    std.testing.expect(want == got) catch |err| {
        std.log.err("Want {}, got {}", .{ want, got });
        return err;
    };
}

test "solution2" {
    const want = 12;
    const got = try solution2(@embedFile("input_test.txt"));
    std.testing.expect(want == got) catch |err| {
        std.log.err("Want {}, got {}", .{ want, got });
        return err;
    };
}
