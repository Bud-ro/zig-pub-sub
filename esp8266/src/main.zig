const std = @import("std");
const sdk = @import("sdk.zig");
const hardware = @import("hardware.zig");

const UART0_FIFO: *volatile u32 = @ptrFromInt(0x60000000);
const UART0_STATUS: *volatile u32 = @ptrFromInt(0x60000004);

fn uart_putc(c: u8) void {
    while ((UART0_STATUS.* >> 16) & 0xFF >= 126) {}
    UART0_FIFO.* = c;
}

fn uart_puts(s: []const u8) void {
    for (s) |c| uart_putc(c);
}

var led_state: bool = false;
var blink_timer: sdk.ETSTimer = undefined;

fn blink_callback(_: ?*anyopaque) callconv(sdk.cc) void {
    led_state = !led_state;
    hardware.set_led(led_state);
}

fn on_system_ready() callconv(sdk.cc) void {
    uart_puts("System ready!\r\n");

    blink_timer = std.mem.zeroes(sdk.ETSTimer);
    sdk.ets_timer_setfn(&blink_timer, blink_callback, null);
    sdk.timer_arm_ms(&blink_timer, 500, true);

    uart_puts("LED blink timer started (500ms)\r\n");
}

export fn user_rf_cal_sector_set() u32 {
    return 0x3FB;
}

export fn user_init() void {
    hardware.init();
    uart_puts("Hardware initialized\r\n");
    sdk.system_init_done_cb(on_system_ready);
}
