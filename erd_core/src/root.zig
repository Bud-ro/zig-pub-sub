pub const Erd = @import("erd.zig");
pub const Subscription = @import("subscription.zig");
pub const SystemData = @import("system_data.zig").SystemData;
pub const RamDataComponent = @import("ram_data_component.zig").RamDataComponent;
pub const IndirectDataComponent = @import("indirect_data_component.zig").IndirectDataComponent;

const converted = @import("converted_data_component.zig");
pub const ConvertedDataComponent = converted.ConvertedDataComponent;
pub const ConvertedErdMapping = converted.ConvertedErdMapping;

pub const DataComponentSubscription = @import("data_component_subscription.zig");

const timer_mod = @import("timer.zig");
pub const Timer = timer_mod.Timer;
pub const TimerModule = timer_mod.TimerModule;
pub const Ticks = timer_mod.Ticks;

pub const testing = @import("testing.zig");

pub const common = struct {
    pub const erd_logic = @import("common/erd_logic.zig");
    pub const stopwatch = @import("common/stopwatch.zig");
    pub const timer_stats = @import("common/timer_stats.zig");
};

test {
    _ = @import("tests/system_data_test.zig");
    _ = @import("tests/ram_data_component_test.zig");
    _ = @import("tests/indirect_data_component_test.zig");
    _ = @import("tests/converted_data_component_test.zig");
    _ = @import("tests/timer_test.zig");
    _ = @import("tests/timer_fuzzing.zig");
    _ = @import("common/erd_logic.zig");
    _ = @import("common/stopwatch.zig");
    _ = @import("common/timer_stats.zig");
    _ = @import("strip_asm.zig");
}
