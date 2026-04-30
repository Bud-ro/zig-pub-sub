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

fn uart_ip(addr: u32) void {
    uart_dec(addr & 0xFF);
    uart_putc('.');
    uart_dec((addr >> 8) & 0xFF);
    uart_putc('.');
    uart_dec((addr >> 16) & 0xFF);
    uart_putc('.');
    uart_dec((addr >> 24) & 0xFF);
}

pub fn init(app: *application.Application) void {
    var ap_config: sdk.SoftApConfig = std.mem.zeroes(sdk.SoftApConfig);
    const ssid = "ZigPubSub";
    @memcpy(ap_config.ssid[0..ssid.len], ssid);
    ap_config.ssid_len = ssid.len;
    ap_config.channel = 6;
    ap_config.authmode = 0;
    ap_config.max_connection = 4;
    ap_config.beacon_interval = 100;

    _ = sdk.wifi_set_opmode_current(sdk.SOFTAP_MODE);
    _ = sdk.wifi_softap_set_config_current(&ap_config);

    var ip_info: sdk.IpInfo = undefined;
    if (sdk.wifi_get_ip_info(sdk.SOFTAP_IF, &ip_info)) {
        uart_puts("WiFi AP: ZigPubSub @ ");
        uart_ip(ip_info.ip.addr);
        uart_puts("\r\n");
        app.system_data.write(.erd_wifi_ip_addr, ip_info.ip.addr);
    }
}
