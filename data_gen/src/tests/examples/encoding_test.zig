const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;

// --- Prefix-Free Encoding Table ---
// A set of binary codes where no code is a prefix of any other code.
// This is the fundamental property required for unambiguous decoding
// (Huffman codes, VLC tables, etc.).

const CodeEntry = struct {
    symbol: u8,
    code: u16,
    length: u4,

    pub fn validate(comptime self: CodeEntry) ?[]const u8 {
        if (constraints.inRange(1, 15, self.length)) |err| return err;

        // Code must fit within declared length
        const max_val: u16 = (@as(u16, 1) << self.length) - 1;
        if (self.code > max_val)
            return std.fmt.comptimePrint(
                "code 0x{x} exceeds {}-bit capacity",
                .{ self.code, self.length },
            );
        return null;
    }
};

const PrefixFreeTable = struct {
    codes: []const CodeEntry,

    pub fn validate(comptime self: PrefixFreeTable) ?[]const u8 {
        @setEvalBranchQuota(10_000);
        if (constraints.lenInRange(2, 64, self.codes.len)) |err| return err;

        var symbols: [self.codes.len]u8 = undefined;
        for (self.codes, 0..) |entry, i| {
            symbols[i] = entry.symbol;
        }
        if (constraints.noDuplicates(u8, &symbols)) |err| return err;

        // Prefix-free check: for every pair of codes, neither is a prefix of the other
        for (0..self.codes.len) |i| {
            for (i + 1..self.codes.len) |j| {
                const a = self.codes[i];
                const b = self.codes[j];

                // The shorter code is a potential prefix of the longer one
                if (a.length <= b.length) {
                    // Shift b's code right to align with a's length
                    const b_prefix = b.code >> (b.length - a.length);
                    if (b_prefix == a.code)
                        return std.fmt.comptimePrint(
                            "code for symbol {} (len={}) is a prefix of code for symbol {} (len={})",
                            .{ a.symbol, a.length, b.symbol, b.length },
                        );
                } else {
                    const a_prefix = a.code >> (a.length - b.length);
                    if (a_prefix == b.code)
                        return std.fmt.comptimePrint(
                            "code for symbol {} (len={}) is a prefix of code for symbol {} (len={})",
                            .{ b.symbol, b.length, a.symbol, a.length },
                        );
                }
            }
        }

        return null;
    }
};

const KraftCheck = struct {
    codes: []const CodeEntry,

    pub fn validate(comptime self: KraftCheck) ?[]const u8 {
        // Kraft's inequality: sum(2^(-length_i)) <= 1
        // We compute as sum(2^(max_len - length_i)) <= 2^max_len
        var max_len: u4 = 0;
        for (self.codes) |c| {
            if (c.length > max_len) max_len = c.length;
        }

        var kraft_sum: u32 = 0;
        for (self.codes) |c| {
            kraft_sum += @as(u32, 1) << (max_len - c.length);
        }

        const kraft_limit: u32 = @as(u32, 1) << max_len;
        if (kraft_sum > kraft_limit)
            return std.fmt.comptimePrint(
                "Kraft inequality violated: sum {} > limit {}",
                .{ kraft_sum, kraft_limit },
            );

        return null;
    }
};

const huffman_table = blk: {
    // A valid Huffman-like code for 8 symbols
    const codes = [_]CodeEntry{
        .{ .symbol = 'e', .code = 0b00, .length = 2 },
        .{ .symbol = 't', .code = 0b010, .length = 3 },
        .{ .symbol = 'a', .code = 0b011, .length = 3 },
        .{ .symbol = 'o', .code = 0b100, .length = 3 },
        .{ .symbol = 'i', .code = 0b1010, .length = 4 },
        .{ .symbol = 'n', .code = 0b1011, .length = 4 },
        .{ .symbol = 's', .code = 0b1100, .length = 4 },
        .{ .symbol = 'r', .code = 0b1101, .length = 4 },
        .{ .symbol = 'h', .code = 0b1110, .length = 4 },
        .{ .symbol = 'l', .code = 0b1111, .length = 4 },
    };
    break :blk contracts.validated(PrefixFreeTable{ .codes = &codes }).codes;
};

// Validate Kraft inequality separately (it's a different property)
comptime {
    contracts.assertValid(KraftCheck{ .codes = huffman_table });
}

test "huffman table is prefix-free" {
    comptime {
        try std.testing.expectEqual(10, huffman_table.len);
    }
}

test "huffman table satisfies Kraft inequality" {
    comptime {
        var max_len: u4 = 0;
        for (huffman_table) |c| {
            if (c.length > max_len) max_len = c.length;
        }
        var kraft_sum: u32 = 0;
        for (huffman_table) |c| {
            kraft_sum += @as(u32, 1) << (max_len - c.length);
        }
        try std.testing.expect(kraft_sum <= @as(u32, 1) << max_len);
    }
}

