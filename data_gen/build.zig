const std = @import("std");

/// Build configuration for the data_gen package.
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    _ = b.addModule("data_gen", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    tests.root_module.addImport("data_gen", tests.root_module);

    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run data_gen unit tests");
    test_step.dependOn(&run_tests.step);

    const tests_install = b.addInstallArtifact(tests, .{ .dest_dir = .default });
    const test_no_run_step = b.step("test_no_run", "Build data_gen tests but don't run them");
    test_no_run_step.dependOn(&tests_install.step);
}
