const std = @import("std");

/// Build configuration for the MSP430G2553 (LaunchPad) firmware package.
pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .msp430,
        .os_tag = .freestanding,
        .abi = .none,
    });

    const erd_core_dep = b.dependency("erd_core", .{
        .target = target,
        .optimize = .ReleaseSmall,
    });
    const erd_core_mod = erd_core_dep.module("erd_core");

    // Build elf-size tool for the host
    const elf_size_dep = b.dependency("elf_size", .{});
    const elf_size_exe = elf_size_dep.artifact("elf-size");

    const fw = b.addExecutable(.{
        .name = "firmware",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = .ReleaseSmall,
        }),
    });
    fw.root_module.addImport("erd_core", erd_core_mod);
    fw.setLinkerScript(b.path("msp430.ld"));

    // Zig 0.16 compiler_rt has a sqrt bug on 16-bit targets (usize = u16).
    // We do not use any soft-float or sqrt routines, so it is safe to omit.
    fw.bundle_compiler_rt = false;

    // Emit Intel HEX for MSP430 flash tools
    const hex = fw.addObjCopy(.{ .format = .hex });
    const install_hex = b.addInstallBinFile(hex.getOutput(), "firmware.hex");

    // Also install the ELF for debugging / size reporting
    const install_elf = b.addInstallArtifact(fw, .{});

    // Memory report
    const mem_report = b.addRunArtifact(elf_size_exe);
    mem_report.addArtifactArg(fw);
    mem_report.addArgs(&.{
        "--output",
    });
    const report_output = mem_report.addOutputFileArg("MEMORY_REPORT.txt");
    mem_report.addArgs(&.{
        "FLASH:C000:3FDE",
        "RAM:0200:0200",
    });
    const install_report = b.addInstallFile(report_output, "MEMORY_REPORT.txt");

    b.getInstallStep().dependOn(&install_hex.step);
    b.getInstallStep().dependOn(&install_elf.step);
    b.getInstallStep().dependOn(&install_report.step);

    // Flash step: program via mspdebug
    const flash_step = b.step("flash", "Flash firmware to MSP430 LaunchPad via mspdebug");
    const flash_cmd = b.addSystemCommand(&.{
        "mspdebug",
        "rf2500",
        "prog zig-out/bin/firmware.hex",
    });
    flash_cmd.step.dependOn(&install_hex.step);
    flash_step.dependOn(&flash_cmd.step);
}
