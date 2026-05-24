//! Comptime data validation and generation for embedded system configurations.
//! Four sub-modules:
//!   - `constraint`: primitive comptime checks. Each returns `?[]const u8`
//!     (null = passed, string = error message).
//!   - `contract`: recursive `contractValidate` protocol that auto-walks struct
//!     fields and array elements, calling each sub-value's `contractValidate`.
//!   - `transform`: float-to-fixed-point / scaled-integer / percent conversions
//!     with `@compileError` on inexact representation or overflow.
//!   - `generator`: comptime array builders for lookup tables and the like.

// zlinter-disable require_doc_comment
pub const constraint = @import("constraint.zig");
pub const contract = @import("contract.zig");
pub const generator = @import("generator.zig");
pub const transform = @import("transform.zig");

test {
    _ = constraint;
    _ = contract;
    _ = generator;
    _ = transform;

    _ = @import("tests/constraint_test.zig");
    _ = @import("tests/contract_test.zig");
    _ = @import("tests/generator_test.zig");
    _ = @import("tests/transform_test.zig");
    _ = @import("tests/examples/config_test.zig");
    _ = @import("tests/examples/timing_test.zig");
    _ = @import("tests/examples/recipe_test.zig");
    _ = @import("tests/examples/calibration_test.zig");
    _ = @import("tests/examples/state_machine_test.zig");
    _ = @import("tests/examples/lookup_table_test.zig");
    _ = @import("tests/examples/deep_linking_test.zig");
    _ = @import("tests/examples/repetitious_test.zig");
    _ = @import("tests/examples/register_map_test.zig");
    _ = @import("tests/examples/pid_tuning_test.zig");
    _ = @import("tests/examples/protocol_test.zig");
    _ = @import("tests/examples/scheduling_test.zig");
    _ = @import("tests/examples/signal_routing_test.zig");
    _ = @import("tests/examples/power_sequencing_test.zig");
    _ = @import("tests/examples/pipeline_test.zig");
    _ = @import("tests/examples/pin_mux_test.zig");
    _ = @import("tests/examples/can_bus_test.zig");
    _ = @import("tests/examples/encoding_test.zig");
    _ = @import("tests/examples/resource_budget_test.zig");
    _ = @import("tests/examples/firmware_image_test.zig");
    _ = @import("tests/examples/network_topology_test.zig");
    _ = @import("tests/examples/error_correction_test.zig");
    _ = @import("tests/examples/scheduler_test.zig");
    _ = @import("tests/examples/sensor_fusion_test.zig");
    _ = @import("tests/examples/variant_config_test.zig");
    _ = @import("tests/examples/integrated_system_test.zig");
    _ = @import("tests/examples/exotic_types_test.zig");
    _ = @import("tests/examples/transforms_test.zig");
}
