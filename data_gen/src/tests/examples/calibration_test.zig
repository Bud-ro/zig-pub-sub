const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;
const generators = @import("data_gen").generators;

// --- Linearization Table ---

const LinPoint = struct {
    input: i16,
    output: i16,

    pub fn validate(comptime self: LinPoint) ?[]const u8 {
        if (constraints.inRange(-1000, 1000, self.input)) |err| return err;
        if (constraints.inRange(-1000, 1000, self.output)) |err| return err;
        return null;
    }
};

fn ValidatedLinTable(comptime len: usize) type {
    return struct {
        table: [len]LinPoint,

        pub fn validate(comptime self: @This()) ?[]const u8 {
            if (constraints.lenInRange(2, 64, self.table.len)) |err| return err;

            var inputs: [len]i16 = undefined;
            for (self.table, 0..) |pt, i| {
                inputs[i] = pt.input;
            }
            if (constraints.isSorted(i16, &inputs)) |err| return err;
            if (constraints.noDuplicates(i16, &inputs)) |err| return err;
            return null;
        }
    };
}

const temp_linearization = blk: {
    const table = [_]LinPoint{
        .{ .input = -200, .output = -195 },
        .{ .input = -100, .output = -98 },
        .{ .input = -50, .output = -48 },
        .{ .input = 0, .output = 0 },
        .{ .input = 25, .output = 26 },
        .{ .input = 50, .output = 52 },
        .{ .input = 100, .output = 103 },
        .{ .input = 150, .output = 155 },
        .{ .input = 200, .output = 210 },
        .{ .input = 300, .output = 320 },
        .{ .input = 500, .output = 545 },
        .{ .input = 750, .output = 820 },
        .{ .input = 1000, .output = 1000 },
    };
    break :blk contracts.validated(ValidatedLinTable(table.len){ .table = table }).table;
};

test "linearization table is sorted and unique" {
    comptime {
        try std.testing.expectEqual(13, temp_linearization.len);
        for (1..temp_linearization.len) |i| {
            try std.testing.expect(temp_linearization[i].input > temp_linearization[i - 1].input);
        }
    }
}

// --- Polynomial Coefficients ---

const PolyCoeffs = struct {
    a: i32,
    b: i32,
    c: i32,

    pub fn validate(comptime self: PolyCoeffs) ?[]const u8 {
        if (self.a < -10000 or self.a > 10000) return "a out of range [-10000, 10000]";
        if (self.b < -10000 or self.b > 10000) return "b out of range [-10000, 10000]";
        if (self.c < -10000 or self.c > 10000) return "c out of range [-10000, 10000]";
        return null;
    }

    pub fn eval(comptime self: PolyCoeffs, comptime x: i32) i32 {
        return self.a * x * x + self.b * x + self.c;
    }
};

fn BoundedPoly(comptime min_out: i32, comptime max_out: i32) type {
    return struct {
        p: PolyCoeffs,

        pub fn validate(comptime self: @This()) ?[]const u8 {
            const boundary_inputs = [_]i32{ -100, -10, 0, 10, 100 };
            for (boundary_inputs) |x| {
                const y = self.p.eval(x);
                if (y < min_out or y > max_out) {
                    return std.fmt.comptimePrint(
                        "polynomial at x={} gives y={}, outside [{}, {}]",
                        .{ x, y, min_out, max_out },
                    );
                }
            }
            return null;
        }
    };
}

test "polynomial coefficients stay in bounds" {
    comptime {
        const p = contracts.validated(BoundedPoly(-1000, 1100){ .p = .{ .a = 0, .b = 10, .c = 50 } }).p;
        try std.testing.expectEqual(50, p.eval(0));
        try std.testing.expectEqual(60, p.eval(1));
    }
}

// --- Scaling Factor Configuration ---

const ScalingConfig = struct {
    input_min: i16,
    input_max: i16,
    output_min: i16,
    output_max: i16,
    scale_numerator: u16,
    scale_denominator: u16,

    pub fn validate(comptime self: ScalingConfig) ?[]const u8 {
        if (self.input_min >= self.input_max) return "input_min must be less than input_max";
        if (self.output_min >= self.output_max) return "output_min must be less than output_max";
        if (self.scale_denominator == 0) return "scale_denominator must not be zero";

        const input_range = self.input_max - self.input_min;
        const output_range = self.output_max - self.output_min;
        const scaled_input = @as(i32, input_range) * self.scale_numerator / self.scale_denominator;
        if (scaled_input > output_range * 2 or scaled_input < @divTrunc(output_range, 2))
            return "scale factor produces output range that differs from declared output range by more than 2x";
        return null;
    }

    pub fn generate(comptime self: ScalingConfig) ScalingConfig {
        contracts.assertValid(self);
        return self;
    }
};

