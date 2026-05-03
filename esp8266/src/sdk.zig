//! Zig declarations for the ESP8266 NonOS SDK 2.2.1.
//! These extern functions and struct layouts are hand-written to match the C headers
//! in `sdk/include/`. C enums are 4 bytes on Xtensa; padding fields are inserted
//! where the C ABI requires alignment that Zig's extern struct layout wouldn't
//! otherwise provide.

const std = @import("std");

/// Xtensa windowed-register calling convention used by all SDK callbacks.
pub const cc: std.builtin.CallingConvention = .{ .xtensa_call0 = .{} };

// ---- Timers (ets_sys.h / osapi.h) ----

/// Software timer managed by the SDK's timer list. Must be zeroed before first use.
/// Corresponds to `ETSTimer` / `os_timer_t` in the SDK.
pub const ETSTimer = extern struct {
    timer_next: ?*ETSTimer,
    timer_expire: u32,
    timer_period: u32,
    timer_func: ?*const fn (?*anyopaque) callconv(cc) void, // zlinter-disable-current-line field_naming
    timer_arg: ?*anyopaque,
};

/// Register a callback for a software timer.
pub extern fn ets_timer_setfn(ptimer: *ETSTimer, pfunction: *const fn (?*anyopaque) callconv(cc) void, parg: ?*anyopaque) void;

/// Arm a timer. `ms_flag`: true = milliseconds, false = microseconds.
pub extern fn ets_timer_arm_new(ptimer: *ETSTimer, time: u32, repeat_flag: bool, ms_flag: bool) void;

/// Stop a running timer.
pub extern fn ets_timer_disarm(ptimer: *ETSTimer) void;

/// Convenience wrapper: arm a timer in milliseconds.
pub fn timer_arm_ms(ptimer: *ETSTimer, ms: u32, repeat: bool) void {
    ets_timer_arm_new(ptimer, ms, repeat, true);
}

// ---- System (user_interface.h) ----

/// Register a callback that fires once the SDK has fully initialized
/// (WiFi, lwIP, etc). WiFi operations must not be called before this.
pub extern fn system_init_done_cb(cb: *const fn () callconv(cc) void) void;

/// Microseconds since boot (wraps at ~71 minutes).
pub extern fn system_get_time() u32;

/// Software reset.
pub extern fn system_restart() void;

// ---- WiFi mode (user_interface.h) ----

pub const STATION_MODE: u8 = 0x01;
pub const SOFTAP_MODE: u8 = 0x02;
pub const STATIONAP_MODE: u8 = 0x03;

pub const STATION_IF: u8 = 0;
pub const SOFTAP_IF: u8 = 1;

/// Station connection status values from `wifi_station_get_connect_status()`.
pub const STATION_IDLE: u8 = 0;
pub const STATION_CONNECTING: u8 = 1;
pub const STATION_CONNECT_FAIL: u8 = 4;
pub const STATION_GOT_IP: u8 = 5;

/// Set WiFi operating mode and persist to flash.
pub extern fn wifi_set_opmode(opmode: u8) bool;

/// Set WiFi operating mode for this boot only.
pub extern fn wifi_set_opmode_current(opmode: u8) bool;

// ---- WiFi station (user_interface.h) ----

/// Station configuration. Mirrors `struct station_config` from the SDK.
pub const StationConfig = extern struct {
    ssid: [32]u8,
    password: [64]u8,
    channel: u8,
    bssid_set: u8,
    bssid: [6]u8,
    threshold_rssi: i8,
    threshold_authmode: u8,
    open_and_wep_mode_disable: u8,
    all_channel_scan: u8,
};

pub extern fn wifi_station_set_config(config: *StationConfig) bool;
pub extern fn wifi_station_set_config_current(config: *StationConfig) bool;
pub extern fn wifi_station_connect() bool;
pub extern fn wifi_station_disconnect() bool;
pub extern fn wifi_station_get_connect_status() u8;

// ---- WiFi soft-AP (user_interface.h) ----

/// Soft-AP configuration. Mirrors `struct softap_config` from the SDK.
/// `authmode` is `AUTH_MODE` (C enum = 4 bytes); `_pad0` aligns it.
pub const SoftApConfig = extern struct {
    ssid: [32]u8,
    password: [64]u8,
    ssid_len: u8,
    channel: u8,
    _pad0: [2]u8 = .{ 0, 0 },
    authmode: u32,
    ssid_hidden: u8,
    max_connection: u8,
    beacon_interval: u16,
};

pub extern fn wifi_softap_set_config(config: *SoftApConfig) bool;
pub extern fn wifi_softap_set_config_current(config: *SoftApConfig) bool;

// ---- IP info (user_interface.h) ----

pub const IpAddr = extern struct {
    addr: u32,
};

pub const IpInfo = extern struct {
    ip: IpAddr,
    netmask: IpAddr,
    gw: IpAddr,
};

/// Get IP info for an interface. `if_index`: `STATION_IF` or `SOFTAP_IF`.
pub extern fn wifi_get_ip_info(if_index: u8, info: *IpInfo) bool;

// ---- WiFi scan (user_interface.h) ----

pub const ScanDoneCb = *const fn (?*anyopaque, u32) callconv(cc) void;

/// Start an async WiFi scan. Results delivered via callback as a linked list of `BssInfo`.
/// Pass `null` for config to scan all channels/SSIDs.
pub extern fn wifi_station_scan(config: ?*anyopaque, cb: ScanDoneCb) bool;

/// One entry in the scan result linked list. Mirrors `struct bss_info` from the SDK.
/// The first entry in the callback's list is a head node with no data — skip it.
/// `authmode` is `AUTH_MODE` (C enum = 4 bytes); padding fields maintain alignment.
pub const BssInfo = extern struct {
    next: ?*BssInfo,
    bssid: [6]u8,
    ssid: [32]u8,
    ssid_len: u8,
    channel: u8,
    rssi: i8,
    _pad0: u8 = 0,
    authmode: u32,
    is_hidden: u8,
    _pad1: u8 = 0,
    freq_offset: i16,
    freqcal_val: i16,
    _pad2: [2]u8 = .{ 0, 0 },
    esp_mesh_ie: ?*anyopaque,
};

// ---- SPI flash (spi_flash.h) ----

pub extern fn spi_flash_read(src_addr: u32, des_addr: *anyopaque, size: u32) u32;
pub extern fn spi_flash_write(des_addr: u32, src_addr: *const anyopaque, size: u32) u32;
pub extern fn spi_flash_erase_sector(sector: u16) u32;
