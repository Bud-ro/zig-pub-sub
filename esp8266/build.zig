const std = @import("std");

pub fn build(b: *std.Build) void {
    // Resolve dependency modules through the build system
    const xtensa_c_target = b.resolveTargetQuery(.{
        .cpu_arch = .xtensa,
        .os_tag = .freestanding,
        .abi = .none,
        .ofmt = .c,
    });

    const erd_core_dep = b.dependency("erd_core", .{
        .target = xtensa_c_target,
        .optimize = .ReleaseSmall,
    });
    const erd_core_mod = erd_core_dep.module("erd_core");

    // Build elf-size tool for the host
    const elf_size_dep = b.dependency("elf_size", .{});
    const elf_size_exe = elf_size_dep.artifact("elf-size");

    const mkdir = b.addSystemCommand(&.{ "mkdir", "-p", "zig-out" });
    mkdir.setCwd(b.path("."));

    // --- SDK fetch ---
    const fetch_sdk = b.addSystemCommand(&.{
        "sh",                                                                                                           "-c",
        "[ -d sdk/lib ] || git clone --depth 1 --branch v2.2.1 https://github.com/espressif/ESP8266_NONOS_SDK.git sdk",
    });
    fetch_sdk.setCwd(b.path("."));

    // --- Zig -> C backend via build system ---
    const obj = b.addObject(.{
        .name = "firmware",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = xtensa_c_target,
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

    // --- Compile C ---
    const zig_lib_path = b.graph.zig_lib_directory.path orelse ".";
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
    });
    compile_c.addFileArg(c_output);
    compile_c.addArgs(&.{ "-o", "zig-out/firmware.o" });
    compile_c.setCwd(b.path("."));
    compile_c.step.dependOn(&fix_void.step);
    compile_c.step.dependOn(&fetch_sdk.step);
    compile_c.step.dependOn(&mkdir.step);

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
        "-Wl,--start-group",
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
        "-Wl,--end-group",
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
        "FLASH (irom0):40210000:5C000",
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
