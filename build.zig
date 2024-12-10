const std = @import("std");

pub fn build(b: *std.Build) void {
    const host_target = b.standardTargetOptions(.{});

    const raspi4 = std.Target.Query{
        .cpu_arch = .aarch64,
        .cpu_model = .{ .explicit = &std.Target.aarch64.cpu.cortex_a72 },
        .os_tag = .freestanding,
        .abi = .none,
    };

    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zig-pub-sub-raspi4.elf",
        .root_source_file = b.path("src/raspi4_main.zig"),
        .target = b.resolveTargetQuery(raspi4),
        .optimize = optimize,
    });

    exe.setLinkerScript(.{ .cwd_relative = "raspi4.ld" });
    exe.addAssemblyFile(.{ .cwd_relative = "src/hardware/boot.s" });

    b.installArtifact(exe);

    const kernel = exe.addObjCopy(.{
        .basename = "kernel8.img",
        .format = .bin,
    });
    const kernel_install = b.addInstallBinFile(kernel.getOutput(), "kernel8.img");
    kernel_install.step.dependOn(&kernel.step);

    b.default_step.dependOn(&kernel_install.step);

    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/unit_tests.zig"),
        .target = host_target,
        .optimize = optimize,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
}
