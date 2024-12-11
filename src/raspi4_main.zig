const std = @import("std");
const SystemData = @import("system_data.zig");
const SystemErds = @import("system_erds.zig");
const TimerModule = @import("timer.zig").TimerModule;
const bcm2711 = @import("hardware/bcm2711_lpa.zig");

pub export fn main() void {
    var system_data = SystemData.init();
    var timer_module = TimerModule.init();
    system_data.write(SystemErds.erd.timer_module, &timer_module);

    bcm2711.peripherals.GPIO.GPFSEL2 |= (0b001 << 21); // Set GPIO 27 as output

    while (true) {
        // const no_timers_expired = !timer_module.run();
        // if (no_timers_expired) {
        //     asm volatile ("sleep");
        // }
        delay_cycles(5000000);
        bcm2711.peripherals.GPIO.GPSET0 |= 1 << 27;
        delay_cycles(5000000);
        bcm2711.peripherals.GPIO.GPCLR0 |= 1 << 27;
    }
}

fn delay_cycles(cycles: u32) void {
    var count: u32 = 0;
    while (count < cycles) : (count += 1) {
        asm volatile ("nop");
    }
}
