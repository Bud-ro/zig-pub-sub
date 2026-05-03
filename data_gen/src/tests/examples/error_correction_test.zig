const std = @import("std");
const constraint = @import("data_gen").constraint;
const contract = @import("data_gen").contract;
const generator = @import("data_gen").generator;

// --- Hamming(7,4) Code Table ---
// Each 4-bit data word maps to a 7-bit codeword.
// Parity bits at positions 1, 2, 4 (1-indexed) are computed from data bits.
// The table must contain all 16 possible data words, each with the correct
// parity bits, and the minimum Hamming distance between any two codewords
// must be exactly 3 (single error correcting).

const HammingEntry = struct {
    data: u4,
    codeword: u7,
};

fn hammingEncode(comptime data: u4) u7 {
    // Bit layout (1-indexed): p1 p2 d1 p4 d2 d3 d4
    // In 0-indexed u7: bit6=p1, bit5=p2, bit4=d1, bit3=p4, bit2=d2, bit1=d3, bit0=d4
    const d1: u1 = @truncate(data >> 3);
    const d2: u1 = @truncate(data >> 2);
    const d3: u1 = @truncate(data >> 1);
    const d4: u1 = @truncate(data);

    const p1 = d1 ^ d2 ^ d4;
    const p2 = d1 ^ d3 ^ d4;
    const p4 = d2 ^ d3 ^ d4;

    return @as(u7, p1) << 6 |
        @as(u7, p2) << 5 |
        @as(u7, d1) << 4 |
        @as(u7, p4) << 3 |
        @as(u7, d2) << 2 |
        @as(u7, d3) << 1 |
        @as(u7, d4);
}

fn hammingDistance(comptime a: u7, comptime b: u7) u4 {
    const xor = a ^ b;
    var count: u4 = 0;
    inline for (0..7) |bit| {
        if ((xor >> @intCast(bit)) & 1 == 1) count += 1;
    }
    return count;
}

fn validateHammingTable(comptime table: []const HammingEntry) void {
    @setEvalBranchQuota(5000);

    if (table.len != 16)
        @compileError("Hamming(7,4) table must have exactly 16 entries");

    // Every 4-bit data value must appear exactly once
    var data_seen = [_]bool{false} ** 16;
    for (table) |entry| {
        if (data_seen[entry.data])
            @compileError(std.fmt.comptimePrint("duplicate data value {}", .{entry.data}));
        data_seen[entry.data] = true;

        // Verify parity bits are correct
        const expected = hammingEncode(entry.data);
        if (entry.codeword != expected)
            @compileError(std.fmt.comptimePrint(
                "data {} has codeword 0b{b:0>7} but expected 0b{b:0>7}",
                .{ entry.data, entry.codeword, expected },
            ));
    }

    // Minimum Hamming distance between any two codewords must be 3
    var min_dist: u4 = 7;
    for (0..table.len) |i| {
        for (i + 1..table.len) |j| {
            const dist = hammingDistance(table[i].codeword, table[j].codeword);
            if (dist < min_dist) min_dist = dist;
        }
    }
    if (min_dist != 3)
        @compileError(std.fmt.comptimePrint(
            "minimum Hamming distance is {} (expected 3 for single-error correction)",
            .{min_dist},
        ));
}

const hamming_table = blk: {
    const gen = struct {
        fn f(comptime i: usize) HammingEntry {
            const data: u4 = @intCast(i);
            return .{ .data = data, .codeword = hammingEncode(data) };
        }
    }.f;
    const table = generator.generateArray(HammingEntry, 16, gen);
    validateHammingTable(&table);
    break :blk table;
};

test "Hamming table has 16 entries" {
    comptime {
        try std.testing.expectEqual(16, hamming_table.len);
    }
}

test "Hamming table data 0 encodes to all zeros" {
    comptime {
        try std.testing.expectEqual(0, hamming_table[0].data);
        try std.testing.expectEqual(0, hamming_table[0].codeword);
    }
}

test "Hamming table data 15 encodes correctly" {
    comptime {
        try std.testing.expectEqual(15, hamming_table[15].data);
        try std.testing.expectEqual(hammingEncode(15), hamming_table[15].codeword);
    }
}

test "Hamming table minimum distance is 3" {
    comptime {
        @setEvalBranchQuota(5000);
        var min_dist: u4 = 7;
        for (0..hamming_table.len) |i| {
            for (i + 1..hamming_table.len) |j| {
                const dist = hammingDistance(hamming_table[i].codeword, hamming_table[j].codeword);
                if (dist < min_dist) min_dist = dist;
            }
        }
        try std.testing.expectEqual(3, min_dist);
    }
}

test "Hamming table all parity bits are correct" {
    comptime {
        for (hamming_table) |entry| {
            try std.testing.expectEqual(hammingEncode(entry.data), entry.codeword);
        }
    }
}

// --- CRC Polynomial Validation ---
// CRC polynomials have specific mathematical properties that make them
// effective for error detection. The polynomial must be of the correct
// degree and must be "primitive" (not factorable into lower-degree polys
// over GF(2) in useful ways). We check basic structural properties.

const CrcConfig = struct {
    width: u8,
    poly: u32,
    init: u32,
    xor_out: u32,
    reflect_in: bool,
    reflect_out: bool,

    pub fn contractValidate(comptime self: CrcConfig) ?[]const u8 {
        if (self.width != 8 and self.width != 16 and self.width != 32)
            return "width must be one of 8, 16, 32";

        // Values must fit within width (standard representation omits the implicit x^n MSB)
        const mask: u32 = if (self.width == 32) 0xFFFFFFFF else (@as(u32, 1) << @intCast(self.width)) - 1;
        if (self.poly & ~mask != 0)
            return "polynomial exceeds declared width";
        if (self.init & ~mask != 0)
            return "init value exceeds declared width";
        if (self.xor_out & ~mask != 0)
            return "xor_out value exceeds declared width";

        if (self.poly == 0) return "poly must not be zero";

        // LSB must be set (polynomial must be odd for single-bit error detection)
        if (self.poly & 1 == 0)
            return "CRC polynomial must be odd (LSB set) for single-bit error detection";
        return null;
    }
};

test "CRC-8 CCITT config" {
    comptime {
        const crc8 = CrcConfig{
            .width = 8,
            .poly = 0x07,
            .init = 0x00,
            .xor_out = 0x00,
            .reflect_in = false,
            .reflect_out = false,
        };
        contract.assertValid(crc8);
        try std.testing.expectEqual(8, crc8.width);
    }
}

test "CRC-16 CCITT config" {
    comptime {
        const crc16 = CrcConfig{
            .width = 16,
            .poly = 0x1021,
            .init = 0xFFFF,
            .xor_out = 0x0000,
            .reflect_in = false,
            .reflect_out = false,
        };
        contract.assertValid(crc16);
    }
}

test "CRC-32 IEEE config" {
    comptime {
        const crc32 = CrcConfig{
            .width = 32,
            .poly = 0x04C11DB7,
            .init = 0xFFFFFFFF,
            .xor_out = 0xFFFFFFFF,
            .reflect_in = true,
            .reflect_out = true,
        };
        contract.assertValid(crc32);
    }
}
