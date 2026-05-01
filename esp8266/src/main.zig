const std = @import("std");
const sdk = @import("sdk.zig");
const hardware = @import("hardware.zig");
const application = @import("application.zig");
const wifi = @import("wifi.zig");
const http_server = @import("http_server.zig");

const UART0_FIFO: *volatile u32 = @ptrFromInt(0x60000000);
const UART0_STATUS: *volatile u32 = @ptrFromInt(0x60000004);

fn uart_putc(c: u8) void {
    while ((UART0_STATUS.* >> 16) & 0xFF >= 126) {}
    UART0_FIFO.* = c;
}

fn uart_puts(s: []const u8) void {
    for (s) |c| uart_putc(c);
}

var app: application.Application = undefined;

fn on_system_ready() callconv(sdk.cc) void {
    uart_puts("System ready\r\n");
    wifi.init(&app);
    application.start(&app);
}

export fn user_rf_cal_sector_set() u32 {
    return 0x3FB;
}

export fn user_init() void {
    hardware.init();
    app = application.init();
    uart_puts("Hardware + Application initialized\r\n");
    sdk.system_init_done_cb(on_system_ready);
}
