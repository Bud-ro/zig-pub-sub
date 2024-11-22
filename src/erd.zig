//! This ERD struct is meant for use at the data component level, and for the end user to use
//! when making calls to SystemData or any general data component
//! This is a generated type, the top level initialization should be done from within system_data.zig

const Erd = @This();

/// This is an optional public handle for an ERD.
/// Without this, the ERD will not appear in the generated ERD JSON.
erd_number: ?ErdHandle,
/// Type of the ERD
T: type,
/// Owning Data Component
owner: ErdOwner,
/// The relative index of the ERD in its data component
idx: comptime_int = undefined,

/// ERD identifier, allows for ERDs to be referenced externally
pub const ErdHandle = enum(u16) { _ };

// TODO: Consider moving this into system_data.zig
pub const ErdOwner = enum {
    Ram,
    Indirect,
};
