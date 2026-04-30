const std = @import("std");

// --- Types ---
pub const Erd = @import("erd.zig");
pub const Subscription = @import("subscription.zig");
pub const SystemData = @import("system_data.zig").SystemData;

// --- Namespaces ---
pub const data_component = struct {
    pub const Ram = @import("ram_data_component.zig").RamDataComponent;

    pub const IndirectMapping = @import("indirect_data_component.zig").Mapping;
    pub const Indirect = @import("indirect_data_component.zig").IndirectDataComponent;

    pub const ConvertedMapping = @import("converted_data_component.zig").Mapping;
    pub const Converted = @import("converted_data_component.zig").ConvertedDataComponent;

    pub const subscription_mixin = @import("data_component_subscription.zig");
};

pub const timer = @import("timer.zig");

pub const testing = @import("testing.zig");

pub const common = struct {
    pub const erd_logic = @import("common/erd_logic.zig");
    pub const stopwatch = @import("common/stopwatch.zig");
    pub const timer_stats = @import("common/timer_stats.zig");
};

test {
    std.testing.refAllDecls(@This());
    _ = @import("tests/system_data_test.zig");
    _ = @import("tests/ram_data_component_test.zig");
    _ = @import("tests/indirect_data_component_test.zig");
    _ = @import("tests/converted_data_component_test.zig");
    _ = @import("tests/timer_test.zig");
    _ = @import("tests/timer_fuzzing.zig");
    _ = @import("strip_asm.zig");
}
