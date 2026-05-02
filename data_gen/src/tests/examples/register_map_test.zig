const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;
const generators = @import("data_gen").generators;

// --- Hardware Register Map ---
// Registers at specific byte addresses that must not overlap.
// Each register has a width and optional bit-field definitions.
// The bit fields within a register must tile the register width exactly.

const BitField = struct {
    name_id: u8,
    bit_offset: u8,
    bit_width: u8,

    pub fn validate(comptime self: BitField) void {
        constraints.nonZero(self.bit_width);
        constraints.inRange(0, 31, self.bit_offset);
        constraints.inRange(1, 32, self.bit_width);
        if (self.bit_offset + self.bit_width > 32)
            @compileError("bit field extends beyond 32-bit register width");
    }
};

const Access = enum(u2) { read_only, write_only, read_write, reserved };

const Register = struct {
    name_id: u8,
    address: u16,
    width_bytes: u8,
    access: Access,
    fields: []const BitField,

    pub fn validate(comptime self: Register) void {
        constraints.oneOf(&.{ 1, 2, 4 }, self.width_bytes);
        constraints.inRange(0, 0xFFFF, self.address);

        if (self.address % self.width_bytes != 0)
            @compileError(std.fmt.comptimePrint(
                "register at 0x{x:0>4} is not aligned to its width ({})",
                .{ self.address, self.width_bytes },
            ));

        const total_bits: u8 = @as(u8, self.width_bytes) * 8;

        for (self.fields) |field| {
            field.validate();
            if (field.bit_offset + field.bit_width > total_bits)
                @compileError("bit field extends beyond register width");
        }

        // Fields must not overlap
        for (0..self.fields.len) |i| {
            const a = self.fields[i];
            for (i + 1..self.fields.len) |j| {
                const b = self.fields[j];
                const a_end = a.bit_offset + a.bit_width;
                const b_end = b.bit_offset + b.bit_width;
                if (a.bit_offset < b_end and b.bit_offset < a_end)
                    @compileError(std.fmt.comptimePrint(
                        "bit fields {} and {} overlap",
                        .{ a.name_id, b.name_id },
                    ));
            }
        }
    }
};

fn validateRegisterMap(comptime regs: []const Register) void {
    constraints.lenInRange(1, 128, regs.len);

    var ids: [regs.len]u8 = undefined;
    for (regs, 0..) |reg, i| {
        reg.validate();
        ids[i] = reg.name_id;
    }
    constraints.noDuplicates(u8, &ids);

    // Registers must not overlap in address space
    for (0..regs.len) |i| {
        for (i + 1..regs.len) |j| {
            const a_start = regs[i].address;
            const a_end = regs[i].address + regs[i].width_bytes;
            const b_start = regs[j].address;
            const b_end = regs[j].address + regs[j].width_bytes;
            if (a_start < b_end and b_start < a_end)
                @compileError(std.fmt.comptimePrint(
                    "registers at 0x{x:0>4} and 0x{x:0>4} overlap",
                    .{ a_start, b_start },
                ));
        }
    }
}

