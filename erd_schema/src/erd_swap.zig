//! Comptime endian swap rule generation for wire serialization.
//!
//! Generates a minimal set of byte-swap rules for any extern/packed struct type.
//! Rules describe which byte ranges need their byte order reversed when converting
//! between native and wire (big-endian) byte order.
//!
//! Usage:
//!   const rules = comptime SwapRules(MyExternStruct);
//!   var buf: [@sizeOf(MyExternStruct)]u8 = std.mem.toBytes(value);
//!   rules.applyToNative(&buf);  // native -> big-endian
//!   // ... send buf over wire ...
//!   rules.applyToNative(&buf);  // big-endian -> native (same operation)
//!
//! Types with identical swap patterns share the same rule set at comptime.
//! Single-byte fields (u8, bool, [N]u8 strings) produce no swap rules.

const std = @import("std");

pub const SwapRule = struct {
    offset: u16,
    size: u8,
};

/// Generate swap rules for a type. Returns a comptime slice of SwapRule.
/// Each rule says "at byte offset, reverse `size` bytes."
pub fn SwapRules(T: type) type {
    const rules = comptime generateRules(T, 0);
    return struct {
        pub const swap_rules: [rules.len]SwapRule = rules[0..rules.len].*;

        /// Apply byte swaps in-place. Idempotent: applying twice restores original.
        pub fn apply(buf: []u8) void {
            for (swap_rules) |rule| {
                const start = rule.offset;
                const end = start + rule.size;
                if (end <= buf.len) {
                    std.mem.reverse(u8, buf[start..end]);
                }
            }
        }

        pub fn ruleCount() comptime_int {
            return rules.len;
        }
    };
}

fn generateRules(T: type, comptime base_offset: u16) []const SwapRule {
    @setEvalBranchQuota(100_000);
    const info = @typeInfo(T);

    switch (info) {
        .int => {
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
        else => return &.{},
    }
}
