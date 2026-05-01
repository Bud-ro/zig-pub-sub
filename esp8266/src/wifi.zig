const std = @import("std");
const sdk = @import("sdk.zig");
const application = @import("application.zig");

const UART0_FIFO: *volatile u32 = @ptrFromInt(0x60000000);
const UART0_STATUS: *volatile u32 = @ptrFromInt(0x60000004);

fn uart_putc(c: u8) void {
    while ((UART0_STATUS.* >> 16) & 0xFF >= 126) {}
    UART0_FIFO.* = c;
}

fn uart_puts(s: []const u8) void {
    for (s) |c| uart_putc(c);
}

fn uart_dec(val: u32) void {
    if (val == 0) {
        uart_putc('0');
        return;
    }
    var buf: [10]u8 = undefined;
    var n = val;
    var i: u8 = 0;
    while (n > 0) : (i += 1) {
        buf[i] = @truncate(n % 10 + '0');
        n /= 10;
    }
    while (i > 0) {
        i -= 1;
        uart_putc(buf[i]);
    }
}

fn uart_sdec(val: i32) void {
    if (val < 0) {
        uart_putc('-');
        uart_dec(@intCast(-val));
    } else {
        uart_dec(@intCast(val));
    }
}

pub fn init(app: *application.Application) void {
    _ = app;

    _ = sdk.wifi_set_opmode_current(sdk.STATION_MODE);

    uart_puts("WiFi station mode - starting scan\r\n");
    start_scan();
}

fn start_scan() void {
    _ = sdk.wifi_station_scan(null, on_scan_done);
}

fn on_scan_done(arg: ?*anyopaque, status: u32) callconv(sdk.cc) void {
    if (status != 0 or arg == null) {
        uart_puts("Scan failed\r\n");
        schedule_next_scan();
        return;
    }

    uart_puts("\r\n--- WiFi Scan Results ---\r\n");

    var entry: ?*sdk.BssInfo = @ptrCast(@alignCast(arg));
    // Skip the first entry (it's a list head with no data)
    if (entry) |e| entry = e.next;

    var count: u32 = 0;
    while (entry) |e| {
        count += 1;

        // SSID
        var ssid_len: usize = 0;
        while (ssid_len < 32 and e.ssid[ssid_len] != 0) : (ssid_len += 1) {}

        // Channel
        uart_puts("  ch");
        if (e.channel < 10) uart_putc(' ');
        uart_dec(e.channel);

        // RSSI
        uart_puts("  ");
        uart_sdec(e.rssi);
        uart_puts("dBm  ");

        // Auth mode
        const auth_names = [_][]const u8{ "OPEN", "WEP ", "WPA ", "WPA2", "WPAX", "MAX " };
        const am: usize = @intCast(e.authmode);
        if (am < auth_names.len) {
            uart_puts(auth_names[am]);
        } else {
            uart_putc('?');
        }

        // SSID
        uart_puts("  ");
        if (ssid_len > 0) {
            uart_puts(e.ssid[0..ssid_len]);
        } else {
            uart_puts("(hidden)");
        }

        uart_puts("\r\n");
        entry = e.next;
    }

    uart_puts("Found ");
    uart_dec(count);
    uart_puts(" networks\r\n");

    schedule_next_scan();
}

var scan_timer: sdk.ETSTimer = std.mem.zeroes(sdk.ETSTimer);

fn schedule_next_scan() void {
    sdk.ets_timer_disarm(&scan_timer);
    sdk.ets_timer_setfn(&scan_timer, do_scan_timer, null);
    sdk.timer_arm_ms(&scan_timer, 10000, false);
}

fn do_scan_timer(_: ?*anyopaque) callconv(sdk.cc) void {
    start_scan();
}
