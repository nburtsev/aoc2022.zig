const std = @import("std");

pub fn main() !void {
    const result = try solution(@embedFile("input.txt"));
    std.log.info("Part1: {}", .{result});

    const result2 = try solution2(@embedFile("input.txt"));
    std.log.info("Part2: {}", .{result2});
}

fn solution(input: []const u8) !u32 {
    var lines = std.mem.split(u8, input, "\n");

    var max_calories: u32 = 0;
    var elf_load: u32 = 0;

    while (lines.next()) |line| {
        if (std.mem.eql(u8, line, "")) {
            max_calories = @max(elf_load, max_calories);
            elf_load = 0;
            continue;
        }

        var load = try std.fmt.parseInt(u32, line, 10);
        elf_load += load;
    }

    return max_calories;
}

fn solution2(input: []const u8) !u32 {
    var lines = std.mem.split(u8, input, "\n");

    var elf_load: u32 = 0;

    var max: [3]u32 = .{ 0, 0, 0 };
    while (lines.next()) |line| {
        if (std.mem.eql(u8, line, "")) {
            if (elf_load > max[0]) {
                max[2] = max[1];
                max[1] = max[0];
                max[0] = elf_load;
            } else if (elf_load > max[1]) {
                max[2] = max[1];
                max[1] = elf_load;
            } else if (elf_load > max[2]) {
                max[2] = elf_load;
            }
            elf_load = 0;
            continue;
        }

        var load = try std.fmt.parseInt(u32, line, 10);
        elf_load += load;
    }

    return max[0] + max[1] + max[2];
}

test "solution1" {
    const want = 24000;
    const got = try solution(@embedFile("input_test.txt"));
    std.testing.expect(want == got) catch |err| {
        std.log.err("Want {}, got {}", .{ want, got });
        return err;
    };
}

test "solution2" {
    const want = 45000;
    const got = try solution2(@embedFile("input_test.txt"));
    std.testing.expect(want == got) catch |err| {
        std.log.err("Want {}, got {}", .{ want, got });
        return err;
    };
}
