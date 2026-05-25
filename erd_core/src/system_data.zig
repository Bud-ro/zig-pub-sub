//! Top-level system data: a comptime-typed wrapper around a struct of data
//! components. Binds the application's ERD definitions to concrete component
//! storage, validates the ERD table at comptime (unique `erd_number`, ErdEnum
//! field-name alignment, every component has the `subs` field + `supports_write`
//! decl), and exposes:
//!
//!   - comptime-dispatched `read`/`write`/`modify`/`subscribe`/`unsubscribe`
//!     (one comptime field access, no runtime dispatch table)
//!   - runtime-dispatched `runtimeRead`/`runtimeWrite` for the case where the
//!     ERD is known only by its `system_data_idx` (e.g. UART command handler)
//!   - a per-RTC scratch allocator (`scratchAlloc`/`scratchReset`)
//!
//! Pass `SystemData` by value to the API so the comptime-known field offsets
//! collapse to direct loads/stores rather than indirect access through a
//! pointer; methods that mutate (`write`/`modify`/etc.) take `*Self`.

const erd_core = @import("erd_core");
const std = @import("std");
const Erd = erd_core.Erd;
const Subscription = erd_core.Subscription;

/// Args delivered to subscribers of data-component ERDs. Each publisher owns
/// its own args type; this is SystemData's. Lives at file scope (not inside
/// the SystemData generic) so data components and other modules can import
/// the type without instantiating SystemData.
pub const OnChangeArgs = struct {
    /// system_data_idx of the ERD whose value changed.
    system_data_idx: u16,
    /// Pointer to the ERD's new value, as raw bytes.
    data: *const anyopaque,
};

/// Shared noinline dispatcher for SystemData-shaped publishes. Takes the
/// `OnChangeArgs` *fields* individually -- Zig's struct-by-value ABI tends
/// to insert a hidden indirect pointer for `OnChangeArgs`, which prevents
/// callers (RAM/Converted data components) from tail-jumping. Passing the
/// fields as separate register-sized parameters keeps the call site a pure
/// arg-shuffle + jmp.
///
/// The args struct is built inside this dispatcher; the pointer handed to
/// each subscriber is valid only for the duration of the dispatch.
pub noinline fn publishOnChange(slots: []Subscription, system_data_idx: u16, data: *const anyopaque, publisher: *anyopaque) void {
    const args: OnChangeArgs = .{ .system_data_idx = system_data_idx, .data = data };
    for (slots) |*sub| {
        const cb = sub.callback orelse continue;
        cb(sub.context, @ptrCast(&args), publisher);
    }
}

