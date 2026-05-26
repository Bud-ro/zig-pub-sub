const std = @import("std");

/// Build configuration for the RX130 bare-metal firmware package.
/// Uses Zig's C backend (.ofmt = .c) with rx-elf-gcc as the external toolchain,
/// following the same pattern as the esp8266 package.
pub fn build(b: *std.Build) void {
    // RX is not an LLVM target; emit C via the Zig C backend, then compile
    // with rx-elf-gcc. We use .thumb as a stand-in architecture since the
    // generated C is architecture-agnostic.
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
            \\GCC_INC=$(rx-elf-gcc -print-file-name=include)
            \\rx-elf-gcc -c -Os -ffreestanding -nostdinc \
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
        "rx-elf-gcc",
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
        "rx-elf-gcc",
        "-nostdlib",
        "-Wl,--gc-sections",
        "-T",
        "rx130.ld",
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
        "RAM:00000000:8000",
        "FLASH:FFFC0000:3FF00",
    });
    mem_report.step.dependOn(&link.step);

    // --- Motorola S-record for Renesas flash tools ---
    const objcopy = b.addSystemCommand(&.{
        "rx-elf-objcopy",
        "-O",
        "srec",
        "zig-out/firmware.elf",
        "zig-out/firmware.mot",
    });
    objcopy.setCwd(b.path("."));
    objcopy.step.dependOn(&link.step);

    b.getInstallStep().dependOn(&objcopy.step);
    b.getInstallStep().dependOn(&mem_report.step);

    // --- Flash step ---
    const flash_step = b.step("flash", "Flash firmware to RX130 via rx-elf-objcopy S-record");
    flash_step.dependOn(&objcopy.step);
}
