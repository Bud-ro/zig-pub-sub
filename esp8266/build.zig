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
        "-OReleaseSafe",
        "-femit-bin=zig-out/blinky.c",
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
        zig_h_include,
        "zig-out/blinky.c",
        "-o",
        "zig-out/blinky.o",
    });
    compile_c.setCwd(b.path("."));
    compile_c.step.dependOn(&emit_c.step);

    const compile_stubs = b.addSystemCommand(&.{
        "xtensa-lx106-elf-gcc",
        "-c",
        "-Os",
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
        "-T",
        "esp8266.ld",
        "-o",
        "zig-out/blinky.elf",
        "zig-out/blinky.o",
        "zig-out/libc_stubs.o",
        "-lgcc",
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
        "1",
        "--flash_mode",
        "dout",
        "--flash_size",
        "4MB",
        "zig-out/blinky.elf",
        "-o",
        "zig-out/blinky_",
    });
    elf2image.setCwd(b.path("."));
    elf2image.step.dependOn(&link.step);

    b.getInstallStep().dependOn(&elf2image.step);

    const flash_step = b.step("flash", "Flash blinky to ESP8266 via esptool");
    const flash_cmd = b.addSystemCommand(&.{
        "esptool",
        "--port",
        "/dev/ttyUSB0",
        "--baud",
        "115200",
        "write_flash",
        "0x0",
        "zig-out/blinky_0x00000.bin",
    });
    flash_cmd.setCwd(b.path("."));
    flash_cmd.step.dependOn(&elf2image.step);
    flash_step.dependOn(&flash_cmd.step);
}
