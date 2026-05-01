const std = @import("std");

pub fn build(b: *std.Build) void {
    const zig_lib_path = b.graph.zig_lib_directory.path orelse ".";

    // Resolve dependency paths through the build system
    const erd_core_dep = b.dependency("erd_core", .{});
    const erd_core_root = erd_core_dep.path("src/root.zig").getPath(b);

    const sometimes_dep = erd_core_dep.builder.dependency("assert_sometimes", .{});
    const sometimes_root = sometimes_dep.path("src/sometimes.zig").getPath(b);

    // Build elf-size tool for the host (used for memory reports)
    const elf_size_dep = b.dependency("elf_size", .{});
    const elf_size_exe = elf_size_dep.artifact("elf-size");

    // --- SDK fetch ---
    const fetch_sdk = b.addSystemCommand(&.{
        "sh",                                                                                                           "-c",
        "[ -d sdk/lib ] || git clone --depth 1 --branch v2.2.1 https://github.com/espressif/ESP8266_NONOS_SDK.git sdk",
    });
    fetch_sdk.setCwd(b.path("."));

    // --- Zig -> C backend ---
    const mkdir = b.addSystemCommand(&.{ "mkdir", "-p", "zig-out" });

    const emit_c = b.addSystemCommand(&.{
        b.graph.zig_exe,
        "build-obj",
        "-target",
        "xtensa-freestanding-none",
        "-ofmt=c",
        "-OReleaseSmall",
        "-femit-bin=zig-out/firmware.c",
        "--dep",
        "erd_core",
        "-Mroot=src/main.zig",
        "--dep",
        "sometimes",
        "--dep",
        "erd_core",
    });
    emit_c.addPrefixedFileArg("-Merd_core=", .{ .cwd_relative = erd_core_root });
    emit_c.addArgs(&.{ "--dep", "sometimes_config" });
    emit_c.addPrefixedFileArg("-Msometimes=", .{ .cwd_relative = sometimes_root });
    emit_c.addArgs(&.{
        "-Msometimes_config=src/sometimes_config.zig",
        "--zig-lib-dir",
        zig_lib_path,
    });
    emit_c.setCwd(b.path("."));
    emit_c.step.dependOn(&mkdir.step);

    // --- Fix C backend void const issue ---
    const fix_void = b.addSystemCommand(&.{
        "sed",                                        "-i",
        "s/^static void const /static char const /g", "zig-out/firmware.c",
    });
    fix_void.setCwd(b.path("."));
    fix_void.step.dependOn(&emit_c.step);

    // --- Compile C ---
    const zig_h_include = std.fmt.allocPrint(b.allocator, "-I{s}", .{zig_lib_path}) catch @panic("OOM");

    const compile_c = b.addSystemCommand(&.{
        "xtensa-lx106-elf-gcc",
        "-c",
        "-Os",
        "-ffunction-sections",
        "-fdata-sections",
        "-mlongcalls",
        "-Wno-error",
        zig_h_include,
        "-Isdk/include",
        "zig-out/firmware.c",
        "-o",
        "zig-out/firmware.o",
    });
    compile_c.setCwd(b.path("."));
    compile_c.step.dependOn(&fix_void.step);
    compile_c.step.dependOn(&fetch_sdk.step);

    const compile_stubs = b.addSystemCommand(&.{
        "xtensa-lx106-elf-gcc",
        "-c",
        "-Os",
        "-mlongcalls",
        "src/libc_stubs.c",
        "-o",
        "zig-out/libc_stubs.o",
    });
    compile_stubs.setCwd(b.path("."));
    compile_stubs.step.dependOn(&mkdir.step);

    // --- Link ---
    const link = b.addSystemCommand(&.{
        "xtensa-lx106-elf-gcc",
        "-nostdlib",
        "-Wl,--gc-sections",
        "-Wl,--no-check-sections",
        "-T",
        "sdk/ld/eagle.app.v6.ld",
        "-o",
        "zig-out/firmware.elf",
        "zig-out/firmware.o",
        "zig-out/libc_stubs.o",
        "-Lsdk/lib",
        "-lmain",
        "-lwpa",
        "-lcrypto",
        "-lnet80211",
        "-lpp",
        "-lphy",
        "-llwip",
        "-ldriver",
        "-lc",
        "-lgcc",
        "-lmain",
        "-lwpa",
        "-lcrypto",
        "-lnet80211",
    });
    link.setCwd(b.path("."));
    link.step.dependOn(&compile_c.step);
    link.step.dependOn(&compile_stubs.step);
    link.step.dependOn(&fetch_sdk.step);

    // --- Memory report ---
    const mem_report = b.addRunArtifact(elf_size_exe);
    mem_report.setCwd(b.path("."));
    mem_report.addArgs(&.{
        "zig-out/firmware.elf",
        "--output",
        "zig-out/MEMORY_REPORT.txt",
        "RAM:3FFE8000:14000",
        "IRAM:40100000:8000",
        "FLASH:40210000:5C000",
    });
    mem_report.step.dependOn(&link.step);

    // --- ELF to flash image ---
    const elf2image = b.addSystemCommand(&.{
        "esptool",
        "--chip",
        "esp8266",
        "elf2image",
        "--version",
        "1",
        "--flash_mode",
        "dout",
        "--flash_size",
        "4MB",
        "zig-out/firmware.elf",
        "-o",
        "zig-out/firmware_",
    });
    elf2image.setCwd(b.path("."));
    elf2image.step.dependOn(&link.step);

    b.getInstallStep().dependOn(&elf2image.step);
    b.getInstallStep().dependOn(&mem_report.step);

    // --- Flash step ---
    const flash_step = b.step("flash", "Flash firmware to ESP8266 via esptool");
    const flash_cmd = b.addSystemCommand(&.{
        "esptool",
        "--port",
        "/dev/ttyUSB0",
        "--baud",
        "115200",
        "write_flash",
        "0x0",
        "zig-out/firmware_0x00000.bin",
        "0x10000",
        "zig-out/firmware_0x10000.bin",
        "0x3FB000",
        "sdk/bin/blank.bin",
        "0x3FC000",
        "sdk/bin/esp_init_data_default_v08.bin",
        "0x3FD000",
        "sdk/bin/blank.bin",
    });
    flash_cmd.setCwd(b.path("."));
    flash_cmd.step.dependOn(&elf2image.step);
    flash_step.dependOn(&flash_cmd.step);
}
