const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const erd_core_dep = b.dependency("erd_core", .{
        .target = target,
        .optimize = optimize,
    });

    const schema_mod = b.addModule("erd_schema", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    schema_mod.addImport("erd_core", erd_core_dep.module("erd_core"));

    const tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    tests.root_module.addImport("erd_core", erd_core_dep.module("erd_core"));
    tests.root_module.addImport("erd_schema", tests.root_module);

    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run erd_schema unit tests");
    test_step.dependOn(&run_tests.step);

    const tests_install = b.addInstallArtifact(tests, .{ .dest_dir = .default });
    const test_no_run_step = b.step("test_no_run", "Build erd_schema tests but don't run them");
    test_no_run_step.dependOn(&tests_install.step);
}
