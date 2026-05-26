const std = @import("std");

/// Build configuration for the STM32L072 (Nucleo-L073RZ) firmware package.
pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .thumb,
        .os_tag = .freestanding,
        .abi = .eabi,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m0plus },
    });

    const optimize: std.builtin.OptimizeMode = .ReleaseSmall;
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
    firmware.setLinkerScript(b.path("stm32l072.ld"));
    firmware.entry = .disabled;

    b.installArtifact(firmware);

    // --- objcopy to .bin ---
    const bin = b.addObjCopy(firmware.getEmittedBin(), .{
        .format = .bin,
    });
    const install_bin = b.addInstallBinFile(bin.getOutput(), "firmware.bin");
    b.getInstallStep().dependOn(&install_bin.step);

    // --- Memory report ---
    const mem_report = b.addRunArtifact(elf_size_exe);
    mem_report.addFileArg(firmware.getEmittedBin());
    mem_report.addArgs(&.{
        "--output",
        "zig-out/MEMORY_REPORT.txt",
        "FLASH:08000000:30000",
        "RAM:20000000:5000",
    });
    mem_report.setCwd(b.path("."));
    b.getInstallStep().dependOn(&mem_report.step);

    // --- Flash step via st-flash ---
    const flash_step = b.step("flash", "Flash firmware to STM32L072 via st-flash");
    const flash_cmd = b.addSystemCommand(&.{
        "st-flash",
        "write",
    });
    flash_cmd.addFileArg(bin.getOutput());
    flash_cmd.addArg("0x08000000");
    flash_cmd.step.dependOn(&install_bin.step);
    flash_step.dependOn(&flash_cmd.step);
}