/// Construct a typed pub-sub system data aggregator from ERD definitions and components.
pub fn SystemData(ErdDefs: type, ErdEnum: type, comptime erd_instance: ErdDefs, Components: type) type {
    comptime {
        // Validate ErdEnum matches ErdDefs fields 1:1 in order.
        erd_core.erd_table.validateEnumMatchesDefs(ErdEnum, ErdDefs);

        // Reject duplicate erd_numbers up front so the callsite (system_erds.zig
        // tables) does not have to repeat the check. The bit set needs one
        // bit per representable handle value, so `maxInt(...) + 1` (NOT
        // `maxInt(...)`) -- otherwise the largest valid handle is out of range.
        var seen_numbers: std.bit_set.ArrayBitSet(usize, @as(usize, std.math.maxInt(Erd.ErdHandle)) + 1) = .empty;
        for (std.meta.fieldNames(ErdDefs)) |field_name| {
            if (@field(erd_instance, field_name).erd_number) |num| {
                if (seen_numbers.isSet(num)) {
                    @compileError(std.fmt.comptimePrint("Multiple ERD definitions with number 0x{x:0>4}", .{num}));
                }
                seen_numbers.set(num);
            }
        }
    }

    const component_fields = std.meta.fields(Components);
    const system_erds_length: usize = std.meta.fields(ErdDefs).len;

    comptime {
        erd_core.data_component.subscription_mixin.validateComponents(Components);

        // Reject ERDs whose `component_idx` is out of range for `Components`.
        // Without this check the user gets a confusing later error like
        // "index out of bounds" from `component_fields[erd.component_idx]`.
        for (std.meta.fieldNames(ErdDefs)) |erd_field_name| {
            const erd = @field(erd_instance, erd_field_name);
            if (erd.component_idx < 0 or erd.component_idx >= component_fields.len) {
                @compileError(std.fmt.comptimePrint(
                    "ERD {s} has component_idx {} but Components only has {} field(s) (valid range: 0..{})",
                    .{ erd_field_name, erd.component_idx, component_fields.len, component_fields.len - 1 },
                ));
            }
        }
    }

    return struct {
        const Self = @This();

        /// A test only type used with verifyAllSubsAreSaturated
        pub const SubException = struct { erd_enum: ErdEnum, missing: comptime_int };

        components: Components = undefined,
        /// Bump allocator backed by `scratch_buf`. Reset at the end of each
        /// run-to-complete via `scratchReset` so allocations don't accumulate.
        scratch: std.heap.FixedBufferAllocator = undefined,
        /// Backing storage for `scratch`. Aligned to `@alignOf(usize)` so the
        /// FixedBufferAllocator can hand out usize-aligned (or smaller)
        /// allocations without ever needing internal alignment padding from
        /// the buffer base.
        scratch_buf: [2048]u8 align(@alignOf(usize)) = undefined,

        /// Initialize SystemData with the given component instances.
        pub fn init(components: Components) Self {
            var this = Self{};
            this.components = components;
            this.scratch = .init(&this.scratch_buf);
            return this;
        }

        /// Returns a column from erd_instance as an array of type []T
        fn erdCollect(T: type, column_name: []const u8) [system_erds_length]T {
            var field_values: [system_erds_length]T = undefined;
            for (std.meta.fieldNames(ErdDefs), 0..) |erd_name, i| {
                field_values[i] = @field(@field(erd_instance, erd_name), column_name);
            }

            return field_values;
        }

        const component_idx_from_system_idx = erdCollect(u8, "component_idx");
        const data_component_idx_from_system_idx = erdCollect(u16, "data_component_idx");

        const supports_write_from_component_idx: [component_fields.len]bool = blk: {
            var result: [component_fields.len]bool = undefined;
            for (component_fields, 0..) |field, i| {
                result[i] = field.type.supports_write;
            }
            break :blk result;
        };

        /// The enum type used to reference ERDs by name.
        pub const ErdEnumType = ErdEnum;
        /// The comptime ERD definitions instance.
        pub const erds = erd_instance;

        /// Convert an ErdEnum value to its corresponding Erd definition.
        pub fn erdFromEnum(comptime erd_enum: ErdEnum) Erd {
            return @field(erd_instance, @tagName(erd_enum));
        }

        /// Read an ERD by-value using comptime information (the `Erd` type)
        /// Due to the performance and code size benefits, this should be preferred over `runtimeRead`.
        pub fn read(this: Self, comptime erd_enum: ErdEnum) erdFromEnum(erd_enum).T {
            const erd: Erd = erdFromEnum(erd_enum);
            const owner = comptime component_fields[erd.component_idx].name;
            return @field(this.components, owner).read(erd);
        }

        /// Read an ERD into the provided `data` pointer, using the ERD's corresponding system_data_idx
        /// This will be significantly slower than a comptime read, and should only be used sparingly, for example:
        /// - When mapping from an `ErdHandle` to system_data_idx, eg. in response to UART commands
        /// - Reading an ERD using info from an on-change callback
        // noinline so the dispatch logic is shared across all call sites.
        pub noinline fn runtimeRead(this: *const Self, system_data_idx: u16, data: *anyopaque) void {
            const component_idx = component_idx_from_system_idx[system_data_idx];
            const data_component_idx = data_component_idx_from_system_idx[system_data_idx];

            switch (component_idx) {
                inline 0...component_fields.len - 1 => |i| {
                    @field(this.components, component_fields[i].name).runtimeRead(data_component_idx, data);
                },
                else => unreachable,
            }
        }

        /// Write to an ERD by-value using comptime information (the `Erd` type)
        /// Due to the performance and code size benefits, this should be preferred over `runtimeWrite`.
        /// The owning data component handles change detection and publishes to subscribers.
        pub fn write(this: *Self, comptime erd_enum: ErdEnum, data: erdFromEnum(erd_enum).T) void {
            const erd: Erd = erdFromEnum(erd_enum);

            comptime {
                if (!supports_write_from_component_idx[erd.component_idx]) {
                    @compileError(std.fmt.comptimePrint(
                        "write({s}): this ERD's data component does not support writes",
                        .{@tagName(erd_enum)},
                    ));
                }
                if (@typeInfo(erd.T) == .@"struct" and std.meta.fields(erd.T).len >= 4) {
                    @compileError(std.fmt.comptimePrint(
                        "write({s}, {s}): use modify() instead. " ++
                            "Comptime RMW on primitives and small structs already optimizes cleanly, " ++
                            "but a {}-field struct benefits from modify()'s shared noinline body for code size.",
                        .{ @tagName(erd_enum), @typeName(erd.T), std.meta.fields(erd.T).len },
                    ));
                }
            }

            const owner = comptime component_fields[erd.component_idx].name;
            @field(this.components, owner).write(erd, data, @ptrCast(this));
        }

        /// Modify a struct ERD in-place and always publish, skipping change detection.
        /// Use when the modification is guaranteed to produce a new value.
        /// Debug-asserts that the value actually changed.
        pub fn modify(this: *Self, comptime erd_enum: ErdEnum, comptime modifier: *const fn (*erdFromEnum(erd_enum).T) void) void {
            const erd: Erd = erdFromEnum(erd_enum);

            comptime {
                if (!supports_write_from_component_idx[erd.component_idx]) {
                    @compileError(std.fmt.comptimePrint(
                        "modify({s}): this ERD's data component does not support writes",
                        .{@tagName(erd_enum)},
                    ));
                }
                if (@typeInfo(erd.T) != .@"struct") {
                    @compileError(std.fmt.comptimePrint(
                        "modify({s}, {s}): only valid for struct ERDs. " ++
                            "Primitive RMW patterns already optimize cleanly via write(); " ++
                            "modify() would bypass change detection without a code size benefit.",
                        .{ @tagName(erd_enum), @typeName(erd.T) },
                    ));
                }
            }

            const owner = comptime component_fields[erd.component_idx].name;
            @field(this.components, owner).modify(erd, modifier, @ptrCast(this));
        }

        /// Write to an ERD from the provided `data` pointer, using the ERD's corresponding system_data_idx
        /// This will be significantly slower than a comptime write, and should only be used sparingly, for example:
        /// - When mapping from an `ErdHandle` to system_data_idx, eg. in response to UART commands
        /// - Writing an ERD using info from an on-change callback (common for ERD multiplexers)
        ///
        /// `data` is copied byte-by-byte into storage; no specific alignment is
        /// required on the pointer.
        // noinline so the dispatch logic is shared across all call sites.
        pub noinline fn runtimeWrite(this: *Self, system_data_idx: u16, data: *const anyopaque) void {
            const component_idx = component_idx_from_system_idx[system_data_idx];
            const data_component_idx = data_component_idx_from_system_idx[system_data_idx];

            switch (component_idx) {
                inline 0...component_fields.len - 1 => |i| {
                    if (!supports_write_from_component_idx[i]) {
                        unreachable;
                    }
                    @field(this.components, component_fields[i].name).runtimeWrite(data_component_idx, data, @ptrCast(this));
                },
                else => unreachable,
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
            const erd: Erd = erdFromEnum(erd_enum);
            comptime {
                if (erd.subs == 0) @compileError(std.fmt.comptimePrint(
                    "subscribe({s}): ERD declares subs = 0; raise its `.subs` to allow subscriptions",
                    .{@tagName(erd_enum)},
                ));
            }

            const owner = comptime component_fields[erd.component_idx].name;
            @field(this.components, owner).subs.subscribe(erd, context, fn_ptr);
        }

        /// Remove a subscription from an ERD by callback identity.
        pub fn unsubscribe(this: *Self, comptime erd_enum: ErdEnum, fn_ptr: Subscription.Callback) void {
            const erd: Erd = erdFromEnum(erd_enum);
            comptime {
                if (erd.subs == 0) @compileError(std.fmt.comptimePrint(
                    "unsubscribe({s}): ERD declares subs = 0; no subscriptions are possible",
                    .{@tagName(erd_enum)},
                ));
            }

            const owner = comptime component_fields[erd.component_idx].name;
            @field(this.components, owner).subs.unsubscribe(erd, fn_ptr);
        }

        /// Returns a slice allocated to the scratch buffer.
        pub fn scratchAlloc(this: *Self, T: type, n: usize) []T {
            return this.scratch.allocator().alloc(T, n) catch @panic("We ran out of scratch memory!!!");
        }

        /// Call this at the end of a run to complete in your main-loop
        pub fn scratchReset(this: *Self) void {
            this.scratch.reset();
        }

        /// Verify that after initialization, every ERD's subscription slots
        /// are filled (modulo `exceptions` which list ERDs that are
        /// intentionally under-subscribed by `missing` slots). Intended
        /// for use at the end of `Application.init` to catch
        /// over-/under-subscribed ERDs before the main loop.
        ///
        /// Pass a non-null `diagnostics` writer to receive per-ERD failure
        /// messages (which ERD, under vs over). Tests typically pass `null`
        /// because they assert on the error return; production init paths
        /// can pass a `std.Io.Writer` (e.g. backed by stderr) to learn
        /// which ERD is wrong without crashing.
        pub fn verifyAllSubsAreSaturated(
            this: *Self,
            comptime exceptions: []const SubException,
            diagnostics: ?*std.Io.Writer,
        ) error{ ErdWithNoSubsInExceptions, ErdWithUnexpectedSubCount, WriteFailed }!void {
            comptime {
                // Reject `missing > subs` at compile time so the runtime
                // expected-count arithmetic stays in non-negative territory.
                for (exceptions) |e| {
                    const erd_subs = @field(erd_instance, @tagName(e.erd_enum)).subs;
                    if (e.missing > erd_subs) {
                        @compileError(std.fmt.comptimePrint(
                            "SubException for {s}: missing ({}) cannot exceed declared subs ({})",
                            .{ @tagName(e.erd_enum), e.missing, erd_subs },
                        ));
                    }
                }
            }

            var failed = false;

            inline for (exceptions) |e| {
                const erd_name = @tagName(e.erd_enum);
                const num_subs = @field(erd_instance, erd_name).subs;
                if (num_subs == 0) {
                    if (diagnostics) |w| try w.print("Remove {s} from exceptions list since subscriptions are disabled for it\n", .{erd_name});
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

                var actual_count: u16 = 0;
                const sub_field = &@field(this.components, component_fields[erd.component_idx].name).subs;
                const SubscriptionType = @TypeOf(sub_field.*);
                const offset = SubscriptionType.sub_offsets[erd.data_component_idx];
                for (sub_field.slots[offset .. offset + num_subs]) |sub| {
                    if (sub.callback != null) {
                        actual_count += 1;
                    }
                }

                if (actual_count < expected_count) {
                    if (diagnostics) |w| try w.print("ERD: {s} is under-subscribing after init. Decrease subs, or increase missing.\n", .{erd_name});
                    failed = true;
                } else if (actual_count > expected_count) {
                    if (diagnostics) |w| try w.print("ERD: {s} is over-subscribed after init. Increase subs or decrease missing.\n", .{erd_name});
                    failed = true;
                }
            }

            if (failed) {
                return error.ErdWithUnexpectedSubCount;
            }
        }
    };
}
