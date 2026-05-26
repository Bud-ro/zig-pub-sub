const std = @import("std");

/// Build configuration for the STM32F407 (Discovery) firmware package.
/// Native Zig build targeting ARM Cortex-M4F -- no external toolchain required.
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

    // Build elf-size tool for the host
    const elf_size_dep = b.dependency("elf_size", .{});
    const elf_size_exe = elf_size_dep.artifact("elf-size");

    const firmware = b.addExecutable(.{
        .name = "stm32f407.elf",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    firmware.root_module.addImport("erd_core", erd_core_mod);

    firmware.entry = .disabled;
    firmware.setLinkerScript(b.path("stm32f407.ld"));

    b.installArtifact(firmware);

    // --- objcopy to raw binary ---
    const bin = b.addObjCopy(firmware.getEmittedBin(), .{
        .format = .bin,
    });
    bin.step.dependOn(&firmware.step);

    const copy_bin = b.addInstallBinFile(bin.getOutput(), "stm32f407.bin");
    b.getInstallStep().dependOn(&copy_bin.step);

    // --- Memory report ---
    const mem_report = b.addRunArtifact(elf_size_exe);
    mem_report.addArg(b.getInstallPath(.bin, "stm32f407.elf"));
    mem_report.addArgs(&.{
        "--output",
    });
    mem_report.addArg(b.getInstallPath(.bin, "MEMORY_REPORT.txt"));
    mem_report.addArgs(&.{
        "FLASH:08000000:100000",
        "SRAM:20000000:20000",
        "CCM:10000000:10000",
    });
    mem_report.step.dependOn(b.getInstallStep());

    const mem_step = b.step("mem", "Print memory usage report");
    mem_step.dependOn(&mem_report.step);

    // --- Flash step using st-flash ---
    const flash_step = b.step("flash", "Flash firmware to STM32F407 via st-flash");
    const flash_cmd = b.addSystemCommand(&.{
        "st-flash",
        "write",
    });
    flash_cmd.addArg(b.getInstallPath(.bin, "stm32f407.bin"));
    flash_cmd.addArg("0x08000000");
    flash_cmd.step.dependOn(&copy_bin.step);
    flash_step.dependOn(&flash_cmd.step);
}
