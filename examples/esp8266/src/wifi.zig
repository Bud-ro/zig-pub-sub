//! WiFi scanner module.
//! Puts the ESP8266 in station mode and performs a full channel scan every 10 seconds.
//! Results are printed to UART: SSID, channel, RSSI (dBm), and authentication mode.

const sdk = @import("sdk.zig");
const std = @import("std");
const uart = @import("uart.zig");

/// Initialize WiFi in station mode and kick off the first scan.
pub fn init() void {
    _ = sdk.wifi_set_opmode_current(sdk.STATION_MODE);

    uart.puts("WiFi station mode - starting scan\r\n");
    startScan();
}

fn startScan() void {
    _ = sdk.wifi_station_scan(null, onScanDone);
}

fn onScanDone(arg: ?*anyopaque, status: u32) callconv(sdk.cc) void {
    if (status != 0 or arg == null) {
        uart.puts("Scan failed\r\n");
        scheduleNextScan();
        return;
    }

    uart.puts("\r\n--- WiFi Scan Results ---\r\n");

    var entry: ?*sdk.BssInfo = @ptrCast(@alignCast(arg));
    // Skip the first entry (it's a list head with no data)
    if (entry) |e| entry = e.next;

    var count: u32 = 0;
    while (entry) |e| {
        count += 1;

        var ssid_len: usize = 0;
        while (ssid_len < 32 and e.ssid[ssid_len] != 0) : (ssid_len += 1) {}

        uart.puts("  ch");
        if (e.channel < 10) uart.putc(' ');
        uart.dec(e.channel);

        uart.puts("  ");
        uart.sdec(e.rssi);
        uart.puts("dBm  ");

        const auth_names = [_][]const u8{ "OPEN", "WEP ", "WPA ", "WPA2", "WPAX", "MAX " };
        const am = std.math.cast(usize, e.authmode) orelse auth_names.len;
        if (am < auth_names.len) {
            uart.puts(auth_names[am]);
        } else {
            uart.putc('?');
        }

        uart.puts("  ");
        if (ssid_len > 0) {
            uart.puts(e.ssid[0..ssid_len]);
        } else {
            uart.puts("(hidden)");
        }

        uart.puts("\r\n");
        entry = e.next;
    }

    uart.puts("Found ");
    uart.dec(count);
    uart.puts(" networks\r\n");

    scheduleNextScan();
}

var scan_timer: sdk.ETSTimer = std.mem.zeroes(sdk.ETSTimer);

fn scheduleNextScan() void {
    sdk.ets_timer_disarm(&scan_timer);
    sdk.ets_timer_setfn(&scan_timer, doScanTimer, null);
    sdk.timerArmMs(&scan_timer, 10000, false);
}

fn doScanTimer(_: ?*anyopaque) callconv(sdk.cc) void {
    startScan();
}
