comptime {
    _ = @import("data_gen/unit_tests.zig");

    _ = @import("tests/erd_json_test.zig");
    _ = @import("tests/system_data_test.zig");
    _ = @import("tests/ram_data_component_test.zig");
    _ = @import("tests/indirect_data_component_test.zig");
    _ = @import("tests/timer_test.zig");
    _ = @import("tests/timer_fuzzing.zig");
    _ = @import("common/erd_logic.zig");
    _ = @import("common/timer_stats.zig");
}
