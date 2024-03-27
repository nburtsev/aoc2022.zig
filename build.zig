const std = @import("std");

fn listDir(dir_name: []const u8, b: *std.build.Builder) ![][]const u8 {
    var dir_list = std.ArrayList([]const u8).init(b.allocator);
    defer dir_list.deinit();

    var dir = try std.fs.cwd().openIterableDir(dir_name, .{});
    defer dir.close();

    var it = dir.iterate();

    while (try it.next()) |entry| {
        if (entry.kind != .directory) {
            continue;
        }
        try dir_list.append(b.dupe(entry.name));
    }

    return dir_list.toOwnedSlice();
}

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const daysList = try listDir("src", b);

    for (daysList) |day| {
        const path = b.fmt("src/{s}", .{day});
        const root_src = b.fmt("{s}/main.zig", .{path});

        const exe = b.addExecutable(.{ .name = day, .root_source_file = .{ .path = root_src }, .target = target, .optimize = optimize });

        b.installArtifact(exe);

        const install_cmd = b.addInstallArtifact(exe, .{});
        const install_step = b.step(day, "Build specified day");
        install_step.dependOn(&install_cmd.step);

        const run_cmd = b.addRunArtifact(exe);
        run_cmd.step.dependOn(&install_cmd.step);
        if (b.args) |args| {
            run_cmd.addArgs(args);
        }

        const run_step = b.step(b.fmt("run_{s}", .{day}), "Run day.");
        run_step.dependOn(&run_cmd.step);

        const unit_test = b.addTest(.{ .root_source_file = .{ .path = root_src }, .target = target, .optimize = optimize });
        const test_cmd = b.addRunArtifact(unit_test);
        const test_step = b.step(b.fmt("test_{s}", .{day}), "Run tests.");
        test_step.dependOn(&test_cmd.step);
    }
}
