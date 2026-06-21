const std = @import("std");

/// Build configuration for the STM32F103C8T6 (Blue Pill) firmware package.
///
/// Targets:
///   zig build              - Build firmware ELF, .bin, and memory report
///   zig build flash        - Flash via st-flash (ST-Link)
///   zig build openocd      - Flash via OpenOCD
pub fn build(b: *std.Build) void {
    const optimize: std.builtin.OptimizeMode = .ReleaseSmall;

    const target = b.resolveTargetQuery(.{
        .cpu_arch = .thumb,
        .os_tag = .freestanding,
        .abi = .none,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m3 },
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
    exe.setLinkerScript(b.path("stm32f103.ld"));

    b.installArtifact(exe);

    // Convert ELF to raw binary
    const bin = exe.addObjCopy(.{ .format = .bin });
    const install_bin = b.addInstallBinFile(bin.getOutput(), "firmware.bin");
    b.getInstallStep().dependOn(&install_bin.step);

    // --- Memory report ---
    const mem_report = b.addRunArtifact(elf_size_exe);
    mem_report.addArtifactArg(exe);
    mem_report.addArgs(&.{
        "--output",
        "zig-out/MEMORY_REPORT.txt",
        "FLASH:08000000:10000",
        "SRAM:20000000:5000",
    });
    mem_report.setCwd(b.path("."));
    b.getInstallStep().dependOn(&mem_report.step);

    // --- Flash via st-flash (ST-Link) ---
    const flash_step = b.step("flash", "Flash firmware.bin to Blue Pill via st-flash");
    const flash_cmd = b.addSystemCommand(&.{
        "st-flash",
        "write",
    });
    flash_cmd.addFileArg(bin.getOutput());
    flash_cmd.addArg("0x08000000");
    flash_cmd.step.dependOn(&bin.step);
    flash_step.dependOn(&flash_cmd.step);

    // --- Flash via OpenOCD ---
    const openocd_step = b.step("openocd", "Flash firmware via OpenOCD");
    const openocd_cmd = b.addSystemCommand(&.{
        "openocd",
        "-f",
        "interface/stlink.cfg",
        "-f",
        "target/stm32f1x.cfg",
        "-c",
        "program zig-out/bin/firmware.bin verify reset exit 0x08000000",
    });
    openocd_cmd.step.dependOn(&install_bin.step);
    openocd_step.dependOn(&openocd_cmd.step);
}
