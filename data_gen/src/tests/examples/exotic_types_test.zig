const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;
const generators = @import("data_gen").generators;

// --- Packed Structs with Sub-Byte Fields ---
// Mirrors PackedFr from the app: bitfields that pack into exactly
// 23 bits. Constraints must work on u1, u5, etc.

const StatusRegister = packed struct {
    busy: u1,
    error_code: u3,
    channel: u4,
    mode: u2,
    gain: u5,
    reserved: u1,

    pub fn validate(comptime self: StatusRegister) ?[]const u8 {
        if (self.busy == 1 and self.error_code != 0)
            return "cannot be busy with an active error";

        if (self.channel < 0 or self.channel > 7) return "channel out of range [0, 7]";

        if (self.mode == 3)
            return "mode 3 is reserved";

        if (self.gain < 1 or self.gain > 16) return "gain out of range [1, 16]";
        return null;
    }
};

test "packed status register valid idle state" {
    comptime {
        contracts.assertValid(StatusRegister{
            .busy = 0,
            .error_code = 0,
            .channel = 3,
            .mode = 1,
            .gain = 8,
            .reserved = 0,
        });
    }
}

test "packed status register valid busy state" {
    comptime {
        contracts.assertValid(StatusRegister{
            .busy = 1,
            .error_code = 0,
            .channel = 0,
            .mode = 2,
            .gain = 1,
            .reserved = 0,
        });
    }
}

test "packed status register size is 16 bits" {
    comptime {
        try std.testing.expectEqual(16, @bitSizeOf(StatusRegister));
    }
}

// More complex packed struct: control word for a DAC
const DacControl = packed struct {
    channel_select: u2,
    power_down_mode: u2,
    output_gain: u1,
    _reserved1: u1 = 0,
    speed: u2,
    data: u12,
    update_trigger: u1,
    _reserved2: u3 = 0,

    pub fn validate(comptime self: DacControl) ?[]const u8 {
        if (self.power_down_mode != 0 and self.update_trigger == 1)
            return "cannot trigger update while powered down";

        if (self.output_gain == 1 and self.data > 2048)
            return "2x gain mode limits data to 0-2048 to avoid clipping";

        if (self.data < 0 or self.data > 4095) return "data out of range [0, 4095]";
        return null;
    }
};

test "DAC control word normal output" {
    comptime {
        contracts.assertValid(DacControl{
            .channel_select = 0,
            .power_down_mode = 0,
            .output_gain = 0,
            .speed = 2,
            .data = 2048,
            .update_trigger = 1,
        });
    }
}

test "DAC control word 2x gain limited range" {
    comptime {
        contracts.assertValid(DacControl{
            .channel_select = 1,
            .power_down_mode = 0,
            .output_gain = 1,
            .speed = 1,
            .data = 1024,
            .update_trigger = 1,
        });
    }
}

test "DAC control word size is 24 bits" {
    comptime {
        try std.testing.expectEqual(24, @bitSizeOf(DacControl));
    }
}

// --- Extern Structs with Alignment ---
// C-compatible layout with explicit padding. Constraints must
// account for field alignment and total struct size.

const SensorReading = extern struct {
    timestamp_ms: u32,
    channel_id: u8,
    _pad1: [3]u8 = .{ 0, 0, 0 },
    value_raw: i32,
    value_scaled: i32,
    status_flags: u16,
    _pad2: [2]u8 = .{ 0, 0 },

    pub fn validate(comptime self: SensorReading) ?[]const u8 {
        if (self.channel_id < 0 or self.channel_id > 15) return "channel_id out of range [0, 15]";
        if (self.timestamp_ms == 0) return "timestamp_ms must not be zero";

        // Scaled value must be a plausible transformation of raw
        // (within 10x factor)
        const abs_raw = if (self.value_raw < 0) -self.value_raw else self.value_raw;
        const abs_scaled = if (self.value_scaled < 0) -self.value_scaled else self.value_scaled;
        if (abs_raw > 0 and abs_scaled > abs_raw * 10)
            return "scaled value is implausibly large relative to raw";

        // Status flags: bit 0 = valid, bit 1 = overflow, bit 2 = underflow
        // Valid and overflow/underflow are contradictory
        if (self.status_flags & 1 == 1 and self.status_flags & 6 != 0)
            return "valid reading cannot have overflow or underflow flags";
        return null;
    }
};

test "extern sensor reading valid" {
    comptime {
        contracts.assertValid(SensorReading{
            .timestamp_ms = 1000,
            .channel_id = 3,
            .value_raw = 512,
            .value_scaled = 2560,
            .status_flags = 0x0001, // valid
        });
    }
}

test "extern sensor reading is C-sized" {
    comptime {
        // 4 + 1 + 3pad + 4 + 4 + 2 + 2pad = 20 bytes
        try std.testing.expectEqual(20, @sizeOf(SensorReading));
    }
}

// --- Tagged Unions ---
// Different command types with variant-specific constraints.

const CommandTag = enum(u8) {
    set_output,
    read_input,
    configure,
    reset,
    calibrate,
};

const SetOutputData = struct {
    channel: u8,
    value: u16,
};

const ConfigureData = struct {
    parameter_id: u16,
    value: u32,
};

const CalibrateData = struct {
    channel: u8,
    reference_value: i16,
    num_samples: u8,
};

const Command = union(CommandTag) {
    set_output: SetOutputData,
    read_input: u8, // just a channel number
    configure: ConfigureData,
    reset: void,
    calibrate: CalibrateData,
};

