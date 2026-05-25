//! ERD struct used at the data component level and by end users when calling
//! SystemData / data component APIs.
//!
//! Applications declare each ERD with its `erd_number`, `T`, `component_idx`,
//! and `subs`. The remaining bookkeeping fields (`data_component_idx`,
//! `system_data_idx`) are filled in by `erd_core.erd_table.autofill` so
//! application code does not have to count or repeat itself.

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
/// Auto-filled by `erd_table.autofill`: zero-based index of this ERD within
/// its owning data component (so RAM ERDs get 0, 1, 2, ... and Indirect ERDs
/// independently get 0, 1, ...). Used by RAM/Indirect/Converted dispatch
/// tables. Leave as `undefined` in your ErdDefinitions; autofill rewrites it.
data_component_idx: comptime_int = undefined,
/// Auto-filled by `erd_table.autofill`: zero-based index of this ERD across
/// the entire ErdDefinitions struct in field order. Sufficient on its own
/// for `SystemData.runtimeRead`/`runtimeWrite`/runtime subscriptions; the
/// runtime path uses it to recover both `component_idx` and
/// `data_component_idx` via constant-time lookup tables (slower than the
/// comptime path, but keeps the code footprint small).
system_data_idx: u16 = undefined,

/// ERD identifier, allows for ERDs to be referenced externally
pub const ErdHandle = u16; // TODO: Evaluate if this should be an non-exhaustive enum `ErdHandle = enum { _ };`

/// Allows ERDs to be printed as `0xXXXX`. Panics if the ERD has no `erd_number`.
pub fn format(self: *const Erd, writer: *std.Io.Writer) std.Io.Writer.Error!void {
    const number = self.erd_number orelse @panic("Can't format erds with null number");
    try writer.print("0x{x:0>4}", .{number});
}

test "format prints erd_number as zero-padded 4-digit hex" {
    var buf: [16]u8 = undefined;
    var w: std.Io.Writer = .fixed(&buf);

    const erd: Erd = .{ .erd_number = 0x002A, .T = u8, .component_idx = 0, .subs = 0 };
    try erd.format(&w);
    try std.testing.expectEqualStrings("0x002a", w.buffered());
}

test "format zero-pads single-digit erd_number" {
    var buf: [16]u8 = undefined;
    var w: std.Io.Writer = .fixed(&buf);

    const erd: Erd = .{ .erd_number = 0x0001, .T = u8, .component_idx = 0, .subs = 0 };
    try erd.format(&w);
    try std.testing.expectEqualStrings("0x0001", w.buffered());
}

test "format handles erd_number at the u16 max" {
    var buf: [16]u8 = undefined;
    var w: std.Io.Writer = .fixed(&buf);

    const erd: Erd = .{ .erd_number = 0xFFFF, .T = u8, .component_idx = 0, .subs = 0 };
    try erd.format(&w);
    try std.testing.expectEqualStrings("0xffff", w.buffered());
}
