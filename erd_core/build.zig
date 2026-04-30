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

    const core_mod = b.addModule("erd_core", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    core_mod.addImport("sometimes", sometimes_disabled_mod);
    core_mod.addImport("erd_core", core_mod);

    const assert_sometimes_enabled = b.dependency("assert_sometimes", .{
        .target = target,
        .optimize = optimize,
        .enable_sometimes = true,
    });
    const sometimes_enabled_mod = assert_sometimes_enabled.module("sometimes");

    const test_coverage = b.addTest(.{
        .test_runner = .{
            .path = assert_sometimes_enabled.path("src/test_runner.zig"),
            .mode = .simple,
        },
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    test_coverage.root_module.addImport("sometimes", sometimes_enabled_mod);
    test_coverage.root_module.addImport("erd_core", test_coverage.root_module);

    const run_coverage = b.addRunArtifact(test_coverage);
    const coverage_step = b.step("test_coverage", "Run core tests with coverage (sometimes assertions)");
    coverage_step.dependOn(&run_coverage.step);

    const tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    tests.root_module.addImport("sometimes", sometimes_disabled_mod);
    tests.root_module.addImport("erd_core", tests.root_module);

    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run core unit tests");
    test_step.dependOn(&run_tests.step);

    const tests_install = b.addInstallArtifact(tests, .{ .dest_dir = .default });
    const test_no_run_step = b.step("test_no_run", "Build core tests but don't run them");
    test_no_run_step.dependOn(&tests_install.step);

    @import("build_codegen.zig").setup(b, target, optimize, sometimes_disabled_mod, core_mod);
}