const peripheral_regs = blk: {
    const regs = [_]Register{
        .{
            .name_id = 0,
            .address = 0x0000,
            .width_bytes = 4,
            .access = .read_only,
            .fields = &.{
                .{ .name_id = 0, .bit_offset = 0, .bit_width = 16 },
                .{ .name_id = 1, .bit_offset = 16, .bit_width = 8 },
                .{ .name_id = 2, .bit_offset = 24, .bit_width = 8 },
            },
        },
        .{
            .name_id = 1,
            .address = 0x0004,
            .width_bytes = 4,
            .access = .read_write,
            .fields = &.{
                .{ .name_id = 10, .bit_offset = 0, .bit_width = 1 },
                .{ .name_id = 11, .bit_offset = 1, .bit_width = 1 },
                .{ .name_id = 12, .bit_offset = 2, .bit_width = 6 },
                .{ .name_id = 13, .bit_offset = 8, .bit_width = 8 },
                .{ .name_id = 14, .bit_offset = 16, .bit_width = 16 },
            },
        },
        .{
            .name_id = 2,
            .address = 0x0008,
            .width_bytes = 2,
            .access = .read_write,
            .fields = &.{
                .{ .name_id = 20, .bit_offset = 0, .bit_width = 12 },
                .{ .name_id = 21, .bit_offset = 12, .bit_width = 4 },
            },
        },
        .{
            .name_id = 3,
            .address = 0x000C,
            .width_bytes = 4,
            .access = .write_only,
            .fields = &.{
                .{ .name_id = 30, .bit_offset = 0, .bit_width = 32 },
            },
        },
        .{
            .name_id = 4,
            .address = 0x0010,
            .width_bytes = 1,
            .access = .read_only,
            .fields = &.{
                .{ .name_id = 40, .bit_offset = 0, .bit_width = 4 },
                .{ .name_id = 41, .bit_offset = 4, .bit_width = 4 },
            },
        },
        .{
            .name_id = 5,
            .address = 0x0014,
            .width_bytes = 4,
            .access = .reserved,
            .fields = &.{},
        },
        .{
            .name_id = 6,
            .address = 0x0018,
            .width_bytes = 4,
            .access = .read_write,
            .fields = &.{
                .{ .name_id = 60, .bit_offset = 0, .bit_width = 1 },
                .{ .name_id = 61, .bit_offset = 8, .bit_width = 1 },
                .{ .name_id = 62, .bit_offset = 16, .bit_width = 1 },
                .{ .name_id = 63, .bit_offset = 24, .bit_width = 1 },
            },
        },
    };
    validateRegisterMap(&regs);
    break :blk regs;
};

test "register map has no address overlaps" {
    comptime {
        try std.testing.expectEqual(7, peripheral_regs.len);
        for (0..peripheral_regs.len) |i| {
            for (i + 1..peripheral_regs.len) |j| {
                const a_end = peripheral_regs[i].address + peripheral_regs[i].width_bytes;
                try std.testing.expect(a_end <= peripheral_regs[j].address);
            }
        }
    }
}

test "register map all registers are naturally aligned" {
    comptime {
        for (peripheral_regs) |reg| {
            try std.testing.expectEqual(0, reg.address % reg.width_bytes);
        }
    }
}

test "register map bit fields do not overlap within registers" {
    comptime {
        for (peripheral_regs) |reg| {
            for (0..reg.fields.len) |i| {
                for (i + 1..reg.fields.len) |j| {
                    const a_end = @as(u8, reg.fields[i].bit_offset) + reg.fields[i].bit_width;
                    try std.testing.expect(a_end <= reg.fields[j].bit_offset);
                }
            }
        }
    }
}

// --- Generated Register Map for a GPIO Peripheral ---
// 8 GPIO ports, each with 3 registers (DIR, OUT, IN) at consecutive addresses

const gpio_regs = blk: {
    @setEvalBranchQuota(5000);
    const gen = struct {
        fn f(comptime i: usize) Register {
            const port: u8 = @intCast(i / 3);
            const reg_type: u8 = @intCast(i % 3);
            const base_addr: u16 = @intCast(@as(u16, port) * 12 + 0x100);
            return switch (reg_type) {
                0 => .{
                    .name_id = @intCast(i),
                    .address = base_addr,
                    .width_bytes = 4,
                    .access = .read_write,
                    .fields = &.{.{ .name_id = @intCast(i), .bit_offset = 0, .bit_width = 8 }},
                },
                1 => .{
                    .name_id = @intCast(i),
                    .address = base_addr + 4,
                    .width_bytes = 4,
                    .access = .read_write,
                    .fields = &.{.{ .name_id = @intCast(i), .bit_offset = 0, .bit_width = 8 }},
                },
                else => .{
                    .name_id = @intCast(i),
                    .address = base_addr + 8,
                    .width_bytes = 4,
                    .access = .read_only,
                    .fields = &.{.{ .name_id = @intCast(i), .bit_offset = 0, .bit_width = 8 }},
                },
            };
        }
    }.f;
    const regs = generators.generateArray(Register, 24, gen);
    validateRegisterMap(&regs);
    break :blk regs;
};

test "GPIO register map covers 8 ports x 3 registers" {
    comptime {
        try std.testing.expectEqual(24, gpio_regs.len);
        try std.testing.expectEqual(0x0100, gpio_regs[0].address);
        try std.testing.expectEqual(0x0104, gpio_regs[1].address);
        try std.testing.expectEqual(0x0108, gpio_regs[2].address);
        try std.testing.expectEqual(0x010C, gpio_regs[3].address);
    }
}
