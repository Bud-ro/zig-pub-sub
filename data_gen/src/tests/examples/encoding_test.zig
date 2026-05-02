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
};

fn validatePrefixFree(comptime codes: []const CodeEntry) void {
    @setEvalBranchQuota(10_000);
    constraints.assert(constraints.lenInRange(2, 64, codes.len));

    var symbols: [codes.len]u8 = undefined;
    for (codes, 0..) |entry, i| {
        symbols[i] = entry.symbol;
        constraints.assert(constraints.inRange(1, 15, entry.length));

        // Code must fit within declared length
        const max_val: u16 = (@as(u16, 1) << entry.length) - 1;
        if (entry.code > max_val)
            @compileError(std.fmt.comptimePrint(
                "code 0x{x} exceeds {}-bit capacity",
                .{ entry.code, entry.length },
            ));
    }
    constraints.assert(constraints.noDuplicates(u8, &symbols));

    // Prefix-free check: for every pair of codes, neither is a prefix of the other
    for (0..codes.len) |i| {
        for (i + 1..codes.len) |j| {
            const a = codes[i];
            const b = codes[j];

            // The shorter code is a potential prefix of the longer one
            if (a.length <= b.length) {
                // Shift b's code right to align with a's length
                const b_prefix = b.code >> (b.length - a.length);
                if (b_prefix == a.code)
                    @compileError(std.fmt.comptimePrint(
                        "code for symbol {} (len={}) is a prefix of code for symbol {} (len={})",
                        .{ a.symbol, a.length, b.symbol, b.length },
                    ));
            } else {
                const a_prefix = a.code >> (a.length - b.length);
                if (a_prefix == b.code)
                    @compileError(std.fmt.comptimePrint(
                        "code for symbol {} (len={}) is a prefix of code for symbol {} (len={})",
                        .{ b.symbol, b.length, a.symbol, a.length },
                    ));
            }
        }
    }
}

fn validateKraftInequality(comptime codes: []const CodeEntry) void {
    // Kraft's inequality: sum(2^(-length_i)) <= 1
    // We compute as sum(2^(max_len - length_i)) <= 2^max_len
    var max_len: u4 = 0;
    for (codes) |c| {
        if (c.length > max_len) max_len = c.length;
    }

    var kraft_sum: u32 = 0;
    for (codes) |c| {
        kraft_sum += @as(u32, 1) << (max_len - c.length);
    }

    const kraft_limit: u32 = @as(u32, 1) << max_len;
    if (kraft_sum > kraft_limit)
        @compileError(std.fmt.comptimePrint(
            "Kraft inequality violated: sum {} > limit {}",
            .{ kraft_sum, kraft_limit },
        ));
}

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
    validatePrefixFree(&codes);
    validateKraftInequality(&codes);
    break :blk codes;
};

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
        constraints.assert(constraints.noDuplicates(u8, &syms));
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
};

fn validateInstructionSet(comptime instrs: []const InstrDef) void {
    constraints.assert(constraints.lenInRange(1, 32, instrs.len));

    const max_instr_bits: u8 = 32;
    const opcode_bits: u8 = 8;

    for (instrs) |instr| {
        constraints.assert(constraints.nonZero(instr.cycles));

        const total_bits = opcode_bits +
            @as(u8, instr.operand_count) * instr.operand_bits +
            if (instr.has_immediate) @as(u8, 16) else 0;

        if (total_bits > max_instr_bits)
            @compileError(std.fmt.comptimePrint(
                "instruction {} requires {} bits, exceeds {}-bit limit",
                .{ @intFromEnum(instr.opcode), total_bits, max_instr_bits },
            ));

        // NOP and HALT must have zero operands
        if ((instr.opcode == .nop or instr.opcode == .halt) and instr.operand_count != 0)
            @compileError("NOP and HALT must have zero operands");

        // Jump instructions must have an immediate
        if ((instr.opcode == .jmp or instr.opcode == .jz) and !instr.has_immediate)
            @compileError("jump instructions require an immediate operand");
    }

    // All opcodes must be represented
    const all_opcodes = [_]Opcode{ .nop, .load, .store, .add, .sub, .jmp, .jz, .halt };
    for (all_opcodes) |expected| {
        var found = false;
        for (instrs) |instr| {
            if (instr.opcode == expected) {
                found = true;
                break;
            }
        }
        if (!found)
            @compileError(std.fmt.comptimePrint(
                "missing instruction definition for opcode {}",
                .{@intFromEnum(expected)},
            ));
    }

    // No duplicate opcodes
    for (0..instrs.len) |i| {
        for (i + 1..instrs.len) |j| {
            if (instrs[i].opcode == instrs[j].opcode)
                @compileError("duplicate opcode");
        }
    }
}

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
    validateInstructionSet(&instrs);
    break :blk instrs;
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
