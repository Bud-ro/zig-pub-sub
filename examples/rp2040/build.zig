const std = @import("std");

/// Build configuration for the RP2040 (Raspberry Pi Pico) firmware package.
///
/// Targets:
///   zig build        - Build firmware ELF, raw .bin, and memory report
///   zig build flash  - Flash via picotool over USB (BOOTSEL mode)
pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});

    const target = b.resolveTargetQuery(.{
        .cpu_arch = .thumb,
        .os_tag = .freestanding,
        .abi = .none,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m0plus },
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
    exe.setLinkerScript(b.path("rp2040.ld"));

    // Convert ELF to raw binary
    const bin = exe.addObjCopy(.{ .format = .bin });
    const install_bin = b.addInstallBinFile(bin.getOutput(), "firmware.bin");
    b.getInstallStep().dependOn(&install_bin.step);

    // Install ELF for debugging
    const install_elf = b.addInstallArtifact(exe, .{});
    b.getInstallStep().dependOn(&install_elf.step);

    // --- Memory report ---
    const mem_report = b.addRunArtifact(elf_size_exe);
    mem_report.addFileArg(exe.getEmittedBin());
    mem_report.addArgs(&.{
        "--output",
        "zig-out/MEMORY_REPORT.txt",
        "FLASH:10000000:200000",
        "RAM:20000000:40000",
    });
    mem_report.setCwd(b.path("."));
    b.getInstallStep().dependOn(&mem_report.step);

    // --- Flash via picotool (USB BOOTSEL mode) ---
    const flash_step = b.step("flash", "Flash firmware to Pico via picotool (hold BOOTSEL, plug USB)");
    const flash_cmd = b.addSystemCommand(&.{
        "picotool",
        "load",
        "-f",
    });
    flash_cmd.addFileArg(bin.getOutput());
    flash_cmd.step.dependOn(&bin.step);
    flash_step.dependOn(&flash_cmd.step);
}
