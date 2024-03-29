const std = @import("std");

pub fn main() !void {
    const result = try solution(@embedFile("input.txt"));
    std.log.info("Part1: {}", .{result});

    const result2 = try solution2(@embedFile("input.txt"));
    std.log.info("Part2: {}", .{result2});
}

fn solution(input: []const u8) !u32 {
    var lines = std.mem.splitAny(u8, input, "\n");

    var total_priority: u32 = 0;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    while (lines.next()) |line| {
        const n = line.len;

        if (n == 0) {
            continue;
        }

        var counter = std.AutoHashMap(u8, bool).init(allocator);
        var i: u32 = 0;
        while (i < n / 2) : (i += 1) {
            var v = try counter.getOrPut(line[i]);
            if (!v.found_existing) {
                v.value_ptr.* = true;
            }
        }

        while (i < n) : (i += 1) {
            var v = counter.get(line[i]);
            if (v != null) {
                break;
            }
        }
        var p: u32 = if (line[i] > 95) line[i] - 96 else line[i] - 38;
        total_priority += p;

        //std.log.debug("{s} {} {} {}", .{ line, i, line[i], p });
    }

    return total_priority;
}

fn solution2(input: []const u8) !u32 {
    var lines = std.mem.splitAny(u8, input, "\n");

    var total_priority: u32 = 0;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        var counter = std.AutoHashMap(u8, u8).init(allocator);
        for (line) |k| {
            try counter.put(k, 1);
        }

        var next_line = lines.next();
        for (next_line.?) |k| {
            var v = counter.get(k);
            if (v != null) {
                try counter.put(k, 2);
            }
        }

        next_line = lines.next();
        for (next_line.?) |k| {
            var v = counter.get(k);
            if (v == 2) {
                var p: u32 = if (k > 95) k - 96 else k - 38;
                total_priority += p;
                break;
            }
        }
    }

    return total_priority;
}

test "solution1" {
    const want = 157;
    const got = try solution(@embedFile("input_test.txt"));
    std.testing.expect(want == got) catch |err| {
        std.log.err("Want {}, got {}", .{ want, got });
        return err;
    };
}

test "solution2" {
    const want = 70;
    const got = try solution2(@embedFile("input_test.txt"));
    std.testing.expect(want == got) catch |err| {
        std.log.err("Want {}, got {}", .{ want, got });
        return err;
    };
}
