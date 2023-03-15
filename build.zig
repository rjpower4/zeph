/// Copyright © 2023 Rolfe Power
/// @file build.zig
/// @brief project build script
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "zeph",
        .root_source_file = .{ .path = "src/zeph.zig" },
        .target = target,
        .optimize = optimize,
    });
    lib.install();

    const main_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/zeph.zig" },
        .target = target,
        .optimize = optimize,
    });
    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);

    const mod = b.addModule("zeph", .{ .source_file = .{ .path = "src/zeph.zig" } });
    const exe = b.addExecutable(.{
        .name = "zeph-sample",
        .root_source_file = .{ .path = "examples/zeph-sample.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.addModule("zeph", mod);
    exe.install();
}
