//! ESP8266 firmware entry point.
//! The SDK calls `user_init` after ROM and RF calibration. We split init into
//! Hardware (GPIO, peripherals) and Application (erd_core wiring, timers),
//! then register `on_system_ready` for post-SDK-init work like WiFi.

const application = @import("application.zig");
const hardware = @import("hardware.zig");
const sdk = @import("sdk.zig");
const uart = @import("uart.zig");
const wifi = @import("wifi.zig");

var app: application.Application = undefined;

fn on_system_ready() callconv(sdk.cc) void {
    wifi.init();
    application.init(&app);
    uart.puts("System ready\r\n");
}

/// SDK 2.2.1 entry point: returns the flash sector used for RF calibration data.
/// Sector 0x3FB = byte offset 0x3FB000, near end of 4MB flash.
export fn user_rf_cal_sector_set() u32 {
    return 0x3FB;
}

export fn user_init() void {
    hardware.init();
    uart.puts("Hardware initialized\r\n");
    sdk.system_init_done_cb(on_system_ready);
}
