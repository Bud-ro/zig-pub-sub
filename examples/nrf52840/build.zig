const std = @import("std");

/// Build configuration for the nRF52840-DK firmware package.
///
/// Targets:
///   zig build        - Build firmware ELF and .bin, run memory report
///   zig build flash  - Flash via nrfjprog (Nordic command-line tools)
pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});

    const target = b.resolveTargetQuery(.{
        .cpu_arch = .thumb,
        .os_tag = .freestanding,
        .abi = .none,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m4 },
    });

    // Resolve erd_core dependency
    const erd_core_dep = b.dependency("erd_core", .{
        .target = target,
        .optimize = optimize,
    });
    const erd_core_mod = erd_core_dep.module("erd_core");

    // Build elf-size tool for the host
    const elf_size_dep = b.dependency("elf_size", .{});
    const elf_size_exe = elf_size_dep.artifact("elf-size");

    const exe = b.addExecutable(.{
        .name = "firmware",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/start.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    exe.root_module.addImport("erd_core", erd_core_mod);
    exe.setLinkerScript(b.path("nrf52840.ld"));

    // Convert ELF to raw binary and Intel HEX
    const bin = exe.addObjCopy(.{ .format = .bin });
    const install_bin = b.addInstallBinFile(bin.getOutput(), "firmware.bin");

    const hex = exe.addObjCopy(.{ .format = .hex });
    const install_hex = b.addInstallBinFile(hex.getOutput(), "firmware.hex");

    b.getInstallStep().dependOn(&install_bin.step);
    b.getInstallStep().dependOn(&install_hex.step);

    // --- Memory report ---
    const mkdir = b.addSystemCommand(&.{ "mkdir", "-p", "zig-out" });
    mkdir.setCwd(b.path("."));

    const mem_report = b.addRunArtifact(elf_size_exe);
    mem_report.setCwd(b.path("."));
    mem_report.addFileArg(exe.getEmittedBin());
    mem_report.addArgs(&.{
        "--output",
        "zig-out/MEMORY_REPORT.txt",
        "FLASH:00000000:100000",
        "RAM:20000000:40000",
    });
    mem_report.step.dependOn(&mkdir.step);
    b.getInstallStep().dependOn(&mem_report.step);

    // --- Flash via nrfjprog ---
    const flash_step = b.step("flash", "Flash firmware to nRF52840-DK via nrfjprog");
    const flash_cmd = b.addSystemCommand(&.{
        "nrfjprog",
        "--program",
    });
    flash_cmd.addFileArg(hex.getOutput());
    flash_cmd.addArgs(&.{
        "--sectorerase",
        "--reset",
    });
    flash_cmd.step.dependOn(&hex.step);
    flash_step.dependOn(&flash_cmd.step);
}
