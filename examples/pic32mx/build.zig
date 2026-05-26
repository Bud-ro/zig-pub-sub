const std = @import("std");

/// Build configuration for the PIC32MX270F256B firmware package.
///
/// Uses Zig's C backend (.ofmt = .c) targeting MIPS, then compiles with
/// mipsel-linux-gnu-gcc in bare-metal mode (-nostdlib -ffreestanding).
///
/// Targets:
///   zig build        - Build firmware ELF and memory report
///   zig build flash  - Program PIC32MX via pic32prog
pub fn build(b: *std.Build) void {
    const mips_c_target = b.resolveTargetQuery(.{
        .cpu_arch = .mipsel,
        .os_tag = .freestanding,
        .abi = .none,
        .ofmt = .c,
    });

    const erd_core_dep = b.dependency("erd_core", .{
        .target = mips_c_target,
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
            .target = mips_c_target,
            .optimize = .ReleaseSmall,
        }),
    });
    obj.root_module.addImport("erd_core", erd_core_mod);

    const c_output = obj.getEmittedBin();

    // --- Fix C backend void const issue ---
    const fix_void = b.addSystemCommand(&.{
        "sed", "-i", "s/^static void const /static char const /g",
    });
    fix_void.addFileArg(c_output);

    // --- Compile C with mipsel-linux-gnu-gcc ---
    // Use -nostdinc to avoid Linux glibc headers (we are bare-metal), then
    // add back GCC's own freestanding includes (stdarg.h) and zig.h's dir.
    const zig_lib_path = b.graph.zig_lib_directory.path orelse ".";

    const compile_c = b.addSystemCommand(&.{
        "sh", "-c",
        b.fmt(
            \\mipsel-linux-gnu-gcc -c -Os \
            \\  -ffunction-sections -fdata-sections \
            \\  -march=mips32r2 -msoft-float -EL -ffreestanding \
            \\  -mno-abicalls -fno-pic \
            \\  -nostdinc \
            \\  -isystem "$(mipsel-linux-gnu-gcc -print-file-name=include)" \
            \\  -isystem include \
            \\  -I{s} \
            \\  "$1" -o zig-out/firmware.o
        , .{zig_lib_path}),
        "--",
    });
    compile_c.addFileArg(c_output);
    compile_c.setCwd(b.path("."));
    compile_c.step.dependOn(&fix_void.step);
    compile_c.step.dependOn(&mkdir.step);

    const compile_stubs = b.addSystemCommand(&.{
        "mipsel-linux-gnu-gcc",
        "-c",
        "-Os",
        "-march=mips32r2",
        "-msoft-float",
        "-EL",
        "-ffreestanding",
        "-mno-abicalls",
        "-fno-pic",
        "src/libc_stubs.c",
        "-o",
        "zig-out/libc_stubs.o",
    });
    compile_stubs.setCwd(b.path("."));
    compile_stubs.step.dependOn(&mkdir.step);

    // --- Assemble startup code ---
    const compile_crt0 = b.addSystemCommand(&.{
        "mipsel-linux-gnu-gcc",
        "-c",
        "-march=mips32r2",
        "-msoft-float",
        "-EL",
        "-mno-abicalls",
        "-fno-pic",
        "src/crt0.S",
        "-o",
        "zig-out/crt0.o",
    });
    compile_crt0.setCwd(b.path("."));
    compile_crt0.step.dependOn(&mkdir.step);

    // --- Link ---
    const link = b.addSystemCommand(&.{
        "mipsel-linux-gnu-gcc",
        "-nostdlib",
        "-nostartfiles",
        "-ffreestanding",
        "-Wl,--gc-sections",
        "-march=mips32r2",
        "-msoft-float",
        "-EL",
        "-Wl,-T,pic32mx.ld",
        "-o",
        "zig-out/firmware.elf",
        "zig-out/crt0.o",
        "zig-out/firmware.o",
        "zig-out/libc_stubs.o",
    });
    link.setCwd(b.path("."));
    link.step.dependOn(&compile_c.step);
    link.step.dependOn(&compile_stubs.step);
    link.step.dependOn(&compile_crt0.step);

    // --- Memory report ---
    const mem_report = b.addRunArtifact(elf_size_exe);
    mem_report.setCwd(b.path("."));
    mem_report.addArgs(&.{
        "zig-out/firmware.elf",
        "--output",
        "zig-out/MEMORY_REPORT.txt",
        "FLASH:9D000000:40000",
        "RAM:A0000000:10000",
        "BOOT:BFC00000:C00",
    });
    mem_report.step.dependOn(&link.step);

    // --- ELF to Intel HEX ---
    const objcopy = b.addSystemCommand(&.{
        "mipsel-linux-gnu-objcopy",
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
    const flash_step = b.step("flash", "Program PIC32MX via pic32prog");
    const flash_cmd = b.addSystemCommand(&.{
        "pic32prog",
        "-d",
        "/dev/ttyUSB0",
        "zig-out/firmware.hex",
    });
    flash_cmd.setCwd(b.path("."));
    flash_cmd.step.dependOn(&objcopy.step);
    flash_step.dependOn(&flash_cmd.step);
}
