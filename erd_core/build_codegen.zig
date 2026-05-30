const std = @import("std");

/// Configure codegen snapshot build steps for assembly verification.
pub fn setup(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, sometimes_disabled_mod: *std.Build.Module, core_mod: *std.Build.Module) void {
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
        const modes = [_]std.builtin.OptimizeMode{ .ReleaseSmall, .ReleaseFast };
        const mode_names = [_][]const u8{ "ReleaseSmall", "ReleaseFast" };

        const codegen_target = b.resolveTargetQuery(.{
            .cpu_arch = .x86_64,
            .os_tag = .linux,
        });

        const Harness = struct { source: []const u8, prefix: []const u8, obj_tag: []const u8 };
        const harnesses = [_]Harness{
            .{ .source = "src/codegen_harness.zig", .prefix = "", .obj_tag = "harness" },
            .{ .source = "src/codegen_mono_stress.zig", .prefix = "mono/", .obj_tag = "mono" },
            .{ .source = "src/codegen_timer.zig", .prefix = "timer/", .obj_tag = "timer" },
        };

        for (modes, mode_names) |mode, mode_name| {
            for (harnesses) |harness| {
                const codegen_mod = b.createModule(.{
                    .root_source_file = b.path(harness.source),
                    .target = codegen_target,
                    .optimize = mode,
                    .omit_frame_pointer = true,
                });

                const sometimes_dep = b.dependency("assert_sometimes", .{
                    .target = codegen_target,
                    .optimize = mode,
                    .enable_sometimes = false,
                });
                codegen_mod.addImport("sometimes", sometimes_dep.module("sometimes"));
                codegen_mod.addImport("erd_core", core_mod);

                const codegen_obj = b.addObject(.{
                    .name = b.fmt("codegen_{s}_{s}", .{ harness.obj_tag, mode_name }),
                    .root_module = codegen_mod,
                });

                const obj_bin = codegen_obj.getEmittedBin();
                const full_dir = b.fmt("{s}{s}", .{ harness.prefix, mode_name });
                const sizes_name = b.fmt("{s}{s}_x86_64.sizes", .{ harness.prefix, mode_name });

                const run_nm = b.addSystemCommand(&.{
                    "sh", "-c",
                    \\printf '# size (bytes)\tfunction\n'
                    \\nm --print-size --size-sort "$1" | grep ' T [a-z]' | while IFS=' ' read -r _ size _ name; do printf '%d\t%s\n' "0x$size" "$name"; done
                    ,
                    "--",
                });
                run_nm.addFileArg(obj_bin);
                const sizes_file = run_nm.captureStdOut(.{});

                codegen_update_step.dependOn(&b.addInstallFileWithDir(sizes_file, .{ .custom = "../codegen" }, sizes_name).step);

                const check_sizes = b.addSystemCommand(&.{ "diff", "-u" });
                check_sizes.addFileArg(b.path(b.fmt("codegen/{s}", .{sizes_name})));
                check_sizes.addFileArg(sizes_file);
                check_sizes.setName(b.fmt("check {s}", .{sizes_name}));
                check_sizes.expectExitCode(0);
                codegen_check_step.dependOn(&check_sizes.step);

                const asm_file = codegen_obj.getEmittedAsm();

                const run_split = b.addRunArtifact(strip_asm);
                run_split.addFileArg(asm_file);
                run_split.addArg("--split-dir");
                const split_dir = run_split.addOutputDirectoryArg(full_dir);

                const clean_split = b.addSystemCommand(&.{ "sh", "-c", "rm -f \"$1\"/*.s", "--" });
                clean_split.addDirectoryArg(b.path(b.fmt("codegen/{s}", .{full_dir})));
                const install_split = b.addInstallDirectory(.{
                    .source_dir = split_dir,
                    .install_dir = .{ .custom = b.fmt("../codegen/{s}", .{full_dir}) },
                    .install_subdir = "",
                });
                install_split.step.dependOn(&clean_split.step);
                codegen_update_step.dependOn(&install_split.step);

                const check_asm = b.addSystemCommand(&.{ "diff", "-ru" });
                check_asm.addDirectoryArg(b.path(b.fmt("codegen/{s}", .{full_dir})));
                check_asm.addDirectoryArg(split_dir);
                check_asm.setName(b.fmt("check {s}/", .{full_dir}));
                check_asm.expectExitCode(0);
                codegen_check_step.dependOn(&check_asm.step);

                const combined_name = b.fmt("{s}{s}_x86_64.s", .{ harness.prefix, mode_name });
                const run_combined = b.addRunArtifact(strip_asm);
                run_combined.addFileArg(asm_file);
                const combined_asm = run_combined.addOutputFileArg(combined_name);
                codegen_update_step.dependOn(&b.addInstallFileWithDir(combined_asm, .{ .custom = "../codegen" }, combined_name).step);
            }
        }
    }

    // Single-mode emit-asm for quick iteration (all harnesses).
    // Defaults to ReleaseFast because Debug mode doesn't emit assembly in Zig 0.15.
    const emit_optimize = if (optimize == .Debug) .ReleaseFast else optimize;
    const emit_asm_step = b.step("emit-asm", "Emit raw assembly for single optimization level");

    const emit_sources = [_]struct { source: []const u8, output: []const u8 }{
        .{ .source = "src/codegen_harness.zig", .output = "codegen_harness.s" },
        .{ .source = "src/codegen_mono_stress.zig", .output = "codegen_mono_stress.s" },
        .{ .source = "src/codegen_timer.zig", .output = "codegen_timer.s" },
    };
    for (emit_sources) |src| {
        const mod = b.createModule(.{
            .root_source_file = b.path(src.source),
            .target = target,
            .optimize = emit_optimize,
            .omit_frame_pointer = true,
        });
        mod.addImport("sometimes", sometimes_disabled_mod);
        mod.addImport("erd_core", core_mod);
        const obj = b.addObject(.{
            .name = std.Io.Dir.path.stem(src.source),
            .root_module = mod,
        });
        emit_asm_step.dependOn(&b.addInstallFile(obj.getEmittedAsm(), src.output).step);
    }
}