test "scaling config 1:1 mapping" {
    comptime {
        _ = ScalingConfig.generate(.{
            .input_min = 0,
            .input_max = 100,
            .output_min = 0,
            .output_max = 100,
            .scale_numerator = 1,
            .scale_denominator = 1,
        });
    }
}

test "scaling config 2:1 mapping" {
    comptime {
        _ = ScalingConfig.generate(.{
            .input_min = 0,
            .input_max = 200,
            .output_min = 0,
            .output_max = 200,
            .scale_numerator = 1,
            .scale_denominator = 1,
        });
    }
}

test "scaling config with offset" {
    comptime {
        _ = ScalingConfig.generate(.{
            .input_min = -100,
            .input_max = 100,
            .output_min = 0,
            .output_max = 200,
            .scale_numerator = 1,
            .scale_denominator = 1,
        });
    }
}

// --- Generated Calibration Table Using Generators ---

const CalEntry = struct {
    raw: u16,
    calibrated: u16,

    pub fn validate(comptime self: CalEntry) ?[]const u8 {
        if (constraints.inRange(0, 4095, self.raw)) |err| return err;
        if (constraints.inRange(0, 4095, self.calibrated)) |err| return err;
        return null;
    }
};

fn ValidatedCalTable(comptime len: usize) type {
    return struct {
        table: [len]CalEntry,

        pub fn validate(comptime self: @This()) ?[]const u8 {
            for (1..self.table.len) |i| {
                if (self.table[i].raw <= self.table[i - 1].raw)
                    return "raw values must be strictly increasing";
            }
            return null;
        }
    };
}

const cal_table = blk: {
    const gen_fn = struct {
        fn f(comptime i: usize) CalEntry {
            const raw: u16 = @intCast(i * 16);
            const calibrated: u16 = @intCast(i * 16 + i / 4);
            return .{ .raw = raw, .calibrated = calibrated };
        }
    }.f;
    const table = generators.generateArray(CalEntry, 64, gen_fn);

    @setEvalBranchQuota(100000);
    break :blk contracts.validated(ValidatedCalTable(table.len){ .table = table }).table;
};

test "generated cal table has 64 entries" {
    comptime {
        try std.testing.expectEqual(64, cal_table.len);
        try std.testing.expectEqual(0, cal_table[0].raw);
        try std.testing.expectEqual(0, cal_table[0].calibrated);
    }
}

test "generated cal table is monotonically increasing" {
    comptime {
        for (1..cal_table.len) |i| {
            try std.testing.expect(cal_table[i].raw > cal_table[i - 1].raw);
        }
    }
}

// --- ADC Channel Calibration ---

const AdcCalibration = struct {
    channel: u8,
    gain: u16,
    offset: i16,
    reference_mv: u16,

    pub fn validate(comptime self: AdcCalibration) ?[]const u8 {
        if (self.channel > 15) return "channel out of range [0, 15]";
        if (self.gain < 512 or self.gain > 2048) return "gain out of range [512, 2048]";
        if (self.offset < -500 or self.offset > 500) return "offset out of range [-500, 500]";
        if (self.reference_mv != 1100 and self.reference_mv != 2500 and self.reference_mv != 3300 and self.reference_mv != 5000)
            return "reference_mv must be one of 1100, 2500, 3300, 5000";
        return null;
    }
};

fn ValidatedAdcChannels(comptime len: usize) type {
    return struct {
        channels: [len]AdcCalibration,

        pub fn validate(comptime self: @This()) ?[]const u8 {
            var chan_ids: [len]u8 = undefined;
            for (self.channels, 0..) |ch, i| {
                chan_ids[i] = ch.channel;
            }
            if (constraints.noDuplicates(u8, &chan_ids)) |err| return err;
            return null;
        }
    };
}

test "ADC calibration for 4 channels" {
    comptime {
        _ = contracts.validated(ValidatedAdcChannels(4){ .channels = .{
            .{ .channel = 0, .gain = 1024, .offset = -12, .reference_mv = 3300 },
            .{ .channel = 1, .gain = 1024, .offset = 5, .reference_mv = 3300 },
            .{ .channel = 2, .gain = 2048, .offset = -3, .reference_mv = 5000 },
            .{ .channel = 3, .gain = 512, .offset = 100, .reference_mv = 1100 },
        } }).channels;
    }
}
