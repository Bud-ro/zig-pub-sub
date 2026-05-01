//! ERD definitions for the ESP8266 application

const std = @import("std");
const erd_core = @import("erd_core");
const Erd = erd_core.Erd;

pub const WifiMode = enum(u8) { ap, station };
pub const WifiStatus = enum(u8) { disconnected, connecting, connected, got_ip };

pub const ComponentId = enum(u8) { ram };
const Ram = @intFromEnum(ComponentId.ram);

pub const ErdEnum = enum {
    comptime {
        const erd_fields = std.meta.fieldNames(ErdDefinitions);
        const erd_enum_names = std.meta.fieldNames(ErdEnum);
        for (erd_fields, erd_enum_names) |field_name, enum_name| {
            if (!std.mem.eql(u8, field_name, enum_name))
                @compileError(std.fmt.comptimePrint("Field {s} does not match enum {s}", .{ field_name, enum_name }));
        }
    }

    erd_uptime_seconds,
    erd_led_state,
    erd_wifi_mode,
    erd_wifi_status,
    erd_wifi_ip_addr,
    erd_http_request_count,
};

pub const ErdDefinitions = struct {
    // zig fmt: off
    erd_uptime_seconds:     Erd = .{ .erd_number = 0x0001, .T = u32,        .component_idx = Ram, .subs = 0 },
    erd_led_state:          Erd = .{ .erd_number = 0x0002, .T = bool,       .component_idx = Ram, .subs = 1 },
    erd_wifi_mode:          Erd = .{ .erd_number = 0x0003, .T = WifiMode,   .component_idx = Ram, .subs = 0 },
    erd_wifi_status:        Erd = .{ .erd_number = 0x0004, .T = WifiStatus, .component_idx = Ram, .subs = 0 },
    erd_wifi_ip_addr:       Erd = .{ .erd_number = 0x0005, .T = u32,        .component_idx = Ram, .subs = 0 },
    erd_http_request_count: Erd = .{ .erd_number = 0x0006, .T = u32,        .component_idx = Ram, .subs = 0 },
    // zig fmt: on
};

pub const erd: ErdDefinitions = blk: {
    var _erds = ErdDefinitions{};
    var max_component_idx: comptime_int = 0;
    for (std.meta.fieldNames(ErdDefinitions)) |erd_field_name| {
        const idx = @field(_erds, erd_field_name).component_idx;
        if (idx > max_component_idx) max_component_idx = idx;
    }
    var owning_counts = std.mem.zeroes([max_component_idx + 1]u16);
    for (std.meta.fieldNames(ErdDefinitions)) |erd_field_name| {
        const idx = @field(_erds, erd_field_name).component_idx;
        @field(_erds, erd_field_name).data_component_idx = owning_counts[idx];
        owning_counts[idx] += 1;
    }
    std.debug.assert(0xffff == std.math.maxInt(Erd.ErdHandle));
    for (std.meta.fieldNames(ErdDefinitions), 0..) |erd_field_name, i| {
        @field(_erds, erd_field_name).system_data_idx = i;
    }
    break :blk _erds;
};

pub fn num_erds(comptime id: ComponentId) comptime_int {
    const component_idx = @intFromEnum(id);
    var i = 0;
    for (std.meta.fieldNames(ErdDefinitions)) |erd_name| {
        if (@field(erd, erd_name).component_idx == component_idx) i += 1;
    }
    return i;
}

pub fn component_definitions(comptime id: ComponentId) [num_erds(id)]Erd {
    const component_idx = @intFromEnum(id);
    var _erds: [num_erds(id)]Erd = undefined;
    var i = 0;
    for (std.meta.fieldNames(ErdDefinitions)) |erd_name| {
        if (@field(erd, erd_name).component_idx == component_idx) {
            _erds[i] = @field(erd, erd_name);
            i += 1;
        }
    }
    return _erds;
}

pub const ram_definitions = component_definitions(.ram);
