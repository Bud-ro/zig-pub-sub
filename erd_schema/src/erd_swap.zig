//! Comptime endian swap rule generation for wire serialization.
//!
//! Generates a minimal set of byte-swap rules for any extern/packed struct type.
//! Rules describe which byte ranges need their byte order reversed when converting
//! between native and wire (big-endian) byte order.
//!
//! Usage:
//!   const Rules = SwapRules(MyExternStruct);
//!   const wire_bytes = Rules.toBig(value);     // native -> big-endian
//!   // ... send wire_bytes over wire ...
//!   const native = Rules.fromBig(&wire_bytes); // big-endian -> native
//!
//! `toBig`/`fromBig` handle the static fields and the active tagged-union
//! variant (when present). Lower-level: `apply(buf)` does only the static
//! field swaps (idempotent), and is what `toBig`/`fromBig` call internally.
//!
//! Types with identical swap patterns share the same rule set at comptime.
//! Single-byte fields (u8, bool, [N]u8 strings) produce no swap rules.

const std = @import("std");

/// A single byte-reversal operation: reverse `size` bytes starting at `offset`.
pub const SwapRule = struct {
    /// Byte offset within the buffer where the reversal starts.
    offset: u16,
    /// Number of bytes to reverse.
    size: u8,
};

/// Apply a list of swap rules to `buf` in-place. Each rule that fits within the
/// buffer reverses its byte range; out-of-bounds rules are silently skipped.
fn applyRules(comptime rules: []const SwapRule, buf: []u8) void {
    for (rules) |rule| {
        const start = rule.offset;
        const end = start + rule.size;
        if (end <= buf.len) {
            std.mem.reverse(u8, buf[start..end]);
        }
    }
}

/// Generate swap rules for a specific union variant, offset within a parent struct.
/// Usage for tagged union pattern (extern struct { tag: enum(u8), payload: extern union }):
///   const tag_rules = SwapRules(TagEnum);
///   // After reading tag:
///   switch (tag) {
///       .temperature => SwapVariant(PayloadUnion, "temperature", payload_offset).apply(&buf),
///       .error_code => SwapVariant(PayloadUnion, "error_code", payload_offset).apply(&buf),
///   }
pub fn SwapVariant(UnionType: type, comptime field_name: []const u8, comptime base_offset: u16) type {
    const union_info = @typeInfo(UnionType).@"union";
    const FieldType = blk: {
        for (union_info.fields) |f| {
            if (std.mem.eql(u8, f.name, field_name)) break :blk f.type;
        }
        @compileError("Union has no field named '" ++ field_name ++ "'");
    };
    const rules = comptime generateRules(FieldType, base_offset);
    return struct {
        /// The swap rules for this union variant at the given offset.
        pub const swap_rules: [rules.len]SwapRule = rules[0..rules.len].*;

        /// Apply byte swaps for this variant in-place.
        pub fn apply(buf: []u8) void {
            applyRules(&swap_rules, buf);
        }

        /// Number of swap rules for this variant.
        pub fn ruleCount() comptime_int {
            return rules.len;
        }
    };
}

