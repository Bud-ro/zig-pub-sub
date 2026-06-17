const std = @import("std");

/// Build configuration for the RL78/G14 firmware package.
///
/// RL78 is a 16-bit Renesas architecture with no LLVM backend, so we use
/// Zig's C backend (.ofmt = .c) to emit C, then compile with rl78-elf-gcc.
/// This follows the same approach as the esp8266 package.
///
/// Targets:
///   zig build       - Build firmware ELF, Intel HEX, and memory report
///   zig build flash - Flash via rl78flash
pub fn build(b: *std.Build) void {
    // Use Thumb as the C emission target -- the generated C is portable,
    // rl78-elf-gcc compiles it for the actual RL78 architecture.
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

    // Build elf-size tool for the host
    const elf_size_dep = b.dependency("elf_size", .{});
    const elf_size_exe = elf_size_dep.artifact("elf-size");

    const mkdir = b.addSystemCommand(&.{ "mkdir", "-p", "zig-out" });
    mkdir.setCwd(b.path("."));

    // --- Zig -> C backend via build system ---
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

    // --- Fix C backend issues for cross-architecture compilation ---
    // 1. Replace `static void const` (Zig C backend limitation)
    // 2. Disable static alignment assertions (they reflect the proxy
    //    target's layout, not RL78's, and will fail on 16-bit)
    const fix_c = b.addSystemCommand(&.{
        "sed", "-i",
        "-e",  "s/^static void const /static char const /g",
        "-e",  "/zig_static_assert/d",
    });
    fix_c.addFileArg(c_output);

    // --- Compile C ---
    const zig_lib_path = b.graph.zig_lib_directory.path orelse ".";
    const zig_h_include = std.fmt.allocPrint(b.allocator, "-I{s}", .{zig_lib_path}) catch @panic("OOM");

    const compile_c = b.addSystemCommand(&.{
        "sh", "-c",
        std.fmt.allocPrint(b.allocator,
            \\set -e
            \\GCC_INC=$(rl78-elf-gcc -print-file-name=include)
            \\rl78-elf-gcc -c -Os -ffreestanding -nostdinc \
            \\  -ffunction-sections -fdata-sections \
            \\  -Wno-error -Wno-builtin-declaration-mismatch -Wno-overflow \
            \\  -isystem "$GCC_INC" \
            \\  {s} \
            \\  "$1" -o zig-out/firmware.o
        , .{zig_h_include}) catch @panic("OOM"),
    });
    compile_c.addArg("--");
    compile_c.addFileArg(c_output);
    compile_c.setCwd(b.path("."));
    compile_c.step.dependOn(&fix_c.step);
    compile_c.step.dependOn(&mkdir.step);

    const compile_stubs = b.addSystemCommand(&.{
        "rl78-elf-gcc",
        "-c",
        "-Os",
        "src/libc_stubs.c",
        "-o",
        "zig-out/libc_stubs.o",
    });
    compile_stubs.setCwd(b.path("."));
    compile_stubs.step.dependOn(&mkdir.step);

    // --- Link ---
    const link = b.addSystemCommand(&.{
        "rl78-elf-gcc",
        "-nostdlib",
        "-Wl,--gc-sections",
        "-T",
        "rl78.ld",
        "-o",
        "zig-out/firmware.elf",
        "zig-out/firmware.o",
        "zig-out/libc_stubs.o",
        "-lgcc",
    });
    link.setCwd(b.path("."));
    link.step.dependOn(&compile_c.step);
    link.step.dependOn(&compile_stubs.step);

    // --- Memory report ---
    const mem_report = b.addRunArtifact(elf_size_exe);
    mem_report.setCwd(b.path("."));
    mem_report.addArgs(&.{
        "zig-out/firmware.elf",
        "--output",
        "zig-out/MEMORY_REPORT.txt",
        "FLASH:000D0:1FF30",
        "RAM:FCF00:3000",
    });
    mem_report.step.dependOn(&link.step);

    // --- Create Intel HEX for flashing ---
    const objcopy = b.addSystemCommand(&.{
        "rl78-elf-objcopy",
        "-O",
        "ihex",
        "zig-out/firmware.elf",
        "zig-out/firmware.hex",
    });
    objcopy.setCwd(b.path("."));
    objcopy.step.dependOn(&link.step);

    b.getInstallStep().dependOn(&objcopy.step);
    b.getInstallStep().dependOn(&mem_report.step);

    // --- Flash step ---
    const flash_step = b.step("flash", "Flash firmware to RL78 via rl78flash");
    const flash_cmd = b.addSystemCommand(&.{
        "rl78flash",
        "-m3",
        "/dev/ttyUSB0",
        "zig-out/firmware.hex",
    });
    flash_cmd.setCwd(b.path("."));
    flash_cmd.step.dependOn(&objcopy.step);
    flash_step.dependOn(&flash_cmd.step);
}
