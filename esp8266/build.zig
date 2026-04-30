const std = @import("std");

pub fn build(b: *std.Build) void {
    const zig_lib_path = b.graph.zig_lib_directory.path orelse ".";

    const mkdir = b.addSystemCommand(&.{ "mkdir", "-p", "zig-out" });

    const emit_c = b.addSystemCommand(&.{
        b.graph.zig_exe,
        "build-obj",
        "-target",
        "xtensa-freestanding-none",
        "-ofmt=c",
        "-OReleaseSmall",
        "-femit-bin=zig-out/firmware.c",
        "src/main.zig",
        "--zig-lib-dir",
        zig_lib_path,
    });
    emit_c.setCwd(b.path("."));
    emit_c.step.dependOn(&mkdir.step);

    const zig_h_include = std.fmt.allocPrint(b.allocator, "-I{s}", .{zig_lib_path}) catch @panic("OOM");

    const compile_c = b.addSystemCommand(&.{
        "xtensa-lx106-elf-gcc",
        "-c",
        "-Os",
        "-ffunction-sections",
        "-fdata-sections",
        "-mlongcalls",
        zig_h_include,
        "-Isdk/include",
        "zig-out/firmware.c",
        "-o",
        "zig-out/firmware.o",
    });
    compile_c.setCwd(b.path("."));
    compile_c.step.dependOn(&emit_c.step);

    const compile_stubs = b.addSystemCommand(&.{
        "xtensa-lx106-elf-gcc",
        "-c",
        "-Os",
        "-Isdk/include",
        "src/libc_stubs.c",
        "-o",
        "zig-out/libc_stubs.o",
    });
    compile_stubs.setCwd(b.path("."));
    compile_stubs.step.dependOn(&mkdir.step);

    const link = b.addSystemCommand(&.{
        "xtensa-lx106-elf-gcc",
        "-nostdlib",
        "-Wl,--gc-sections",
        "-Wl,--no-check-sections",
        "-T",
        "esp8266.ld",
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
        "-lhal",
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

    const elf2image = b.addSystemCommand(&.{
        "esptool",
        "--chip",
        "esp8266",
        "elf2image",
        "--version",
        "2",
        "--flash_mode",
        "dout",
        "--flash_size",
        "4MB",
        "--flash_freq",
        "40m",
        "zig-out/firmware.elf",
        "-o",
        "zig-out/firmware_",
    });
    elf2image.setCwd(b.path("."));
    elf2image.step.dependOn(&link.step);

    b.getInstallStep().dependOn(&elf2image.step);

    const flash_step = b.step("flash", "Flash firmware to ESP8266 via esptool");
    const flash_cmd = b.addSystemCommand(&.{
        "esptool",
        "--port",
        "/dev/ttyUSB0",
        "--baud",
        "115200",
        "write_flash",
        "-fs", "4MB",
        "-fm", "dout",
        "0x0",
        "sdk/bin/boot_v1.7.bin",
        "0x1000",
        "zig-out/firmware_",
        "0x3FB000",
        "sdk/bin/blank.bin",
        "0x3FC000",
        "sdk/bin/esp_init_data_default_v08.bin",
        "0x3FD000",
        "sdk/bin/blank.bin",
        "0x3FE000",
        "sdk/bin/blank.bin",
        "0x3FF000",
        "sdk/bin/blank.bin",
    });
    flash_cmd.setCwd(b.path("."));
    flash_cmd.step.dependOn(&elf2image.step);
    flash_step.dependOn(&flash_cmd.step);
}
