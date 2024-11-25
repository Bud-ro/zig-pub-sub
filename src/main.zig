const std = @import("std");
const SystemData = @import("system_data.zig");
const SystemErds = @import("system_erds.zig");
const Pl011 = @import("hardware/pl011.zig");

// qemu arm virt target: https://www.qemu.org/docs/master/system/arm/virt.html
// From https://github.com/qemu/qemu/blob/master/hw/arm/virt.c
// Setup done using https://krinkinmu.github.io/2020/11/29/PL011.html
const debug_uart_virt: u64 = 0x09000000;

pub export fn main() noreturn {
    var system_data = SystemData.init();
    system_data.write(SystemErds.erd.application_version, 0x12345678);

    var serial = Pl011.init(0x09000000, 24000000);
    serial.send("Hello world!\n");

    while (true) {
        // const new_app_version = system_data.read(SystemErds.erd.application_version) + 1;
        // system_data.write(SystemErds.erd.application_version, new_app_version);
        // var buf: [256]u8 = undefined;
        // const str = std.fmt.bufPrint(buf[0..], "{}\n", .{new_app_version}) catch unreachable;
        // serial.send(str);
        // TODO: Timer Module run goes here!
    }
}
