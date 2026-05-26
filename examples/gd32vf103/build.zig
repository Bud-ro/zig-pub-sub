const std = @import("std");

/// Build configuration for the GD32VF103 (Longan Nano) firmware package.
pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .riscv32,
        .os_tag = .freestanding,
        .abi = .none,
        .cpu_model = .{ .explicit = &std.Target.riscv.cpu.generic_rv32 },
        .cpu_features_add = std.Target.riscv.featureSet(&.{ .i, .m, .a, .c }),
    });

    // Default to ReleaseSmall for firmware; override with -Doptimize=Debug if needed
    const optimize = b.option(
        std.builtin.OptimizeMode,
        "optimize",
        "Prioritize performance, safety, or binary size",
    ) orelse .ReleaseSmall;

    const erd_core_dep = b.dependency("erd_core", .{
        .target = target,
        .optimize = optimize,
    });
    const erd_core_mod = erd_core_dep.module("erd_core");

    // Build elf-size tool for the host
    const elf_size_dep = b.dependency("elf_size", .{});
    const elf_size_exe = elf_size_dep.artifact("elf-size");

    const firmware = b.addExecutable(.{
        .name = "firmware",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .strip = true,
        }),
    });
    firmware.root_module.addImport("erd_core", erd_core_mod);
    firmware.setLinkerScript(b.path("gd32vf103.ld"));

    // --- Objcopy to raw binary ---
    const bin = firmware.addObjCopy(.{ .format = .bin });
    const install_bin = b.addInstallBinFile(bin.getOutput(), "firmware.bin");
    b.getInstallStep().dependOn(&install_bin.step);

    // Also install the ELF for debugging
    b.installArtifact(firmware);

    // --- Memory report ---
    const mem_report = b.addRunArtifact(elf_size_exe);
    mem_report.addArgs(&.{
        b.getInstallPath(.bin, "firmware"),
        "--output",
        b.getInstallPath(.bin, "MEMORY_REPORT.txt"),
        "FLASH:08000000:20000",
        "RAM:20000000:8000",
    });
    mem_report.step.dependOn(&firmware.step);
    const mem_step = b.step("mem", "Print memory usage report");
    mem_step.dependOn(&mem_report.step);

    // --- Flash step via DFU ---
    const flash_step = b.step("flash", "Flash firmware to Longan Nano via DFU");
    const flash_cmd = b.addSystemCommand(&.{
        "dfu-util",
        "-a",
        "0",
        "-s",
        "0x08000000",
        "-D",
    });
    flash_cmd.addFileArg(bin.getOutput());
    flash_step.dependOn(&flash_cmd.step);
}
