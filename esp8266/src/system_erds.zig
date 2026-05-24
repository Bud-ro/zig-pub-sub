//! ERD definitions for the ESP8266 application

const erd_core = @import("erd_core");
const Erd = erd_core.Erd;

/// WiFi operating mode.
pub const WifiMode = enum(u8) { ap, station };
/// WiFi connection status.
pub const WifiStatus = enum(u8) { disconnected, connecting, connected, got_ip };

/// Identifies which data component owns an ERD.
pub const ComponentId = enum(u8) { ram };
const Ram = @intFromEnum(ComponentId.ram);

/// Enum for referencing ESP8266 ERDs by name. Must match `ErdDefinitions`
/// field names 1:1 in order.
pub const ErdEnum = enum {
    comptime {
        erd_core.erd_table.validateEnumMatchesDefs(ErdEnum, ErdDefinitions);
    }

    erd_uptime_seconds,
    erd_led_state,
    erd_wifi_mode,
    erd_wifi_status,
    erd_wifi_ip_addr,
    erd_http_request_count,
};

/// Struct of all ERD field definitions for ESP8266.
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

/// ERD definitions with `data_component_idx` and `system_data_idx` auto-assigned.
pub const erd: ErdDefinitions = erd_core.erd_table.autofill(ErdDefinitions);

/// Count ERDs belonging to the given component.
pub fn numErds(comptime id: ComponentId) comptime_int {
    return erd_core.erd_table.numErdsByComponent(erd, @intFromEnum(id));
}

/// Extract ERD definitions for a specific component as an array.
pub fn componentDefinitions(comptime id: ComponentId) [numErds(id)]Erd {
    return erd_core.erd_table.collectByComponent(erd, @intFromEnum(id));
}

/// All RAM component ERD definitions as an array.
pub const ram_definitions = componentDefinitions(.ram);
