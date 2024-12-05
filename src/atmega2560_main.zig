const std = @import("std");
const SystemData = @import("system_data.zig");
const SystemErds = @import("system_erds.zig");
const TimerModule = @import("timer.zig").TimerModule;
const Application = @import("application/application.zig");
const Hardware = @import("hardware/hardware.zig");
const uart = @import("hardware/uart.zig");
const peripherals = @import("hardware/atmega2560.zig").peripherals;

pub fn main() void {
    var system_data = SystemData.init();
    var timer_module = TimerModule.init();
    system_data.write(SystemErds.erd.timer_module, &timer_module);

    var hardware: Hardware = undefined;
    hardware.init(&system_data);

    // Should be initted after hardware
    var application: Application = undefined;
    application.init(&system_data);

    // TODO: Figure out why my config is borked and UART prints wrong characters
    // uart.init(115200);
    // uart.write("All your codebase are belong to us!\r\n\r\n");

    while (true) {
        // delay_cycles(50000);
        // var data = peripherals.PORTB.*.PORTB;
        // data ^= 1 << 7;
        // peripherals.PORTB.*.PORTB = data;

        // _ = timer_module.run();
        asm volatile ("cli");
        _ = timer_module.run();
        asm volatile ("sei");
        // if (!timer_module.run()) {
        //     // Sleep
        //     // std.atomic.spinLoopHint();
        //     asm volatile ("sleep");
        // }
    }
}

fn delay_cycles(cycles: u32) void {
    var count: u32 = 0;
    while (count < cycles) : (count += 1) {
        asm volatile ("nop");
    }
}
