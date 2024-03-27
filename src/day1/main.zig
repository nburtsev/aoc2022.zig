const std = @import("std");

pub fn main() !void {
    const result = try solution(@embedFile("input.txt"));
    std.log.info("{}", .{result});
}

fn solution(input: []const u8) !i32 {
    var lines = std.mem.split(u8, input, "\n");

    var c: i32 = 0;
    while (lines.next() != null) {
        c += 1;
    }

    return c;
}

test "solution1" {
    const want = 1;
    const got = try solution(@embedFile("input_test.txt"));
    std.testing.expect(want == got) catch |err| {
        std.log.err("Want {}, got {}", .{ want, got });
        return err;
    };
}
