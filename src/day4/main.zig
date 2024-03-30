const std = @import("std");

pub fn main() !void {
    const result = try solution(@embedFile("input.txt"));
    std.log.info("Part1: {}", .{result});

    const result2 = try solution2(@embedFile("input.txt"));
    std.log.info("Part2: {}", .{result2});
}

const Pair = struct { left: u8, right: u8 };

fn splitPairs(pairs: []const u8) ![2][]const u8 {
    const sep = std.mem.indexOfScalar(u8, pairs, ',').?;
    return .{ pairs[0..sep], pairs[sep + 1 ..] };
}

fn parsePair(pair: []const u8) !Pair {
    const sep = std.mem.indexOfScalar(u8, pair, '-').?;
    const a = try std.fmt.parseInt(u8, pair[0..sep], 10);
    const b = try std.fmt.parseInt(u8, pair[sep + 1 ..], 10);

    return .{ .left = a, .right = b };
}

fn solution(input: []const u8) !u32 {
    var lines = std.mem.splitAny(u8, input, "\n");

    var counter: u32 = 0;

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        const pairs = try splitPairs(line);
        const p1 = try parsePair(pairs[0]);
        const p2 = try parsePair(pairs[1]);

        if ((p1.left <= p2.left and p1.right >= p2.right) or (p1.left >= p2.left and p1.right <= p2.right)) {
            counter += 1;
        }
    }

    return counter;
}

fn intersect(a: Pair, b: Pair) bool {
    if (a.left <= b.right and a.left >= b.left) {
        return true;
    }

    if (a.right <= b.right and a.right >= b.left) {
        return true;
    }

    if (b.left <= a.right and b.left >= a.left) {
        return true;
    }

    if (b.right <= a.right and b.right >= a.left) {
        return true;
    }

    return false;
}

fn solution2(input: []const u8) !u32 {
    var lines = std.mem.splitAny(u8, input, "\n");

    var counter: u32 = 0;

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        const pairs = try splitPairs(line);
        const p1 = try parsePair(pairs[0]);
        const p2 = try parsePair(pairs[1]);

        if (intersect(p1, p2)) {
            counter += 1;
        }
    }

    return counter;
}

test "solution1" {
    const want = 2;
    const got = try solution(@embedFile("input_test.txt"));
    std.testing.expect(want == got) catch |err| {
        std.log.err("Want {}, got {}", .{ want, got });
        return err;
    };
}

test "solution2" {
    const want = 4;
    const got = try solution2(@embedFile("input_test.txt"));
    std.testing.expect(want == got) catch |err| {
        std.log.err("Want {}, got {}", .{ want, got });
        return err;
    };
}

// 602
// 891
