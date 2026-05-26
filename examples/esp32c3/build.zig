const std = @import("std");

/// Build configuration for the ESP32-C3 bare-metal RISC-V firmware package.
pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .riscv32,
        .os_tag = .freestanding,
        .abi = .none,
        .cpu_model = .{ .explicit = &std.Target.riscv.cpu.generic_rv32 },
        .cpu_features_add = std.Target.riscv.featureSet(&.{ .i, .m, .c }),
    });

    const erd_core_dep = b.dependency("erd_core", .{
        .target = target,
        .optimize = .ReleaseSmall,
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
            .optimize = .ReleaseSmall,
        }),
    });
    firmware.root_module.addImport("erd_core", erd_core_mod);
    firmware.setLinkerScript(b.path("esp32c3.ld"));

    // --- Objcopy to raw binary ---
    const bin = firmware.addObjCopy(.{ .format = .bin });
    const install_bin = b.addInstallBinFile(bin.getOutput(), "firmware.bin");
    b.getInstallStep().dependOn(&install_bin.step);

    // Also install the ELF for debugging
    const install_elf = b.addInstallArtifact(firmware, .{});
    b.getInstallStep().dependOn(&install_elf.step);

    // --- Memory report ---
    const mem_report = b.addRunArtifact(elf_size_exe);
    mem_report.addArgs(&.{
        b.getInstallPath(.{ .custom = "bin" }, "firmware"),
        "--output",
        b.getInstallPath(.{ .custom = "bin" }, "MEMORY_REPORT.txt"),
        "IRAM:40380000:64000",
        "DRAM:3FC80000:64000",
    });
    mem_report.step.dependOn(&install_elf.step);
    b.getInstallStep().dependOn(&mem_report.step);

    // --- Flash step ---
    const flash_step = b.step("flash", "Flash firmware to ESP32-C3 via esptool");
    const flash_cmd = b.addSystemCommand(&.{
        "esptool.py",
        "--chip",
        "esp32c3",
        "--port",
        "/dev/ttyUSB0",
        "write_flash",
        "0x0",
    });
    flash_cmd.addFileArg(bin.getOutput());
    flash_cmd.step.dependOn(&install_bin.step);
    flash_step.dependOn(&flash_cmd.step);
}
