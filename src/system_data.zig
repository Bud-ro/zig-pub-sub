//! Top level system data
//! This is a zero-cost wrapper around multiple data components
//! It binds ERDs of multiple data components into one name space, and initializes them
//! It is meant to be the top level component that you pass around your application.
//! It is intended to pass by value NOT by reference since most of it will fall away at
//! comptime and you want to ensure direct accesses to underlying function calls

const std = @import("std");
const Erd = @import("erd.zig");
const RamDataComponent = @import("ram_data_component.zig");
const IndirectDataComponent = @import("indirect_data_component.zig");
const SystemErds = @import("system_erds.zig");
const Subscription = @import("subscription.zig");

const SystemData = @This();

ram: RamDataComponent = undefined,
indirect: IndirectDataComponent = undefined,
subscriptions: [total_subscriptions()]Subscription = undefined,
/// This is a bump allocator meant to be reset at the end of a run to complete
scratch: std.heap.FixedBufferAllocator = undefined,
scratch_buf: [2048]u8 align(@alignOf(usize)) = undefined, // TODO: Does this actually need to be aligned?

fn total_subscriptions() usize {
    comptime {
        var size: usize = 0;
        for (std.meta.fieldNames(SystemErds.ErdDefinitions)) |erd_name| {
            size += @field(SystemErds.erd, erd_name).subs;
        }
        return size;
    }
}

const SystemErdsLength: usize = std.meta.fields(SystemErds.ErdDefinitions).len;

const subscription_offsets = blk: {
    var _offsets: [SystemErdsLength]usize = undefined;
    var cur_offset = 0;

    for (std.meta.fieldNames(SystemErds.ErdDefinitions), 0..) |erd_name, i| {
        if (@field(SystemErds.erd, erd_name).subs != 0) {
            _offsets[i] = cur_offset;
        }
        cur_offset += @field(SystemErds.erd, erd_name).subs;
    }
    break :blk _offsets;
};

/// Returns a column from system_erds as an array of type []T
fn system_erds_collect(T: type, column_name: []const u8) [SystemErdsLength]T {
    var field_values: [SystemErdsLength]T = undefined;
    for (std.meta.fieldNames(SystemErds.ErdDefinitions), 0..) |erd_name, i| {
        field_values[i] = @field(@field(SystemErds.erd, erd_name), column_name);
    }

    return field_values;
}

// Create .rodata that is indexed by `system_data_idx`
const subs_from_idx = system_erds_collect(u8, "subs");
const owner_from_idx = system_erds_collect(Erd.ErdOwner, "owner");
const data_component_idx_from_idx = system_erds_collect(u16, "data_component_idx");

fn always_42(data: *u16) void {
    data.* = 42;
}

fn plus_one(data: *u16) void {
    var should_be_42: u16 = undefined;
    always_42(&should_be_42);

    data.* = should_be_42 + 1;
}

const indirectErdMapping = [_]IndirectDataComponent.IndirectErdMapping{
    .map(.erd_always_42, always_42),
    .map(.erd_another_erd_plus_one, plus_one),
};

pub fn init() SystemData {
    var this = SystemData{};
    this.ram = .init();
    this.indirect = .init(indirectErdMapping);
    this.scratch = .init(&this.scratch_buf);

    @memset(&this.subscriptions, Subscription{ .context = null, .callback = null });
    return this;
}

/// Read an ERD by-value using comptime information (the `Erd` type)
/// Due to the performance and code size benefits, this should be preferred over `runtime_read`.
pub fn read(this: SystemData, comptime erd_enum: SystemErds.ErdEnum) SystemErds.erd_from_enum(erd_enum).T {
    const erd: Erd = SystemErds.erd_from_enum(erd_enum);
    switch (erd.owner) {
        .Ram => return this.ram.read(erd),
        .Indirect => return this.indirect.read(erd),
    }
}

/// Read an ERD into the provided `data` pointer, using the ERD's corresponding system_data_idx
/// This will be significantly slower than a comptime read, and should only be used sparingly, for example:
/// - When mapping from an `ErdHandle` to system_data_idx, eg. in response to UART commands
/// - Reading an ERD using info from an on-change callback
pub fn runtime_read(this: SystemData, system_data_idx: u16, data: *anyopaque) void {
    const owner: Erd.ErdOwner = owner_from_idx[system_data_idx];
    const data_component_idx: u16 = data_component_idx_from_idx[system_data_idx];

    switch (owner) {
        .Ram => this.ram.runtime_read(data_component_idx, data),
        .Indirect => this.indirect.runtime_read(data_component_idx, data),
    }
}

/// Write to an ERD by-value using comptime information (the `Erd` type)
/// Due to the performance and code size benefits, this should be preferred over `runtime_write`.
pub fn write(this: *SystemData, comptime erd_enum: SystemErds.ErdEnum, data: SystemErds.erd_from_enum(erd_enum).T) void {
    const erd: Erd = SystemErds.erd_from_enum(erd_enum);
    const publish_required = switch (erd.owner) {
        .Ram => this.ram.write(erd, data),
        .Indirect => comptime unreachable,
    };

    if (publish_required and erd.subs != 0) {
        this.publish(erd.system_data_idx, &data);
    }
}

