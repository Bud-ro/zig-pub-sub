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
    inline for (rules) |rule| {
        const end = rule.offset + @as(usize, rule.size);
        if (end <= buf.len) {
            swapRange(buf, rule.offset, rule.size);
        }
    }
}

/// Reverse `size` bytes of `buf` starting at comptime `offset`. For native
/// integer widths (2, 4, 8) this lowers to a single byte-swap instruction
/// (`bswap` on x86, `rev` on ARM, etc.). Wider fields (16-byte `u128`/`i128`/
/// `f128`) fall back to the generic element reverse; smaller odd widths never
/// occur because rule sizes come from `@sizeOf`, which rounds every scalar up
/// to a power-of-two ABI size. Using `@byteSwap` instead of `std.mem.reverse`
/// avoids the SSE shuffle sequence LLVM emits for fixed reversals on x86 and,
/// more importantly, the byte-at-a-time loop it emits on embedded targets that
/// lack vector units. `buf` may be unaligned, so the load/store go through an
/// align(1) pointer.
inline fn swapRange(buf: []u8, comptime offset: u16, comptime size: u8) void {
    switch (size) {
        2 => swapInt(u16, buf, offset),
        4 => swapInt(u32, buf, offset),
        8 => swapInt(u64, buf, offset),
        else => std.mem.reverse(u8, buf[offset .. offset + size]),
    }
}

inline fn swapInt(Int: type, buf: []u8, comptime offset: u16) void {
    const p: *align(1) Int = @ptrCast(buf[offset..][0..@sizeOf(Int)]);
    p.* = @byteSwap(p.*);
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

        /// Convert native-endian bytes to big-endian wire bytes in-place,
        /// including the active tagged-union variant. This is the byte-buffer
        /// equivalent of `toBig` for type-erased callers that already hold the
        /// value as raw bytes (e.g. `WirePublisher`'s shared handler, which
        /// cannot call the value-typed `toBig`). `buf` must be exactly
        /// `@sizeOf(T)` bytes of a valid native-endian T. Operates purely on
        /// bytes, so it imposes no alignment requirement on `buf`.
        pub fn applyToBig(buf: []u8) void {
            // Swap the active union variant first while the tag is still
            // native-readable, then swap all static fields (including the
            // tag). Mirrors the ordering in `toBig`.
            applyTaggedUnions(buf);
            apply(buf);
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

/// Returns true if `applyToBig` can change the bytes of a `T` value, so the
/// wire publisher can skip the conversion for types that are already
/// wire-identical (u8/bool, all-byte structs, `[N]u8`). This is defined to
/// mirror `applyToBig` EXACTLY: a swap is reported iff `T` has a multi-byte
/// static field (`generateRules`) or a multi-byte tagged-union variant within
/// the SAME scan scope `applyTaggedUnions` walks -- the top-level type and the
/// direct fields of a top-level extern struct. A tagged union nested deeper
/// than that is not swapped by `applyToBig` and is likewise reported as
/// no-swap here, so the two stay consistent: skipping never drops a swap that
/// `applyToBig` would have performed.
pub fn needsSwap(T: type) bool {
    if (generateRules(T, 0).len > 0) return true;
    if (taggedVariantNeedsSwap(T)) return true;
    const info = @typeInfo(T);
    if (info == .@"struct" and info.@"struct".layout == .@"extern") {
        inline for (info.@"struct".fields) |field| {
            if (taggedVariantNeedsSwap(field.type)) return true;
        }
    }
    return false;
}

/// True if `FieldType` is the recognized tagged-union pattern (extern struct
/// `{ tag, payload: extern union }`) and some union variant has a multi-byte
/// field that the variant swap would reverse.
fn taggedVariantNeedsSwap(FieldType: type) bool {
    const fi = @typeInfo(FieldType);
    if (fi != .@"struct") return false;
    const si = fi.@"struct";
    if (si.layout != .@"extern" or si.fields.len != 2) return false;
    if (!std.mem.eql(u8, si.fields[0].name, "tag")) return false;
    const ui = @typeInfo(si.fields[1].type);
    if (ui != .@"union") return false;
    inline for (ui.@"union".fields) |uf| {
        if (generateRules(uf.type, 0).len > 0) return true;
    }
    return false;
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
