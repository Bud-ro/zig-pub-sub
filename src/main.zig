const std = @import("std");
const SystemData = @import("system_data.zig");
const SystemErds = @import("system_erds.zig");
const Pl011 = @import("hardware/pl011.zig");

// qemu arm virt target: https://www.qemu.org/docs/master/system/arm/virt.html
// From https://github.com/qemu/qemu/blob/master/hw/arm/virt.c
// Setup done using https://krinkinmu.github.io/2020/11/29/PL011.html
const debug_uart_virt: u64 = 0x09000000;

const ALIGN = 1 << 0;
const MEMINFO = 1 << 1;
const MB1_MAGIC: u32 = 0x1BADB002;
const FLAGS: u32 = ALIGN | MEMINFO;

const MultibootHeader = extern struct {
    magic: u32 = MB1_MAGIC,
    flags: u32,
    checksum: u32,
};

export var multiboot align(4) linksection(".multiboot") = MultibootHeader{
    .flags = FLAGS,
    .checksum = @intCast(((-(@as(i64, @intCast(MB1_MAGIC)) + @as(i64, @intCast(FLAGS)))) & 0xFFFFFFFF)),
};

pub export fn _start() noreturn {
    // var system_data = SystemData.init();
    // system_data.write(SystemErds.erd.application_version, 0x12345678);

    var serial = Pl011.init(debug_uart_virt, 24000000);
    serial.send("Hello world!\n");

    while (true) {
        // const new_app_version = system_data.read(SystemErds.erd.application_version) + 1;
        // system_data.write(SystemErds.erd.application_version, new_app_version);
        // var buf: [256]u8 = undefined;
        // const str = std.fmt.bufPrint(buf[0..], "0x{x}\n", .{new_app_version}) catch unreachable;
        // serial.send(str);
        // TODO: Timer Module run goes here!
    }
}