/// Write to an ERD from the provided `data` pointer, using the ERD's corresponding system_data_idx
/// This will be significantly slower than a comptime write, and should only be used sparingly, for example:
/// - When mapping from an `ErdHandle` to system_data_idx, eg. in response to UART commands
/// - Writing an ERD using info from an on-change callback (common for ERD multiplexers)
///
/// NOTE: `data` must be aligned!
pub fn runtime_write(this: *SystemData, system_data_idx: u16, data: *const anyopaque) void {
    const publish_required = switch (owner_from_idx[system_data_idx]) {
        .Ram => this.ram.runtime_write(data_component_idx_from_idx[system_data_idx], data),
        .Indirect => comptime unreachable,
    };

    if (publish_required and subs_from_idx[system_data_idx] != 0) {
        this.publish(system_data_idx, data);
    }
}

fn publish(this: *SystemData, system_data_idx: u16, data: *const anyopaque) void {
    const sub_offset = subscription_offsets[system_data_idx];

    for (this.subscriptions[sub_offset .. sub_offset + subs_from_idx[system_data_idx]]) |_sub| {
        if (_sub.callback) |_callback| {
            // TODO: Wrap the data with a struct like this
            // pub const SystemDataOnChangeArgs = struct {
            //     system_data_idx: u16,
            //     data: *const anyopaque,
            // };
            _callback(_sub.context, data, this);
        }
    }
}

pub fn subscribe(
    this: *SystemData,
    comptime erd_enum: SystemErds.ErdEnum,
    context: ?*anyopaque,
    fn_ptr: Subscription.SubscriptionCallback,
) void {
    const erd: Erd = SystemErds.erd_from_enum(erd_enum);
    comptime {
        std.debug.assert(erd.subs > 0);
        std.debug.assert(erd.owner != .Indirect);
    }
    const sub_offset = subscription_offsets[erd.system_data_idx];

    // TODO: BUG, need to scan the entire subscription list for membership
    // Also need to modify the behavior to not assert on re-subscribe
    for (this.subscriptions[sub_offset .. sub_offset + erd.subs]) |*_sub| {
        // Subscriptions cannot be added to the same list twice
        std.debug.assert(_sub.callback != fn_ptr);

        if (_sub.callback == null) {
            _sub.context = context;
            _sub.callback = fn_ptr;
            return;
        }
    }

    // In tests this verifies we aren't subscribing beyond our array length
    // These names should be stripped out of the binary if a panic handler isn't set.
    // TODO: Validate this assumption and switch to using something lighter if needed
    const erd_names = comptime std.meta.fieldNames(SystemErds.ErdDefinitions);
    std.debug.panic("ERD {s} oversubscribed!", .{erd_names[erd.system_data_idx]});
}

pub fn unsubscribe(this: *SystemData, comptime erd_enum: SystemErds.ErdEnum, fn_ptr: Subscription.SubscriptionCallback) void {
    const erd: Erd = SystemErds.erd_from_enum(erd_enum);
    comptime {
        std.debug.assert(erd.subs > 0);
        // We know you can't sub/unsub to these:
        std.debug.assert(erd.owner != .Indirect);
    }

    const sub_offset = subscription_offsets[erd.system_data_idx];

    for (this.subscriptions[sub_offset .. sub_offset + erd.subs]) |*_sub| {
        if (_sub.callback == fn_ptr) {
            _sub.callback = null;
            return;
        }
    }
}

/// Returns a slice allocated to the scratch buffer.
pub fn scratch_alloc(this: *SystemData, comptime T: type, n: usize) []T {
    // TODO: Consider if this can somehow be used for RX/TX buffers???
    // Or do those need to last more than one RTC? If so, is there an alternate strategy that can be employed?
    return this.scratch.allocator().alloc(T, n) catch @panic("We ran out of scratch memory!!!");
}

/// Call this at the end of a run to complete in your main-loop
pub fn scratch_reset(this: *SystemData) void {
    this.scratch.reset();
}

/// A test only type used with verify_all_subs_are_saturated
pub const SubException = struct { erd_enum: SystemErds.ErdEnum, missing: comptime_int };

/// A test only function used to verify that after initialization, all of your subscriptions arrays are fully saturated
pub fn verify_all_subs_are_saturated(this: *SystemData, comptime exceptions: []const SubException) !void {
    var failed = false;

    inline for (exceptions) |e| {
        const erd_name = @tagName(e.erd_enum);
        const num_subs = @field(SystemErds.erd, erd_name).subs;
        if (num_subs == 0) {
            std.log.warn("Remove {s} from exceptions list since subscriptions are disabled for it", .{erd_name});
            failed = true;
        }
    }

    if (failed) {
        return error.ErdWithNoSubsInExceptions;
    }

    inline for (std.meta.fields(SystemErds.ErdDefinitions), 0..) |field_info, i| {
        const erd_name = field_info.name;
        const sub_offset = subscription_offsets[i];
        const num_subs = @field(SystemErds.erd, erd_name).subs;

        if (num_subs == 0) {
            continue;
        }

        const expected_count = blk: {
            comptime var _expected = num_subs;
            inline for (exceptions) |e| {
                if (comptime std.mem.eql(u8, @tagName(e.erd_enum), erd_name)) {
                    _expected = num_subs - e.missing;
                    break :blk _expected;
                }
            }
            break :blk _expected;
        };

        var actual_count: u16 = 0;
        for (this.subscriptions[sub_offset .. sub_offset + num_subs]) |_sub| {
            if (_sub.callback != null) {
                actual_count += 1;
            }
        }

        if (actual_count < expected_count) {
            std.log.warn("ERD: {s} is under-subscribing after init. Decrease subs, or increase missing.", .{erd_name});
            failed = true;
        } else if (actual_count > expected_count) {
            std.log.warn("ERD: {s} is over-subscribed after init. Increase subs or decrease missing.", .{erd_name});
            failed = true;
        }
    }

    if (failed) {
        return error.ErdWithUnexpectedSubCount;
    }
}
