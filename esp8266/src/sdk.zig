const std = @import("std");
pub const cc: std.builtin.CallingConvention = .{ .xtensa_call0 = .{} };

pub const ETSTimer = extern struct {
    timer_next: ?*ETSTimer,
    timer_expire: u32,
    timer_period: u32,
    timer_func: ?*const fn (?*anyopaque) callconv(cc) void,
    timer_arg: ?*anyopaque,
};

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

pub const IpAddr = extern struct {
    addr: u32,
};

pub const IpInfo = extern struct {
    ip: IpAddr,
    netmask: IpAddr,
    gw: IpAddr,
};

pub const STATION_MODE: u8 = 0x01;
pub const SOFTAP_MODE: u8 = 0x02;
pub const STATIONAP_MODE: u8 = 0x03;

pub const STATION_IF: u8 = 0;
pub const SOFTAP_IF: u8 = 1;

pub const STATION_GOT_IP: u8 = 5;
pub const STATION_CONNECTING: u8 = 1;
pub const STATION_CONNECT_FAIL: u8 = 4;
pub const STATION_IDLE: u8 = 0;

pub extern fn ets_timer_setfn(ptimer: *ETSTimer, pfunction: *const fn (?*anyopaque) callconv(cc) void, parg: ?*anyopaque) void;
pub extern fn ets_timer_arm_new(ptimer: *ETSTimer, time: u32, repeat_flag: bool, ms_flag: bool) void;
pub extern fn ets_timer_disarm(ptimer: *ETSTimer) void;

pub extern fn system_init_done_cb(cb: *const fn () callconv(cc) void) void;
pub extern fn system_get_time() u32;
pub extern fn system_restart() void;

pub extern fn wifi_set_opmode(opmode: u8) bool;
pub extern fn wifi_set_opmode_current(opmode: u8) bool;
pub extern fn wifi_station_set_config(config: *StationConfig) bool;
pub extern fn wifi_station_set_config_current(config: *StationConfig) bool;
pub extern fn wifi_station_connect() bool;
pub extern fn wifi_station_disconnect() bool;
pub extern fn wifi_station_get_connect_status() u8;
pub extern fn wifi_softap_set_config(config: *SoftApConfig) bool;
pub extern fn wifi_softap_set_config_current(config: *SoftApConfig) bool;
pub extern fn wifi_get_ip_info(if_index: u8, info: *IpInfo) bool;

pub const ScanDoneCb = *const fn (?*anyopaque, u32) callconv(cc) void;
pub extern fn wifi_station_scan(config: ?*anyopaque, cb: ScanDoneCb) bool;

pub const BssInfo = extern struct {
    next: ?*BssInfo,
    bssid: [6]u8,
    ssid: [32]u8,
    ssid_len: u8,
    channel: u8,
    rssi: i8,
    _pad0: u8 = 0,
    authmode: u32, // AUTH_MODE is C enum = 4 bytes
    is_hidden: u8,
    _pad1: u8 = 0,
    freq_offset: i16,
    freqcal_val: i16,
    _pad2: [2]u8 = .{ 0, 0 },
    esp_mesh_ie: ?*anyopaque,
};

pub extern fn spi_flash_read(src_addr: u32, des_addr: *anyopaque, size: u32) u32;
pub extern fn spi_flash_write(des_addr: u32, src_addr: *const anyopaque, size: u32) u32;
pub extern fn spi_flash_erase_sector(sector: u16) u32;

pub fn timer_arm_ms(ptimer: *ETSTimer, ms: u32, repeat: bool) void {
    ets_timer_arm_new(ptimer, ms, repeat, true);
}

pub const SYSTEM_PARTITION_BOOTLOADER: u32 = 1;
pub const SYSTEM_PARTITION_OTA_1: u32 = 2;
pub const SYSTEM_PARTITION_OTA_2: u32 = 3;
pub const SYSTEM_PARTITION_RF_CAL: u32 = 4;
pub const SYSTEM_PARTITION_PHY_DATA: u32 = 5;
pub const SYSTEM_PARTITION_SYSTEM_PARAMETER: u32 = 6;

pub const SPI_FLASH_SIZE_MAP_4MB: u32 = 6;

pub const PartitionItem = extern struct {
    type: u32,
    addr: u32,
    size: u32,
};

pub extern fn system_partition_table_regist(partition_table: [*]const PartitionItem, partition_num: u32, map: u32) bool;
