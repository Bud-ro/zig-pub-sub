//! ERD definitions for the ESP32-C3 application.

const erd_core = @import("erd_core");
const Erd = erd_core.Erd;

/// Identifies which data component owns an ERD.
pub const ComponentId = enum(u8) { ram };
const Ram = @intFromEnum(ComponentId.ram);

/// Enum for referencing ESP32-C3 ERDs by name.
pub const ErdEnum = enum {
    erd_uptime_seconds,
    erd_led_state,
};

/// Struct of all ERD field definitions for ESP32-C3.
pub const ErdDefinitions = struct {
    // zig fmt: off
    erd_uptime_seconds: Erd = .{ .erd_number = 0x0001, .T = u32,  .component_idx = Ram, .subs = 0 },
    erd_led_state:      Erd = .{ .erd_number = 0x0002, .T = bool, .component_idx = Ram, .subs = 1 },
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
