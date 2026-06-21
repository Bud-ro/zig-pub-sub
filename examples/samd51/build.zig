const std = @import("std");

/// Build configuration for the SAMD51 (Adafruit Metro M4) firmware package.
pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .thumb,
        .os_tag = .freestanding,
        .abi = .eabi,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m4 },
    });

    const optimize = b.standardOptimizeOption(.{});

    const erd_core_dep = b.dependency("erd_core", .{
        .target = target,
        .optimize = optimize,
    });
    const erd_core_mod = erd_core_dep.module("erd_core");

    const elf_size_dep = b.dependency("elf_size", .{});
    const elf_size_exe = elf_size_dep.artifact("elf-size");

    const firmware = b.addExecutable(.{
        .name = "firmware.elf",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    firmware.root_module.addImport("erd_core", erd_core_mod);
    firmware.setLinkerScript(b.path("samd51.ld"));
    firmware.entry = .{ .symbol_name = "Reset_Handler" };

    b.installArtifact(firmware);

    // --- Objcopy to .bin ---
    const bin = b.addObjCopy(firmware.getEmittedBin(), .{
        .format = .bin,
    });
    bin.step.dependOn(&firmware.step);
    const install_bin = b.addInstallBinFile(bin.getOutput(), "firmware.bin");
    b.getInstallStep().dependOn(&install_bin.step);

    // --- Memory report ---
    const mem_report = b.addRunArtifact(elf_size_exe);
    mem_report.addFileArg(firmware.getEmittedBin());
    mem_report.addArgs(&.{
        "--output",
    });
    mem_report.addArg("zig-out/MEMORY_REPORT.txt");
    mem_report.addArgs(&.{
        "FLASH:00000000:80000",
        "RAM:20000000:30000",
    });
    mem_report.step.dependOn(&firmware.step);
    b.getInstallStep().dependOn(&mem_report.step);

    // --- Flash step via bossac ---
    const flash_step = b.step("flash", "Flash firmware to Metro M4 via bossac");
    const flash_cmd = b.addSystemCommand(&.{
        "bossac",
        "--port",
        "/dev/ttyACM0",
        "--offset",
        "0x4000",
        "--erase",
        "--write",
        "--verify",
        "--reset",
    });
    flash_cmd.addFileArg(bin.getOutput());
    flash_cmd.step.dependOn(&install_bin.step);
    flash_step.dependOn(&flash_cmd.step);
}