/// Generate swap rules for a type. Returns a comptime slice of SwapRule.
/// Each rule says "at byte offset, reverse `size` bytes."
pub fn SwapRules(T: type) type {
    const rules = comptime generateRules(T, 0);
    return struct {
        /// The static swap rules for this type (excludes union variant swaps).
        pub const swap_rules: [rules.len]SwapRule = rules[0..rules.len].*;

        /// Apply static byte swaps in-place. Idempotent.
        /// Does NOT handle tagged union variants. Use fromBig/toBig instead.
        pub fn apply(buf: []u8) void {
            applyRules(&swap_rules, buf);
        }

        fn applyTaggedUnions(buf: []u8) void {
            // Check if T itself is a tagged union pattern
            applyTaggedUnionsInField(T, 0, buf);
            // Also check nested struct fields
            const info = @typeInfo(T);
            switch (info) {
                .@"struct" => |si| {
                    if (si.layout == .@"extern") {
                        inline for (si.fields) |field| {
                            applyTaggedUnionsInField(field.type, @offsetOf(T, field.name), buf);
                        }
                    }
                },
                else => {},
            }
        }

        fn applyTaggedUnionsInField(FieldType: type, comptime field_offset: u16, buf: []u8) void {
            const fi = @typeInfo(FieldType);
            switch (fi) {
                .@"struct" => |si| {
                    if (si.layout != .@"extern" or si.fields.len != 2) return;
                    if (!std.mem.eql(u8, si.fields[0].name, "tag")) return;
                    const union_info = @typeInfo(si.fields[1].type);
                    if (union_info != .@"union") return;

                    const tag_offset = field_offset + @as(u16, @intCast(@offsetOf(FieldType, "tag")));
                    const union_offset = field_offset + @as(u16, @intCast(@offsetOf(FieldType, si.fields[1].name)));
                    const TagType = si.fields[0].type;
                    const tag_size = @sizeOf(TagType);

                    if (tag_offset + tag_size > buf.len) return;
                    // Tag has already been swapped to native by the static rules
                    const tag_val = readTagValue(buf[tag_offset..][0..tag_size]);

                    inline for (union_info.@"union".fields, 0..) |uf, i| {
                        if (tag_val == i) {
                            const variant_rules = comptime generateRules(uf.type, union_offset);
                            applyRules(variant_rules, buf);
                        }
                    }
                },
                else => {},
            }
        }

        const native_endian = @import("builtin").cpu.arch.endian();

        fn readTagValue(bytes: []const u8) u64 {
            return switch (bytes.len) {
                1 => bytes[0],
                2 => std.mem.readInt(u16, bytes[0..2], native_endian),
                4 => std.mem.readInt(u32, bytes[0..4], native_endian),
                else => 0,
            };
        }

        /// Number of static swap rules for this type.
        pub fn ruleCount() comptime_int {
            return rules.len;
        }

        /// Convert big-endian wire bytes to a native T in one shot.
        /// Handles tagged unions automatically.
        pub fn fromBig(be_bytes: *const [@sizeOf(T)]u8) T {
            var buf: [@sizeOf(T)]u8 = be_bytes.*;
            // Swap statics first so the tag becomes native-readable
            apply(&buf);
            // Then swap the active union variant
            applyTaggedUnions(&buf);
            return @bitCast(buf);
        }

        /// Convert a native T to big-endian wire bytes in one shot.
        /// Handles tagged unions automatically.
        pub fn toBig(value: T) [@sizeOf(T)]u8 {
            var buf: [@sizeOf(T)]u8 = @bitCast(value);
            // Swap union variants first while the tag is still native
            applyTaggedUnions(&buf);
            // Then swap all static fields (including the tag)
            apply(&buf);
            return buf;
        }
    };
}

fn generateRules(T: type, comptime base_offset: u16) []const SwapRule {
    @setEvalBranchQuota(100_000);
    const info = @typeInfo(T);

    switch (info) {
        .int, .float => {
            const size = @sizeOf(T);
            if (size <= 1) return &.{};
            return &.{SwapRule{ .offset = base_offset, .size = @intCast(size) }};
        },
        .bool => return &.{},
        .@"enum" => |enum_info| {
            const size = @sizeOf(enum_info.tag_type);
            if (size <= 1) return &.{};
            return &.{SwapRule{ .offset = base_offset, .size = @intCast(size) }};
        },
        .@"struct" => |struct_info| {
            if (struct_info.layout == .auto) {
                @compileError("Cannot generate swap rules for auto-layout struct '" ++
                    @typeName(T) ++ "': field order is not deterministic");
            }
            if (struct_info.layout == .@"packed") {
                const size = @sizeOf(T);
                if (size <= 1) return &.{};
                return &.{SwapRule{ .offset = base_offset, .size = @intCast(size) }};
            }
            // extern struct: recurse into each field
            var rules: []const SwapRule = &.{};
            for (struct_info.fields) |field| {
                const offset = @offsetOf(T, field.name);
                const field_rules = generateRules(field.type, base_offset + @as(u16, @intCast(offset)));
                rules = rules ++ field_rules;
            }
            return rules;
        },
        .array => |array_info| {
            if (array_info.child == u8) return &.{};
            const elem_size = @sizeOf(array_info.child);
            var rules: []const SwapRule = &.{};
            for (0..array_info.len) |i| {
                const offset = base_offset + @as(u16, @intCast(i * elem_size));
                const elem_rules = generateRules(array_info.child, offset);
                rules = rules ++ elem_rules;
            }
            return rules;
        },
        .@"union" => |union_info| {
            if (union_info.layout != .@"extern") {
                @compileError("Cannot generate swap rules for non-extern union '" ++
                    @typeName(T) ++ "'");
            }
            // Extern unions overlay all fields at offset 0.
            // We can only swap if all fields agree on the swap pattern at each offset.
            // For simplicity, generate no rules (caller must swap per-field after
            // determining the active variant via the tag).
            return &.{};
        },
        .vector => @compileError("Cannot generate swap rules for vector type '" ++
            @typeName(T) ++ "': vectors have no guaranteed byte layout"),
        else => @compileError("Cannot generate swap rules for type '" ++
            @typeName(T) ++ "': unsupported type category"),
    }
}
