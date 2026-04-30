//! Top level system data
//! This is a zero-cost wrapper around multiple data components
//! It binds ERDs of multiple data components into one name space, and initializes them
//! It is meant to be the top level component that you pass around your application.
//! It is intended to pass by value NOT by reference since most of it will fall away at
//! comptime and you want to ensure direct accesses to underlying function calls

const std = @import("std");
const erd_core = @import("erd_core");
const Erd = erd_core.Erd;
const Subscription = erd_core.Subscription;

pub fn SystemData(comptime ErdDefs: type, comptime ErdEnum: type, comptime erd_instance: ErdDefs, comptime Components: type) type {
    // Validate ErdEnum matches ErdDefs fields
    comptime {
        const erd_fields = std.meta.fieldNames(ErdDefs);
        const erd_enum_names = std.meta.fieldNames(ErdEnum);
        if (erd_fields.len != erd_enum_names.len) {
            @compileError("ErdEnum field count does not match ErdDefs field count");
        }
        for (erd_fields, erd_enum_names) |field_name, enum_name| {
            if (!std.mem.eql(u8, field_name, enum_name)) {
                @compileError(std.fmt.comptimePrint("ErdDefs field {s} does not match ErdEnum variant {s}", .{ field_name, enum_name }));
            }
        }
    }

    const component_fields = std.meta.fields(Components);
    const SystemErdsLength: usize = std.meta.fields(ErdDefs).len;

    comptime {
        erd_core.data_component.subscription_mixin.validateComponents(Components);
    }

    return struct {
        const Self = @This();

        pub const OnChangeArgs = Subscription.OnChangeArgs;

        /// A test only type used with verify_all_subs_are_saturated
        pub const SubException = struct { erd_enum: ErdEnum, missing: comptime_int };

        components: Components = undefined,
        /// This is a bump allocator meant to be reset at the end of a run to complete
        scratch: std.heap.FixedBufferAllocator = undefined,
        scratch_buf: [2048]u8 align(@alignOf(usize)) = undefined, // TODO: Does this actually need to be aligned?

        pub fn init(components: Components) Self {
            var this = Self{};
            this.components = components;
            this.scratch = .init(&this.scratch_buf);
            return this;
        }

        /// Returns a column from erd_instance as an array of type []T
        fn erd_collect(T: type, column_name: []const u8) [SystemErdsLength]T {
            var field_values: [SystemErdsLength]T = undefined;
            for (std.meta.fieldNames(ErdDefs), 0..) |erd_name, i| {
                field_values[i] = @field(@field(erd_instance, erd_name), column_name);
            }

            return field_values;
        }

        const component_idx_from_system_idx = erd_collect(u8, "component_idx");
        const data_component_idx_from_system_idx = erd_collect(u16, "data_component_idx");

        const supports_write_from_component_idx: [component_fields.len]bool = blk: {
            var result: [component_fields.len]bool = undefined;
            for (component_fields, 0..) |field, i| {
                result[i] = field.type.supports_write;
            }
            break :blk result;
        };

        pub const ErdEnumType = ErdEnum;
        pub const erds = erd_instance;

        pub fn erd_from_enum(comptime erd_enum: ErdEnum) Erd {
            return @field(erd_instance, @tagName(erd_enum));
        }

        /// Read an ERD by-value using comptime information (the `Erd` type)
        /// Due to the performance and code size benefits, this should be preferred over `runtime_read`.
        pub fn read(this: Self, comptime erd_enum: ErdEnum) erd_from_enum(erd_enum).T {
            const erd: Erd = erd_from_enum(erd_enum);
            inline for (component_fields, 0..) |field, i| {
                if (erd.component_idx == i) {
                    return @field(this.components, field.name).read(erd);
                }
            }
            unreachable;
        }

        /// Read an ERD into the provided `data` pointer, using the ERD's corresponding system_data_idx
        /// This will be significantly slower than a comptime read, and should only be used sparingly, for example:
        /// - When mapping from an `ErdHandle` to system_data_idx, eg. in response to UART commands
        /// - Reading an ERD using info from an on-change callback
        // noinline so the dispatch logic is shared across all call sites.
        pub noinline fn runtime_read(this: Self, system_data_idx: u16, data: *anyopaque) void {
            const component_idx = component_idx_from_system_idx[system_data_idx];
            const data_component_idx = data_component_idx_from_system_idx[system_data_idx];

            inline for (component_fields, 0..) |field, i| {
                if (component_idx == i) {
                    @field(this.components, field.name).runtime_read(data_component_idx, data);
                    return;
                }
            }
        }

        /// Write to an ERD by-value using comptime information (the `Erd` type)
        /// Due to the performance and code size benefits, this should be preferred over `runtime_write`.
        /// The owning data component handles change detection and publishes to subscribers.
        pub fn write(this: *Self, comptime erd_enum: ErdEnum, data: erd_from_enum(erd_enum).T) void {
            const erd: Erd = erd_from_enum(erd_enum);

            comptime {
                if (!supports_write_from_component_idx[erd.component_idx]) {
                    @compileError("This ERD's data component does not support writes");
                }
            }

            inline for (component_fields, 0..) |field, i| {
                if (erd.component_idx == i) {
                    @field(this.components, field.name).write(erd, data, @ptrCast(this));
                }
            }
        }

        /// Write to an ERD from the provided `data` pointer, using the ERD's corresponding system_data_idx
        /// This will be significantly slower than a comptime write, and should only be used sparingly, for example:
        /// - When mapping from an `ErdHandle` to system_data_idx, eg. in response to UART commands
        /// - Writing an ERD using info from an on-change callback (common for ERD multiplexers)
        ///
        /// NOTE: `data` must be aligned!
        // noinline so the dispatch logic is shared across all call sites.
        pub noinline fn runtime_write(this: *Self, system_data_idx: u16, data: *const anyopaque) void {
            const component_idx = component_idx_from_system_idx[system_data_idx];
            const data_component_idx = data_component_idx_from_system_idx[system_data_idx];

            inline for (component_fields, 0..) |field, i| {
                if (component_idx == i) {
                    if (!supports_write_from_component_idx[i]) {
                        unreachable;
                    }
                    @field(this.components, field.name).runtime_write(data_component_idx, data, @ptrCast(this));
                }
            }
        }

        /// Subscribe to changes on an ERD. The callback receives `context`,
        /// on-change args, and a `publisher` pointer which is always `*SystemData`
        /// (type-erased as `*anyopaque`).
        pub fn subscribe(
            this: *Self,
            comptime erd_enum: ErdEnum,
            context: ?*anyopaque,
            fn_ptr: Subscription.Callback,
        ) void {
            const erd: Erd = erd_from_enum(erd_enum);
            comptime {
                std.debug.assert(erd.subs > 0);
            }

            inline for (component_fields, 0..) |field, i| {
                if (erd.component_idx == i) {
                    @field(this.components, field.name).subs.subscribe(erd, context, fn_ptr);
                    return;
                }
            }
        }

        pub fn unsubscribe(this: *Self, comptime erd_enum: ErdEnum, fn_ptr: Subscription.Callback) void {
            const erd: Erd = erd_from_enum(erd_enum);
            comptime {
                std.debug.assert(erd.subs > 0);
            }

            inline for (component_fields, 0..) |field, i| {
                if (erd.component_idx == i) {
                    @field(this.components, field.name).subs.unsubscribe(erd, fn_ptr);
                    return;
                }
            }
        }

        /// Returns a slice allocated to the scratch buffer.
        pub fn scratch_alloc(this: *Self, comptime T: type, n: usize) []T {
            return this.scratch.allocator().alloc(T, n) catch @panic("We ran out of scratch memory!!!");
        }

        /// Call this at the end of a run to complete in your main-loop
        pub fn scratch_reset(this: *Self) void {
            this.scratch.reset();
        }

        /// A test only function used to verify that after initialization,
        /// all of your subscriptions arrays are fully saturated
        pub fn verify_all_subs_are_saturated(this: *Self, comptime exceptions: []const SubException) !void {
            var failed = false;

            inline for (exceptions) |e| {
                const erd_name = @tagName(e.erd_enum);
                const num_subs = @field(erd_instance, erd_name).subs;
                if (num_subs == 0) {
                    std.log.warn("Remove {s} from exceptions list since subscriptions are disabled for it", .{erd_name});
                    failed = true;
                }
            }

            if (failed) {
                return error.ErdWithNoSubsInExceptions;
            }

            inline for (std.meta.fields(ErdDefs)) |field_info| {
                const erd_name = field_info.name;
                const erd: Erd = @field(erd_instance, erd_name);
                const num_subs = erd.subs;

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

                const component_idx = erd.component_idx;
                var actual_count: u16 = 0;

                inline for (component_fields, 0..) |comp_field, ci| {
                    if (component_idx == ci) {
                        const sub_field = &@field(this.components, comp_field.name).subs;
                        const SubscriptionType = @TypeOf(sub_field.*);
                        const offset = SubscriptionType.sub_offsets[erd.data_component_idx];
                        for (sub_field.slots[offset .. offset + num_subs]) |sub| {
                            if (sub.callback != null) {
                                actual_count += 1;
                            }
                        }
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
    };
}
