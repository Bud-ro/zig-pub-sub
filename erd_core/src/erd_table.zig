//! Helpers for populating an `ErdDefinitions` struct.
//!
//! Application-level ERD tables declare each field with a fixed
//! `component_idx` and rely on the table-init code to assign the
//! per-component `data_component_idx` and the global `system_data_idx`
//! based on field order. This module centralizes that bookkeeping so
//! each application doesn't have to repeat the same comptime ritual.

const Erd = @import("Erd.zig");
const std = @import("std");

/// Returns an ErdDefinitions instance with `data_component_idx` and
/// `system_data_idx` filled in based on `component_idx` and field order.
///
/// Usage:
/// ```
/// pub const erd = erd_core.erd_table.autofill(ErdDefinitions);
/// ```
pub fn autofill(ErdDefs: type) ErdDefs {
    var erds = ErdDefs{};

    var max_component_idx: comptime_int = 0;
    for (std.meta.fieldNames(ErdDefs)) |field_name| {
        const idx = @field(erds, field_name).component_idx;
        if (idx > max_component_idx) max_component_idx = idx;
    }

    var owning_counts = std.mem.zeroes([max_component_idx + 1]u16);
    for (std.meta.fieldNames(ErdDefs), 0..) |field_name, i| {
        const idx = @field(erds, field_name).component_idx;
        @field(erds, field_name).data_component_idx = owning_counts[idx];
        @field(erds, field_name).system_data_idx = i;
        owning_counts[idx] += 1;
    }

    return erds;
}

/// Count ERDs in `erd_instance` whose `component_idx` matches `component_idx`.
pub fn numErdsByComponent(comptime erd_instance: anytype, comptime component_idx: u8) comptime_int {
    var count = 0;
    for (std.meta.fieldNames(@TypeOf(erd_instance))) |field_name| {
        if (@field(erd_instance, field_name).component_idx == component_idx) count += 1;
    }
    return count;
}

/// Extract ERD definitions whose `component_idx` matches into a fixed-size array.
pub fn collectByComponent(comptime erd_instance: anytype, comptime component_idx: u8) [numErdsByComponent(erd_instance, component_idx)]Erd {
    var result: [numErdsByComponent(erd_instance, component_idx)]Erd = undefined;
    var i = 0;
    for (std.meta.fieldNames(@TypeOf(erd_instance))) |field_name| {
        if (@field(erd_instance, field_name).component_idx == component_idx) {
            result[i] = @field(erd_instance, field_name);
            i += 1;
        }
    }
    return result;
}

/// Comptime-checks that `ErdEnum`'s variant names match `ErdDefs`'s field
/// names 1:1 in order. Apps can call this from inside `ErdEnum`'s comptime
/// block to surface mismatches at ErdEnum-definition time instead of waiting
/// for SystemData construction. SystemData itself runs the equivalent check
/// independently, so calling this is optional.
pub fn validateEnumMatchesDefs(ErdEnum: type, ErdDefs: type) void {
    const erd_fields = std.meta.fieldNames(ErdDefs);
    const erd_enum_names = std.meta.fieldNames(ErdEnum);
    if (erd_fields.len != erd_enum_names.len) {
        @compileError(std.fmt.comptimePrint(
            "ErdEnum has {} variant(s) but ErdDefs has {} field(s); they must match 1:1 in order",
            .{ erd_enum_names.len, erd_fields.len },
        ));
    }
    for (erd_fields, erd_enum_names) |field_name, enum_name| {
        if (!std.mem.eql(u8, field_name, enum_name)) {
            @compileError(std.fmt.comptimePrint(
                "ErdDefs field {s} does not match ErdEnum variant {s}",
                .{ field_name, enum_name },
            ));
        }
    }
}

const testing = std.testing;

const TestDefs = struct {
    ram_a: Erd = .{ .erd_number = 0x0001, .T = u32, .component_idx = 0, .subs = 0 },
    ram_b: Erd = .{ .erd_number = null, .T = u8, .component_idx = 0, .subs = 1 },
    indirect_a: Erd = .{ .erd_number = 0x0003, .T = u16, .component_idx = 1, .subs = 0 },
    ram_c: Erd = .{ .erd_number = 0x0004, .T = bool, .component_idx = 0, .subs = 0 },
    converted_a: Erd = .{ .erd_number = null, .T = u32, .component_idx = 2, .subs = 2 },
};

test "autofill assigns system_data_idx in field order" {
    const filled = autofill(TestDefs);
    try testing.expectEqual(0, filled.ram_a.system_data_idx);
    try testing.expectEqual(1, filled.ram_b.system_data_idx);
    try testing.expectEqual(2, filled.indirect_a.system_data_idx);
    try testing.expectEqual(3, filled.ram_c.system_data_idx);
    try testing.expectEqual(4, filled.converted_a.system_data_idx);
}

test "autofill assigns data_component_idx per-component" {
    const filled = autofill(TestDefs);
    // Ram (component_idx=0): a, b, c in field order
    try testing.expectEqual(0, filled.ram_a.data_component_idx);
    try testing.expectEqual(1, filled.ram_b.data_component_idx);
    try testing.expectEqual(2, filled.ram_c.data_component_idx);
    // Indirect (component_idx=1): only a
    try testing.expectEqual(0, filled.indirect_a.data_component_idx);
    // Converted (component_idx=2): only a
    try testing.expectEqual(0, filled.converted_a.data_component_idx);
}

test "autofill preserves original ERD fields" {
    const filled = autofill(TestDefs);
    try testing.expectEqual(@as(?Erd.ErdHandle, 0x0001), filled.ram_a.erd_number);
    try testing.expectEqual(u32, filled.ram_a.T);
    try testing.expectEqual(0, filled.ram_a.component_idx);
    try testing.expectEqual(0, filled.ram_a.subs);
    try testing.expectEqual(1, filled.ram_b.subs);
    try testing.expectEqual(2, filled.converted_a.subs);
}

test "numErdsByComponent counts only matching component" {
    const filled = autofill(TestDefs);
    try testing.expectEqual(3, numErdsByComponent(filled, 0)); // ram_a, ram_b, ram_c
    try testing.expectEqual(1, numErdsByComponent(filled, 1)); // indirect_a
    try testing.expectEqual(1, numErdsByComponent(filled, 2)); // converted_a
    try testing.expectEqual(0, numErdsByComponent(filled, 3)); // none
}

test "collectByComponent returns ERDs in field order" {
    const filled = autofill(TestDefs);
    const ram = collectByComponent(filled, 0);
    try testing.expectEqual(3, ram.len);
    try testing.expectEqual(0x0001, ram[0].erd_number.?);
    try testing.expectEqual(@as(?Erd.ErdHandle, null), ram[1].erd_number);
    try testing.expectEqual(0x0004, ram[2].erd_number.?);

    const indirect = collectByComponent(filled, 1);
    try testing.expectEqual(1, indirect.len);
    try testing.expectEqual(0x0003, indirect[0].erd_number.?);
}

test "validateEnumMatchesDefs accepts matching enum and struct" {
    // Compiles cleanly only if the helper accepts the matched pair.
    comptime validateEnumMatchesDefs(enum { ram_a, ram_b, indirect_a, ram_c, converted_a }, TestDefs);
}
