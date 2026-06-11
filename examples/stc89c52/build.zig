const std = @import("std");

/// Build configuration for the STC89C52RC (8051) firmware package.
/// Uses Zig's C backend to emit C, then compiles with SDCC for the mcs51 target.
pub fn build(b: *std.Build) void {
    // 8051 is not a native Zig target. Use the C backend with thumb as a
    // stand-in architecture -- the emitted C is architecture-neutral and will
    // be compiled by SDCC for mcs51.
    const c_target = b.resolveTargetQuery(.{
        .cpu_arch = .thumb,
        .os_tag = .freestanding,
        .abi = .none,
        .ofmt = .c,
    });

    const erd_core_dep = b.dependency("erd_core", .{
        .target = c_target,
        .optimize = .ReleaseSmall,
    });
    const erd_core_mod = erd_core_dep.module("erd_core");

    // Build elf-size tool for the host (used for memory reporting on .ihx)
    const elf_size_dep = b.dependency("elf_size", .{});
    _ = elf_size_dep;

    const mkdir = b.addSystemCommand(&.{ "mkdir", "-p", "zig-out" });
    mkdir.setCwd(b.path("."));

    // --- Zig -> C backend ---
    const obj = b.addObject(.{
        .name = "firmware",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = c_target,
            .optimize = .ReleaseSmall,
        }),
    });
    obj.root_module.addImport("erd_core", erd_core_mod);

    const c_output = obj.getEmittedBin();

    // --- Copy generated C into zig-out/ and patch for SDCC ---
    // The Zig C backend output includes `#include "zig.h"` and uses GCC
    // attributes/builtins that SDCC cannot parse.  We copy the file into
    // zig-out/ (where we can freely modify it) then run sed to:
    //   1. Replace `#include "zig.h"` with our minimal SDCC-compatible shim
    //   2. Fix `static void const` (Zig C backend bug)
    const copy_c = b.addSystemCommand(&.{ "cp", "-f" });
    copy_c.addFileArg(c_output);
    copy_c.addArgs(&.{"zig-out/firmware.c"});
    copy_c.setCwd(b.path("."));
    copy_c.step.dependOn(&mkdir.step);

    const patch_c = b.addSystemCommand(&.{
        "python3",
        "scripts/patch_c_for_sdcc.py",
        "zig-out/firmware.c",
    });
    patch_c.setCwd(b.path("."));
    patch_c.step.dependOn(&copy_c.step);

    // --- Compile Zig-generated C with SDCC ---
    const compile_c = b.addSystemCommand(&.{
        "sdcc",
        "-c",
        "--model-large",
        "--std-c99",
        "--stack-auto",
        "-mmcs51",
        "-Isrc",
        "zig-out/firmware.c",
        "-o",
        "zig-out/firmware.rel",
    });
    compile_c.setCwd(b.path("."));
    compile_c.step.dependOn(&patch_c.step);

    // --- Compile libc stubs with SDCC ---
    const compile_stubs = b.addSystemCommand(&.{
        "sdcc",
        "-c",
        "--model-large",
        "-mmcs51",
        "src/libc_stubs.c",
        "-o",
        "zig-out/libc_stubs.rel",
    });
    compile_stubs.setCwd(b.path("."));
    compile_stubs.step.dependOn(&mkdir.step);

    // --- Compile SFR access with SDCC ---
    const compile_sfr = b.addSystemCommand(&.{
        "sdcc",
        "-c",
        "--model-large",
        "-mmcs51",
        "src/sfr_access.c",
        "-o",
        "zig-out/sfr_access.rel",
    });
    compile_sfr.setCwd(b.path("."));
    compile_sfr.step.dependOn(&mkdir.step);

    // --- Link with SDCC (produces Intel HEX) ---
    // STC89C52RC: 8 KB flash, 256 B IRAM, 256+ B XRAM.
    // --model-small keeps pointers near (8-bit for IRAM) but large data
    // must live in XRAM.  The erd_core framework structures exceed IRAM
    // capacity so --stack-auto + generous XRAM allocation are required.
    const link = b.addSystemCommand(&.{
        "sdcc",
        "--model-large",
        "--stack-auto",
        "-mmcs51",
        "--code-loc",
        "0x0000",
        "--code-size",
        "0x10000",
        "--xram-loc",
        "0x0000",
        "--xram-size",
        "0x1000",
        "--iram-size",
        "0x0100",
        "-o",
        "zig-out/firmware.ihx",
        "zig-out/firmware.rel",
        "zig-out/libc_stubs.rel",
        "zig-out/sfr_access.rel",
    });
    link.setCwd(b.path("."));
    link.step.dependOn(&compile_c.step);
    link.step.dependOn(&compile_stubs.step);
    link.step.dependOn(&compile_sfr.step);

    b.getInstallStep().dependOn(&link.step);

    // --- Flash step ---
    const flash_step = b.step("flash", "Flash firmware to STC89C52RC via stcgal");
    const flash_cmd = b.addSystemCommand(&.{
        "stcgal",
        "-p",
        "/dev/ttyUSB0",
        "zig-out/firmware.ihx",
    });
    flash_cmd.setCwd(b.path("."));
    flash_cmd.step.dependOn(&link.step);
    flash_step.dependOn(&flash_cmd.step);
}
