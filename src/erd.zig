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
/// The number of subscriptions we have to deal with at MAX.
/// Due to limitations with incremental-compliation, we cannot determine this at compile time,
/// instead a runtime test will verify that this number is not over, and not under what it needs to be.
/// This comes with the modest assumption that after initialization: ALL of your subscription arrays will be full,
/// `unsubscribe`s can only happen after application init, and subscriptions can only be re-added after init.
subs: comptime_int,
/// The relative index of the ERD in its data component
data_component_idx: comptime_int = undefined,
/// The relative index of the ERD in the aggregate system data
system_data_idx: comptime_int = undefined,

/// ERD identifier, allows for ERDs to be referenced externally
pub const ErdHandle = u16; // TODO: Evaluate if this should be an inexhaustive enum `ErdHandle = enum { _ };`

// TODO: Consider moving this into system_data.zig
pub const ErdOwner = enum {
    Ram,
    Indirect,
};
