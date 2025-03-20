const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .avr,
        .cpu_model = .baseline,
        .os_tag = .freestanding,
        .abi = .eabi,
    });
    const host_target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "zig_pub_sub",
        .root_source_file = b.path("src/atmega2560_main.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(lib);

    const exe = b.addExecutable(.{
        .name = "zig_pub_sub",
        .root_source_file = b.path("src/atmega2560_main.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe);

    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/unit_tests.zig"),
        .target = host_target,
        .optimize = optimize,
    });
    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
}