fn validateCommand(comptime cmd: Command) void {
    switch (cmd) {
        .set_output => |data| {
            constraints.assert(constraints.inRange(0, 7, data.channel));
            constraints.assert(constraints.inRange(0, 4095, data.value));
        },
        .read_input => |channel| {
            constraints.assert(constraints.inRange(0, 15, channel));
        },
        .configure => |data| {
            constraints.assert(constraints.inRange(0, 255, data.parameter_id));
        },
        .reset => {},
        .calibrate => |data| {
            constraints.assert(constraints.inRange(0, 7, data.channel));
            constraints.assert(constraints.inRange(-1000, 1000, data.reference_value));
            constraints.assert(constraints.oneOf(&.{ 1, 4, 8, 16, 32, 64 }, data.num_samples));
        },
    }
}

fn validateCommandSequence(comptime cmds: []const Command) void {
    constraints.assert(constraints.lenInRange(1, 32, cmds.len));

    // Reset must be followed by configure (if not last)
    for (0..cmds.len - 1) |i| {
        if (cmds[i] == .reset and cmds[i + 1] != .configure)
            @compileError(std.fmt.comptimePrint(
                "reset at index {} must be followed by configure",
                .{i},
            ));
    }

    // Calibrate must not appear before any configure
    var seen_configure = false;
    for (cmds) |cmd| {
        validateCommand(cmd);
        if (cmd == .configure) seen_configure = true;
        if (cmd == .calibrate and !seen_configure)
            @compileError("calibrate must not appear before configure");
    }
}

const init_sequence = blk: {
    const cmds = [_]Command{
        .{ .reset = {} },
        .{ .configure = .{ .parameter_id = 0x01, .value = 48000 } },
        .{ .configure = .{ .parameter_id = 0x10, .value = 1 } },
        .{ .calibrate = .{ .channel = 0, .reference_value = 0, .num_samples = 16 } },
        .{ .calibrate = .{ .channel = 1, .reference_value = 500, .num_samples = 32 } },
        .{ .set_output = .{ .channel = 0, .value = 2048 } },
        .{ .read_input = 5 },
    };
    validateCommandSequence(&cmds);
    break :blk cmds;
};

test "init sequence starts with reset then configure" {
    comptime {
        try std.testing.expectEqual(CommandTag.reset, @as(CommandTag, init_sequence[0]));
        try std.testing.expectEqual(CommandTag.configure, @as(CommandTag, init_sequence[1]));
    }
}

test "init sequence has 7 commands" {
    comptime {
        try std.testing.expectEqual(7, init_sequence.len);
    }
}

test "init sequence calibrate comes after configure" {
    comptime {
        var seen_configure = false;
        for (init_sequence) |cmd| {
            if (cmd == .configure) seen_configure = true;
            if (cmd == .calibrate) try std.testing.expect(seen_configure);
        }
    }
}

// --- Nested Arrays ---
// 2D configuration tables with row and column constraints.

const GainTable = struct {
    values: [4][8]u8,
    row_labels: [4]u8,
    col_labels: [8]u8,

    pub fn validate(comptime self: GainTable) ?[]const u8 {
        constraints.assert(constraints.isSorted(u8, &self.row_labels));
        constraints.assert(constraints.noDuplicates(u8, &self.row_labels));
        constraints.assert(constraints.isSorted(u8, &self.col_labels));
        constraints.assert(constraints.noDuplicates(u8, &self.col_labels));

        // Each row must be monotonically non-decreasing
        for (self.values) |row| {
            for (1..row.len) |j| {
                if (row[j] < row[j - 1])
                    return "gain table rows must be non-decreasing";
            }
        }

        // Each column must be monotonically non-decreasing
        for (0..8) |col| {
            for (1..4) |row| {
                if (self.values[row][col] < self.values[row - 1][col])
                    return "gain table columns must be non-decreasing";
            }
        }

        // All values in valid range
        for (self.values) |row| {
            for (row) |v| {
                if (v < 0 or v > 64) return "gain table value out of range [0, 64]";
            }
        }
        return null;
    }
};

const gain_config = contracts.validated(GainTable{
    .row_labels = .{ 10, 20, 50, 100 },
    .col_labels = .{ 1, 2, 3, 4, 5, 6, 7, 8 },
    .values = .{
        .{ 1, 2, 3, 4, 5, 6, 7, 8 },
        .{ 2, 3, 4, 5, 6, 8, 10, 12 },
        .{ 4, 6, 8, 10, 12, 16, 20, 24 },
        .{ 8, 12, 16, 20, 24, 32, 40, 48 },
    },
});

test "gain table is monotonic in both dimensions" {
    comptime {
        for (gain_config.values) |row| {
            for (1..row.len) |j| {
                try std.testing.expect(row[j] >= row[j - 1]);
            }
        }
        for (0..8) |col| {
            for (1..4) |row| {
                try std.testing.expect(gain_config.values[row][col] >= gain_config.values[row - 1][col]);
            }
        }
    }
}

test "gain table labels are sorted and unique" {
    comptime {
        constraints.assert(constraints.isSorted(u8, &gain_config.row_labels));
        constraints.assert(constraints.noDuplicates(u8, &gain_config.row_labels));
        constraints.assert(constraints.isSorted(u8, &gain_config.col_labels));
        constraints.assert(constraints.noDuplicates(u8, &gain_config.col_labels));
    }
}
