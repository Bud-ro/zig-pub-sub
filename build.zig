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

    // --- Codegen analysis tools ---

    const strip_asm = b.addExecutable(.{
        .name = "strip_asm",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/strip_asm.zig"),
            .target = b.graph.host,
        }),
    });
    b.installArtifact(strip_asm);

    const codegen_update_step = b.step("codegen-update", "Regenerate codegen/ assembly snapshots and sizes (Linux only)");
    const codegen_check_step = b.step("codegen-check", "Verify codegen/ snapshots are up-to-date (Linux only, used in CI)");

    if (b.graph.host.result.os.tag == .linux) {
        // TODO: Add Debug mode once Zig emits assembly for Debug objects (0.15 doesn't)
        const modes = [_]std.builtin.OptimizeMode{ .ReleaseSafe, .ReleaseSmall, .ReleaseFast };
        const mode_names = [_][]const u8{ "ReleaseSafe", "ReleaseSmall", "ReleaseFast" };

        const codegen_target = b.resolveTargetQuery(.{
            .cpu_arch = .x86_64,
            .os_tag = .linux,
        });

        for (modes, mode_names) |mode, mode_name| {
            const codegen_mod = b.createModule(.{
                .root_source_file = b.path("src/codegen_harness.zig"),
                .target = codegen_target,
                .optimize = mode,
            });

            const sometimes_dep = b.dependency("assert_sometimes", .{
                .target = codegen_target,
                .optimize = mode,
                .enable_sometimes = false,
            });
            codegen_mod.addImport("sometimes", sometimes_dep.module("sometimes"));

            const codegen_obj = b.addObject(.{
                .name = b.fmt("codegen_{s}", .{mode_name}),
                .root_module = codegen_mod,
            });

            const obj_bin = codegen_obj.getEmittedBin();
            const sizes_name = b.fmt("{s}_x86_64.sizes", .{mode_name});

            const run_nm = b.addSystemCommand(&.{
                "sh", "-c",
                \\printf '# size (bytes)\tfunction\n'
                \\nm --print-size --size-sort "$1" | grep ' T codegen_' | while IFS=' ' read -r _ size _ name; do printf '%d\t%s\n' "0x$size" "$name"; done
                ,
                "--",
            });
            run_nm.addFileArg(obj_bin);
            const sizes_file = run_nm.captureStdOut();

            codegen_update_step.dependOn(&b.addInstallFileWithDir(sizes_file, .{ .custom = "../codegen" }, sizes_name).step);

            const check_sizes = b.addSystemCommand(&.{ "diff", "-u" });
            check_sizes.addFileArg(b.path(b.fmt("codegen/{s}", .{sizes_name})));
            check_sizes.addFileArg(sizes_file);
            check_sizes.setName(b.fmt("check {s}", .{sizes_name}));
            check_sizes.expectExitCode(0);
            codegen_check_step.dependOn(&check_sizes.step);

            const snapshot_name = b.fmt("{s}_x86_64.s", .{mode_name});

            const asm_file = codegen_obj.getEmittedAsm();
            const run_strip = b.addRunArtifact(strip_asm);
            run_strip.addFileArg(asm_file);
            const stripped_asm = run_strip.addOutputFileArg(snapshot_name);

            codegen_update_step.dependOn(&b.addInstallFileWithDir(stripped_asm, .{ .custom = "../codegen" }, snapshot_name).step);

            const check_asm = b.addSystemCommand(&.{ "diff", "-u" });
            check_asm.addFileArg(b.path(b.fmt("codegen/{s}", .{snapshot_name})));
            check_asm.addFileArg(stripped_asm);
            check_asm.setName(b.fmt("check {s}", .{snapshot_name}));
            check_asm.expectExitCode(0);
            codegen_check_step.dependOn(&check_asm.step);
        }
    }

    // Keep single-mode emit-asm for quick iteration
    const codegen_mod = b.createModule(.{
        .root_source_file = b.path("src/codegen_harness.zig"),
        .target = target,
        .optimize = optimize,
    });
    codegen_mod.addImport("sometimes", sometimes_disabled_mod);
    const codegen_obj = b.addObject(.{
        .name = "codegen_harness",
        .root_module = codegen_mod,
    });
    const emit_asm_step = b.step("emit-asm", "Emit raw assembly for single optimization level");
    emit_asm_step.dependOn(&b.addInstallFile(codegen_obj.getEmittedAsm(), "codegen_harness.s").step);
}
