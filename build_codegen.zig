const std = @import("std");

pub fn setup(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, sometimes_disabled_mod: *std.Build.Module) void {
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

    // Single-mode emit-asm for quick iteration.
    // Defaults to ReleaseFast because Debug mode doesn't emit assembly in Zig 0.15.
    const emit_optimize = if (optimize == .Debug) .ReleaseFast else optimize;
    const codegen_mod = b.createModule(.{
        .root_source_file = b.path("src/codegen_harness.zig"),
        .target = target,
        .optimize = emit_optimize,
    });
    codegen_mod.addImport("sometimes", sometimes_disabled_mod);
    const codegen_obj = b.addObject(.{
        .name = "codegen_harness",
        .root_module = codegen_mod,
    });
    const emit_asm_step = b.step("emit-asm", "Emit raw assembly for single optimization level");
    emit_asm_step.dependOn(&b.addInstallFile(codegen_obj.getEmittedAsm(), "codegen_harness.s").step);
}
