const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;
const generators = @import("data_gen").generators;

// --- Linearization Table ---

const LinPoint = struct {
    input: i16,
    output: i16,
};

fn validateLinearization(comptime table: []const LinPoint) void {
    constraints.lenInRange(2, 64, table.len);

    var inputs: [table.len]i16 = undefined;
    for (table, 0..) |pt, i| {
        inputs[i] = pt.input;
        constraints.inRange(-1000, 1000, pt.input);
        constraints.inRange(-1000, 1000, pt.output);
    }
    constraints.isSorted(i16, &inputs);
    constraints.noDuplicates(i16, &inputs);
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
    validateLinearization(&table);
    break :blk table;
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

    pub fn validate(comptime self: PolyCoeffs) void {
        constraints.inRange(-10000, 10000, self.a);
        constraints.inRange(-10000, 10000, self.b);
        constraints.inRange(-10000, 10000, self.c);
    }

    pub fn eval(comptime self: PolyCoeffs, comptime x: i32) i32 {
        return self.a * x * x + self.b * x + self.c;
    }
};

fn validatePolyAtBoundaries(comptime p: PolyCoeffs, comptime min_out: i32, comptime max_out: i32) void {
    p.validate();
    const boundary_inputs = [_]i32{ -100, -10, 0, 10, 100 };
    for (boundary_inputs) |x| {
        const y = p.eval(x);
        if (y < min_out or y > max_out) {
            @compileError(std.fmt.comptimePrint(
                "polynomial at x={} gives y={}, outside [{}, {}]",
                .{ x, y, min_out, max_out },
            ));
        }
    }
}

test "polynomial coefficients stay in bounds" {
    comptime {
        const p = PolyCoeffs{ .a = 0, .b = 10, .c = 50 };
        validatePolyAtBoundaries(p, -1000, 1100);
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

    pub fn validate(comptime self: ScalingConfig) void {
        constraints.lessThan(self.input_min, self.input_max);
        constraints.lessThan(self.output_min, self.output_max);
        constraints.nonZero(self.scale_denominator);

        const input_range = self.input_max - self.input_min;
        const output_range = self.output_max - self.output_min;
        const scaled_input = @as(i32, input_range) * self.scale_numerator / self.scale_denominator;
        if (scaled_input > output_range * 2 or scaled_input < @divTrunc(output_range, 2))
            @compileError("scale factor produces output range that differs from declared output range by more than 2x");
    }

    pub fn generate(comptime self: ScalingConfig) ScalingConfig {
        self.validate();
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

const CalEntry = struct { raw: u16, calibrated: u16 };

const cal_table = blk: {
    const gen_fn = struct {
        fn f(comptime i: usize) CalEntry {
            const raw: u16 = @intCast(i * 16);
            const calibrated: u16 = @intCast(i * 16 + i / 4);
            return .{ .raw = raw, .calibrated = calibrated };
        }
    }.f;
    const table = generators.generateArray(CalEntry, 64, gen_fn);

    for (table) |entry| {
        constraints.inRange(0, 4095, entry.raw);
        constraints.inRange(0, 4095, entry.calibrated);
    }

    for (1..table.len) |i| {
        if (table[i].raw <= table[i - 1].raw)
            @compileError("raw values must be strictly increasing");
    }

    break :blk table;
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

    pub fn validate(comptime self: AdcCalibration) void {
        constraints.inRange(0, 15, self.channel);
        constraints.inRange(512, 2048, self.gain);
        constraints.inRange(-500, 500, self.offset);
        constraints.oneOf(&.{ 1100, 2500, 3300, 5000 }, self.reference_mv);
    }
};

test "ADC calibration for 4 channels" {
    comptime {
        const channels = [_]AdcCalibration{
            contracts.validated(AdcCalibration, AdcCalibration{ .channel = 0, .gain = 1024, .offset = -12, .reference_mv = 3300 }),
            contracts.validated(AdcCalibration, AdcCalibration{ .channel = 1, .gain = 1024, .offset = 5, .reference_mv = 3300 }),
            contracts.validated(AdcCalibration, AdcCalibration{ .channel = 2, .gain = 2048, .offset = -3, .reference_mv = 5000 }),
            contracts.validated(AdcCalibration, AdcCalibration{ .channel = 3, .gain = 512, .offset = 100, .reference_mv = 1100 }),
        };

        const chan_ids = [_]u8{
            channels[0].channel,
            channels[1].channel,
            channels[2].channel,
            channels[3].channel,
        };
        constraints.noDuplicates(u8, &chan_ids);
    }
}
