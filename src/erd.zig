const Erd = @This();

/// The relative index of the ERD in its data component
idx: comptime_int = undefined,
/// The idea is that this will be an optional public handle that you can statically attach to an ERD
/// Internally you'd use the Erd type to perform a lookup, since it has all the type nicities.
/// External reads would have to go through a lookup to find the Erd using the erd_handle
/// What makes this nice is that "public" and "private" "ERDs" are greatly distinguished
erd_handle: ErdHandle = undefined,
T: type,

// ERDs only need 16 bits. If your system has more than 65535 statically known and named variables, then find god
pub const ErdHandle = u16;
