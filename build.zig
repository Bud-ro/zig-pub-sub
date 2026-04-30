const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // --- Sub-package dependencies ---
    const erd_core_dep = b.dependency("erd_core", .{ .target = target, .optimize = optimize });
    const erd_schema_dep = b.dependency("erd_schema", .{ .target = target, .optimize = optimize });
    const data_gen_dep = b.dependency("data_gen", .{ .target = target, .optimize = optimize });
    const app_dep = b.dependency("app", .{ .target = target, .optimize = optimize });

    // --- Aggregate test step ---
    const test_step = b.step("test", "Run all tests across all packages");

    const erd_core_mod = erd_core_dep.module("erd_core");

    // erd_core tests
    const assert_sometimes_disabled = erd_core_dep.builder.dependency("assert_sometimes", .{
        .target = target,
        .optimize = optimize,
        .enable_sometimes = false,
    });
    const sometimes_disabled_mod = assert_sometimes_disabled.module("sometimes");

    const core_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = erd_core_dep.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    core_tests.root_module.addImport("sometimes", sometimes_disabled_mod);
    core_tests.root_module.addImport("erd_core", core_tests.root_module);
    test_step.dependOn(&b.addRunArtifact(core_tests).step);

    // erd_core coverage tests
    const assert_sometimes_enabled = erd_core_dep.builder.dependency("assert_sometimes", .{
        .target = target,
        .optimize = optimize,
        .enable_sometimes = true,
    });
    const sometimes_enabled_mod = assert_sometimes_enabled.module("sometimes");

    const core_coverage = b.addTest(.{
        .test_runner = .{
            .path = assert_sometimes_enabled.path("src/test_runner.zig"),
            .mode = .simple,
        },
        .root_module = b.createModule(.{
            .root_source_file = erd_core_dep.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    core_coverage.root_module.addImport("sometimes", sometimes_enabled_mod);
    core_coverage.root_module.addImport("erd_core", core_coverage.root_module);

    const test_coverage_step = b.step("test_coverage", "Run erd_core tests with coverage (sometimes assertions)");
    test_coverage_step.dependOn(&b.addRunArtifact(core_coverage).step);

    // erd_schema tests
    const schema_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = erd_schema_dep.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    schema_tests.root_module.addImport("erd_core", erd_core_mod);
    schema_tests.root_module.addImport("erd_schema", schema_tests.root_module);
    test_step.dependOn(&b.addRunArtifact(schema_tests).step);

    // data_gen tests
    const data_gen_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = data_gen_dep.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    data_gen_tests.root_module.addImport("data_gen", data_gen_tests.root_module);
    test_step.dependOn(&b.addRunArtifact(data_gen_tests).step);

    // --- Run step (forwards to app) ---
    const app_exe = app_dep.artifact("zig-pub-sub");
    const run_cmd = b.addRunArtifact(app_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    b.installArtifact(app_exe);

    // --- Codegen steps (delegate to erd_core) ---
    const codegen_check = b.addSystemCommand(&.{ b.graph.zig_exe, "build", "codegen-check" });
    codegen_check.setCwd(b.path("erd_core"));
    const codegen_check_step = b.step("codegen-check", "Verify codegen/ snapshots are up-to-date (delegates to erd_core)");
    codegen_check_step.dependOn(&codegen_check.step);

    const codegen_update = b.addSystemCommand(&.{ b.graph.zig_exe, "build", "codegen-update" });
    codegen_update.setCwd(b.path("erd_core"));
    const codegen_update_step = b.step("codegen-update", "Regenerate codegen/ assembly snapshots (delegates to erd_core)");
    codegen_update_step.dependOn(&codegen_update.step);

    const emit_asm = b.addSystemCommand(&.{ b.graph.zig_exe, "build", "emit-asm" });
    emit_asm.setCwd(b.path("erd_core"));
    const emit_asm_step = b.step("emit-asm", "Emit raw assembly for single optimization level (delegates to erd_core)");
    emit_asm_step.dependOn(&emit_asm.step);
}
