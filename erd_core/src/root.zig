const std = @import("std");

// --- Types ---
/// ERD type definition with handle, type, and component binding.
pub const Erd = @import("Erd.zig");
/// Subscription slot with callback and context for on-change notifications.
pub const Subscription = @import("Subscription.zig");
/// Top-level system data aggregator binding multiple data components.
pub const SystemData = @import("system_data.zig").SystemData;

// --- Namespaces ---
/// Data component implementations and subscription mixin.
pub const data_component = struct {
    /// RAM-backed data component with packed byte-array storage.
    pub const Ram = @import("ram_data_component.zig").RamDataComponent;

    /// Mapping entry for indirect (function-pointer) ERDs.
    pub const IndirectMapping = @import("indirect_data_component.zig").Mapping;
    /// Read-only computed data component via function pointers.
    pub const Indirect = @import("indirect_data_component.zig").IndirectDataComponent;

    /// Mapping entry for converted (derived) ERDs.
    pub const ConvertedMapping = @import("converted_data_component.zig").Mapping;
    /// Derived data component that recomputes values from dependency ERDs.
    pub const Converted = @import("converted_data_component.zig").ConvertedDataComponent;

    /// Subscription storage and dispatch utilities for data components.
    pub const subscription_mixin = @import("data_component_subscription.zig");
};

/// Lightweight software timer scheduler for tick-based run-to-completion loops.
pub const timer = @import("timer.zig");

/// Test utilities including SystemDataTestDouble.
pub const testing = @import("testing.zig");

/// Shared utilities for ERD logic, stopwatch, and timer stats.
pub const common = struct {
    /// Boolean ERD combination logic (AND/OR/NOT gates over ERDs).
    pub const erd_logic = @import("common/erd_logic.zig");
    /// Tick-based stopwatch built on the timer module.
    pub const Stopwatch = @import("common/Stopwatch.zig");
    /// Timer module throughput and latency measurement.
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
