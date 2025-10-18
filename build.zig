const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const assert_sometimes_disabled = b.dependency("assert_sometimes", .{
        .target = target,
        .optimize = optimize,
        .enable_sometimes = false,
    });
    const sometimes_disabled_mod = assert_sometimes_disabled.module("sometimes");

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe_mod.addImport("sometimes", sometimes_disabled_mod);

    const exe = b.addExecutable(.{
        .name = "zig-pub-sub",
        .root_module = exe_mod,
    });
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const assert_sometimes_enabled = b.dependency("assert_sometimes", .{
        .target = target,
        .optimize = optimize,
        .enable_sometimes = true,
    });
    const sometimes_mod = assert_sometimes_enabled.module("sometimes");

    const test_coverage = b.addTest(.{
        .test_runner = .{
            .path = assert_sometimes_enabled.path("src/test_runner.zig"),
            .mode = .simple,
        },
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/unit_tests.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    test_coverage.root_module.addImport("sometimes", sometimes_mod);

    const run_unit_tests_coverage = b.addRunArtifact(test_coverage);
    const test_coverage_step = b.step("test_coverage", "Run unit tests with coverage (sometimes assertions)");
    test_coverage_step.dependOn(&run_unit_tests_coverage.step);

    const tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/unit_tests.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    tests.root_module.addImport("sometimes", sometimes_disabled_mod);

    const run_unit_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);

    const tests_install = b.addInstallArtifact(tests, .{ .dest_dir = .default });
    const test_no_run_step = b.step("test_no_run", "Build unit tests but don't run them");
    test_no_run_step.dependOn(&tests_install.step);
}
