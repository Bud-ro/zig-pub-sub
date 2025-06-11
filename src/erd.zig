//! This ERD struct is meant for use at the data component level, and for the end user to use
//! when making calls to SystemData or any general data component
//! This is a generated type, the top level initialization should be done from within system_data.zig

const std = @import("std");
const Erd = @This();
const ErdDefinitions = @import("system_erds.zig").ErdDefinitions;

/// This is an optional public handle for an ERD.
/// Without this, the ERD will not appear in the generated ERD JSON.
erd_number: ?ErdHandle,
/// Type of the ERD
T: type,
/// Owning Data Component
owner: ErdOwner,
/// The number of subscriptions we have to deal with at MAX.
/// Due to limitations with incremental-compliation, we cannot determine this at compile time,
/// instead a runtime test will verify that this number is not over, and not under what it needs to be.
/// This comes with the modest assumption that after initialization: ALL of your subscription arrays will be full,
/// `unsubscribe`s can only happen after application init, and subscriptions can only be re-added after init.
subs: comptime_int,
/// The relative index of the ERD in its data component
data_component_idx: comptime_int = undefined,
/// The relative index of the ERD in the aggregate system data.
/// This field is sufficient for runtime ERD read/write/subscriptions.
/// Performance is negatively affected due to constant-time lookups of `owner` and `data_component_idx`
/// however this allows for enforcing a small code footprint
system_data_idx: u16 = undefined,

/// ERD identifier, allows for ERDs to be referenced externally
pub const ErdHandle = u16; // TODO: Evaluate if this should be an inexhaustive enum `ErdHandle = enum { _ };`

// TODO: Consider moving this into system_data.zig
pub const ErdOwner = enum {
    Ram,
    Indirect,
};

/// Allows ERDs to be printed as `0xXXXX`
pub fn format(self: *const Erd, comptime fmt: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
    if (fmt.len != 0) {
        std.fmt.invalidFmtError(fmt, self);
    }

    if (self.erd_number) |number| {
        return writer.print("0x{x:0>4}", .{number});
    } else {
        std.fmt.invalidFmtError(fmt, self);
    }
}

/// Allows ERDs to be directly transformed into JSON
pub fn jsonStringify(comptime self: Erd, jws: anytype) !void {
    if (self.erd_number != null) {
        const erd_names = comptime std.meta.fieldNames(ErdDefinitions);

        try jws.beginObject();
        try jws.objectField("name");
        try jws.write(erd_names[self.system_data_idx]);
        try jws.objectField("id");
        try jws.print("\"{}\"", .{self});
        try jws.objectField("type");
        // TODO: Convert the type into type info consumable by external tools, rather than just a type name,
        // Consider: https://jsontypedef.com/ ?
        //
        // try serialize_type(self.T, jws);
        try jws.print("\"{}\"", .{self.T});
        try jws.endObject();
    } else {
        @panic("Programmer error, ERDs with null erd_number should not be serialized!!!");
    }
}
