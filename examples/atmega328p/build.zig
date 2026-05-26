const std = @import("std");

/// Build configuration for the ATmega328P (Arduino Uno) firmware package.
pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .avr,
        .os_tag = .freestanding,
        .abi = .none,
        .cpu_model = .{ .explicit = &std.Target.avr.cpu.atmega328p },
    });

    const optimize = b.standardOptimizeOption(.{});
    const effective_optimize: std.builtin.OptimizeMode = if (optimize == .Debug) .ReleaseSmall else optimize;

    const erd_core_dep = b.dependency("erd_core", .{
        .target = target,
        .optimize = effective_optimize,
    });
    const erd_core_mod = erd_core_dep.module("erd_core");

    // Build elf-size tool for the host
    const elf_size_dep = b.dependency("elf_size", .{});
    const elf_size_exe = elf_size_dep.artifact("elf-size");

    // --- Firmware ELF ---
    const firmware = b.addExecutable(.{
        .name = "firmware.elf",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = effective_optimize,
        }),
    });
    firmware.bundle_compiler_rt = false;
    firmware.root_module.addImport("erd_core", erd_core_mod);

    // --- Objcopy to Intel HEX ---
    const hex = firmware.addObjCopy(.{
        .format = .hex,
    });
    const hex_install = b.addInstallBinFile(hex.getOutput(), "firmware.hex");

    // --- Memory report ---
    const mem_report = b.addRunArtifact(elf_size_exe);
    mem_report.addArtifactArg(firmware);
    mem_report.addArgs(&.{
        "--output",
    });
    const report_output = mem_report.addOutputFileArg("MEMORY_REPORT.txt");
    mem_report.addArgs(&.{
        "FLASH:0000:8000",
        "SRAM:0100:0800",
    });
    const report_install = b.addInstallFile(report_output, "MEMORY_REPORT.txt");

    b.getInstallStep().dependOn(&hex_install.step);
    b.getInstallStep().dependOn(&report_install.step);

    // --- Flash step ---
    const flash_step = b.step("flash", "Flash firmware to ATmega328P via avrdude");
    const flash_cmd = b.addSystemCommand(&.{
        "avrdude",
        "-p",
        "m328p",
        "-c",
        "arduino",
        "-P",
        "/dev/ttyACM0",
        "-b",
        "115200",
        "-U",
    });
    const flash_arg = std.fmt.allocPrint(b.allocator, "flash:w:{s}:i", .{
        hex.getOutput().getDisplayName(),
    }) catch @panic("OOM");
    flash_cmd.addArg(flash_arg);
    flash_cmd.step.dependOn(&hex_install.step);
    flash_step.dependOn(&flash_cmd.step);
}