test "huffman table has unique symbols" {
    comptime {
        var syms: [huffman_table.len]u8 = undefined;
        for (huffman_table, 0..) |c, i| syms[i] = c.symbol;
        // noDuplicates is already checked by PrefixFreeTable.validate
        // but we verify it independently in this test
        if (constraints.noDuplicates(u8, &syms)) |err| {
            @compileError(err);
        }
    }
}

// --- Command Encoding Table ---
// Fixed-length opcode with variable-length operand encoding.
// Opcodes must be unique. Operand encoding must not exceed
// the maximum instruction width.

const Opcode = enum(u8) {
    nop = 0x00,
    load = 0x01,
    store = 0x02,
    add = 0x03,
    sub = 0x04,
    jmp = 0x05,
    jz = 0x06,
    halt = 0x07,
};

const InstrDef = struct {
    opcode: Opcode,
    operand_count: u2,
    operand_bits: u8,
    has_immediate: bool,
    cycles: u8,

    pub fn validate(comptime self: InstrDef) ?[]const u8 {
        if (constraints.nonZero(self.cycles)) |err| return err;

        const max_instr_bits: u8 = 32;
        const opcode_bits: u8 = 8;

        const total_bits = opcode_bits +
            @as(u8, self.operand_count) * self.operand_bits +
            if (self.has_immediate) @as(u8, 16) else 0;

        if (total_bits > max_instr_bits)
            return std.fmt.comptimePrint(
                "instruction {} requires {} bits, exceeds {}-bit limit",
                .{ @intFromEnum(self.opcode), total_bits, max_instr_bits },
            );

        // NOP and HALT must have zero operands
        if ((self.opcode == .nop or self.opcode == .halt) and self.operand_count != 0)
            return "NOP and HALT must have zero operands";

        // Jump instructions must have an immediate
        if ((self.opcode == .jmp or self.opcode == .jz) and !self.has_immediate)
            return "jump instructions require an immediate operand";

        return null;
    }
};

const InstructionSet = struct {
    instrs: []const InstrDef,

    pub fn validate(comptime self: InstructionSet) ?[]const u8 {
        if (constraints.lenInRange(1, 32, self.instrs.len)) |err| return err;

        // All opcodes must be represented
        const all_opcodes = [_]Opcode{ .nop, .load, .store, .add, .sub, .jmp, .jz, .halt };
        for (all_opcodes) |expected| {
            var found = false;
            for (self.instrs) |instr| {
                if (instr.opcode == expected) {
                    found = true;
                    break;
                }
            }
            if (!found)
                return std.fmt.comptimePrint(
                    "missing instruction definition for opcode {}",
                    .{@intFromEnum(expected)},
                );
        }

        // No duplicate opcodes
        for (0..self.instrs.len) |i| {
            for (i + 1..self.instrs.len) |j| {
                if (self.instrs[i].opcode == self.instrs[j].opcode)
                    return "duplicate opcode";
            }
        }

        return null;
    }
};

const isa = blk: {
    const instrs = [_]InstrDef{
        .{ .opcode = .nop, .operand_count = 0, .operand_bits = 0, .has_immediate = false, .cycles = 1 },
        .{ .opcode = .load, .operand_count = 1, .operand_bits = 4, .has_immediate = true, .cycles = 3 },
        .{ .opcode = .store, .operand_count = 1, .operand_bits = 4, .has_immediate = true, .cycles = 3 },
        .{ .opcode = .add, .operand_count = 3, .operand_bits = 4, .has_immediate = false, .cycles = 1 },
        .{ .opcode = .sub, .operand_count = 3, .operand_bits = 4, .has_immediate = false, .cycles = 1 },
        .{ .opcode = .jmp, .operand_count = 0, .operand_bits = 0, .has_immediate = true, .cycles = 2 },
        .{ .opcode = .jz, .operand_count = 1, .operand_bits = 4, .has_immediate = true, .cycles = 2 },
        .{ .opcode = .halt, .operand_count = 0, .operand_bits = 0, .has_immediate = false, .cycles = 1 },
    };
    break :blk contracts.validated(InstructionSet{ .instrs = &instrs }).instrs;
};

test "ISA covers all opcodes" {
    comptime {
        try std.testing.expectEqual(8, isa.len);
    }
}

test "ISA instructions fit in 32 bits" {
    comptime {
        for (isa) |instr| {
            const total = 8 + @as(u16, instr.operand_count) * instr.operand_bits +
                if (instr.has_immediate) @as(u16, 16) else 0;
            try std.testing.expect(total <= 32);
        }
    }
}

test "ISA jump instructions have immediates" {
    comptime {
        for (isa) |instr| {
            if (instr.opcode == .jmp or instr.opcode == .jz) {
                try std.testing.expect(instr.has_immediate);
            }
        }
    }
}
