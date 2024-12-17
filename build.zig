const std = @import("std");
const CpuModel = std.Target.Cpu.Model;

pub fn build(b: *std.Build) void {
    const host_target = b.standardTargetOptions(.{});

    // TODO: Use the actual target once the std library catches up
    // Xtensa LX106, see esp8266.zig for more
    const esp8266 = std.Target.Query{
        .cpu_arch = .xtensa,
        .cpu_model = .baseline,
        .os_tag = .freestanding,
        .abi = .none,
        .ofmt = .c,
    };

    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "zig-pub-sub-esp8266",
        .root_source_file = b.path("src/main_esp8266.zig"),
        .target = b.resolveTargetQuery(esp8266),
        .optimize = optimize,
    });

    b.installArtifact(lib);

    b.addSystemCommand(&.{""});

    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/unit_tests.zig"),
        .target = host_target,
        .optimize = optimize,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);

    // Executable that does not install itself, and hence avoids the LLVM step
    const exe_check = b.addExecutable(.{
        .name = "zig-pub-sub-esp8266.elf",
        .root_source_file = b.path("src/main_esp8266.zig"),
        .target = b.resolveTargetQuery(esp8266),
        .optimize = optimize,
    });

    // The step "check" comes from the zls config `zls --show-config-path`
    const check = b.step("check", "Check if foo compiles");
    check.dependOn(&exe_check.step);
}
