const std = @import("std");

pub fn main() !void {
    const result = try solution(@embedFile("input.txt"));
    std.log.info("Part1: {}", .{result});

    const result2 = try solution2(@embedFile("input.txt"));
    std.log.info("Part2: {}", .{result2});
}

fn solution(input: []const u8) !u32 {
    var lines = std.mem.split(u8, input, "\n");

    var counter = 0;

    while (lines.next()) {
        counter += 1;
    }

    return counter;
}

fn solution2(input: []const u8) !u32 {
    var lines = std.mem.split(u8, input, "\n");

    var counter = 0;

    while (lines.next()) {
        counter += 1;
    }

    return counter;
}

test "solution1" {
    const want = 1;
    const got = try solution(@embedFile("input_test.txt"));
    std.testing.expect(want == got) catch |err| {
        std.log.err("Want {}, got {}", .{ want, got });
        return err;
    };
}

test "solution2" {
    const want = 1;
    const got = try solution2(@embedFile("input_test.txt"));
    std.testing.expect(want == got) catch |err| {
        std.log.err("Want {}, got {}", .{ want, got });
        return err;
    };
}
