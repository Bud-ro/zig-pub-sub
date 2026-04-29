//! This ERD struct is meant for use at the data component level, and for the end user to use
//! when making calls to SystemData or any general data component
//! This is a generated type, the top level initialization should be done from within system_data.zig

const std = @import("std");
const Erd = @This();

/// This is an optional public handle for an ERD.
/// Without this, the ERD will not appear in the generated ERD JSON.
erd_number: ?ErdHandle,
/// Type of the ERD
T: type,
/// Index of the owning data component in the Components struct
component_idx: comptime_int,
/// The number of subscription slots that are available
subs: comptime_int,
/// The relative index of the ERD in its data component
data_component_idx: comptime_int = undefined,
/// The relative index of the ERD in the aggregate system data.
/// This field is sufficient for runtime ERD read/write/subscriptions.
/// Performance is negatively affected due to constant-time lookups of `component_idx` and `data_component_idx`
/// however this allows for enforcing a small code footprint
system_data_idx: u16 = undefined,

/// ERD identifier, allows for ERDs to be referenced externally
pub const ErdHandle = u16; // TODO: Evaluate if this should be an non-exhaustive enum `ErdHandle = enum { _ };`

/// Allows ERDs to be printed as `0xXXXX`
pub fn format(self: *const Erd, writer: *std.io.Writer) !void {
    if (self.erd_number) |number| {
        return try writer.print("0x{x:0>4}", .{number});
    } else {
        @panic("Can't format erds with null number");
    }
}
