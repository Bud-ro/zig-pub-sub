const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;
const generators = @import("data_gen").generators;

// --- Signal Routing Matrix ---
// An NxM routing matrix connecting inputs to outputs.
// Each output must have exactly one source. Inputs may fan out
// to multiple outputs, but certain inputs are exclusive (can only
// drive one output at a time due to hardware limitations).

const SignalId = enum(u8) {
    adc0,
    adc1,
    adc2,
    adc3,
    dac0,
    dac1,
    timer0_pwm,
    timer1_pwm,
    spi_mosi,
    spi_miso,
    uart_tx,
    uart_rx,
    gpio0,
    gpio1,
    gpio2,
    gpio3,
};

const RouteEntry = struct {
    source: SignalId,
    destination: SignalId,
    attenuation_db: u8,
    invert: bool,
};

fn validateRoutingMatrix(comptime routes: []const RouteEntry) void {
    @setEvalBranchQuota(5000);
    constraints.assert(constraints.lenInRange(1, 64, routes.len));

    // Each destination must appear at most once (single driver)
    for (0..routes.len) |i| {
        for (i + 1..routes.len) |j| {
            if (routes[i].destination == routes[j].destination)
                @compileError(std.fmt.comptimePrint(
                    "destination {} has multiple drivers",
                    .{@intFromEnum(routes[i].destination)},
                ));
        }
    }

    // Source and destination must be different
    for (routes) |route| {
        if (route.source == route.destination)
            @compileError("cannot route a signal to itself");
    }

    // ADC inputs are exclusive: each ADC can only drive one destination
    const exclusive_sources = [_]SignalId{ .adc0, .adc1, .adc2, .adc3 };
    for (exclusive_sources) |excl| {
        var use_count: u8 = 0;
        for (routes) |route| {
            if (route.source == excl) use_count += 1;
        }
        if (use_count > 1)
            @compileError(std.fmt.comptimePrint(
                "exclusive source {} is routed to {} destinations (max 1)",
                .{ @intFromEnum(excl), use_count },
            ));
    }

    // Attenuation sanity
    for (routes) |route| {
        constraints.assert(constraints.inRange(0, 60, route.attenuation_db));
    }
}

const signal_routes = blk: {
    const routes = [_]RouteEntry{
        .{ .source = .adc0, .destination = .dac0, .attenuation_db = 0, .invert = false },
        .{ .source = .adc1, .destination = .dac1, .attenuation_db = 6, .invert = true },
        .{ .source = .timer0_pwm, .destination = .gpio0, .attenuation_db = 0, .invert = false },
        .{ .source = .timer0_pwm, .destination = .gpio1, .attenuation_db = 0, .invert = true },
        .{ .source = .timer1_pwm, .destination = .gpio2, .attenuation_db = 0, .invert = false },
        .{ .source = .uart_tx, .destination = .gpio3, .attenuation_db = 0, .invert = false },
    };
    validateRoutingMatrix(&routes);
    break :blk routes;
};

test "signal routing has unique destinations" {
    comptime {
        try std.testing.expectEqual(6, signal_routes.len);
        for (0..signal_routes.len) |i| {
            for (i + 1..signal_routes.len) |j| {
                try std.testing.expect(signal_routes[i].destination != signal_routes[j].destination);
            }
        }
    }
}

test "timer0_pwm fans out to two GPIOs (non-exclusive source)" {
    comptime {
        var count: u8 = 0;
        for (signal_routes) |r| {
            if (r.source == .timer0_pwm) count += 1;
        }
        try std.testing.expectEqual(2, count);
    }
}

test "ADC sources are each used at most once" {
    comptime {
        const adcs = [_]SignalId{ .adc0, .adc1, .adc2, .adc3 };
        for (adcs) |adc| {
            var count: u8 = 0;
            for (signal_routes) |r| {
                if (r.source == adc) count += 1;
            }
            try std.testing.expect(count <= 1);
        }
    }
}

// --- Crossbar Switch (full NxN, permutation routing) ---
// Every input maps to exactly one output and vice versa.

const CrossbarEntry = struct {
    input_channel: u4,
    output_channel: u4,
    gain_x10: u8,
};

fn validateCrossbar(comptime N: u4, comptime entries: []const CrossbarEntry) void {
    if (entries.len != N)
        @compileError(std.fmt.comptimePrint(
            "crossbar must have exactly {} entries for {}x{} switch",
            .{ N, N, N },
        ));

    // Each input used exactly once
    for (0..entries.len) |i| {
        for (i + 1..entries.len) |j| {
            if (entries[i].input_channel == entries[j].input_channel)
                @compileError("duplicate input channel in crossbar");
            if (entries[i].output_channel == entries[j].output_channel)
                @compileError("duplicate output channel in crossbar");
        }
    }

    // All channels in range [0, N)
    for (entries) |e| {
        if (e.input_channel >= N)
            @compileError("input channel out of range");
        if (e.output_channel >= N)
            @compileError("output channel out of range");
        constraints.assert(constraints.inRange(1, 100, e.gain_x10));
    }
}

const audio_crossbar = blk: {
    const entries = [_]CrossbarEntry{
        .{ .input_channel = 0, .output_channel = 2, .gain_x10 = 10 },
        .{ .input_channel = 1, .output_channel = 0, .gain_x10 = 8 },
        .{ .input_channel = 2, .output_channel = 3, .gain_x10 = 10 },
        .{ .input_channel = 3, .output_channel = 1, .gain_x10 = 12 },
    };
    validateCrossbar(4, &entries);
    break :blk entries;
};

test "crossbar is a valid permutation" {
    comptime {
        try std.testing.expectEqual(4, audio_crossbar.len);

        var input_seen = [_]bool{false} ** 4;
        var output_seen = [_]bool{false} ** 4;
        for (audio_crossbar) |e| {
            input_seen[e.input_channel] = true;
            output_seen[e.output_channel] = true;
        }
        for (input_seen) |s| try std.testing.expect(s);
        for (output_seen) |s| try std.testing.expect(s);
    }
}

// --- DMA Channel Assignment ---
// Each DMA channel can serve one peripheral at a time.
// Certain peripherals require specific DMA channels.

const DmaPeripheral = enum(u8) { spi1_tx, spi1_rx, i2c1_tx, i2c1_rx, uart1_tx, uart1_rx, adc1, timer1_up };

const DmaAssignment = struct {
    channel: u8,
    peripheral: DmaPeripheral,
    priority: enum(u2) { low, medium, high, very_high },
    circular: bool,
    mem_increment: bool,
};

fn validateDmaAssignments(comptime assignments: []const DmaAssignment) void {
    constraints.assert(constraints.lenInRange(1, 16, assignments.len));

    // Each channel used at most once
    var channels: [assignments.len]u8 = undefined;
    var periphs: [assignments.len]u8 = undefined;
    for (assignments, 0..) |a, i| {
        channels[i] = a.channel;
        periphs[i] = @intFromEnum(a.peripheral);
        constraints.assert(constraints.inRange(0, 15, a.channel));
    }
    constraints.assert(constraints.noDuplicates(u8, &channels));
    constraints.assert(constraints.noDuplicates(u8, &periphs));

    // TX/RX pairs must use different channels but same priority
    for (assignments) |a| {
        for (assignments) |b| {
            const is_tx_rx_pair = switch (a.peripheral) {
                .spi1_tx => b.peripheral == .spi1_rx,
                .i2c1_tx => b.peripheral == .i2c1_rx,
                .uart1_tx => b.peripheral == .uart1_rx,
                else => false,
            };
            if (is_tx_rx_pair and a.priority != b.priority)
                @compileError("TX/RX pair must have matching priority");
        }
    }

    // ADC must use circular mode
    for (assignments) |a| {
        if (a.peripheral == .adc1 and !a.circular)
            @compileError("ADC DMA must use circular mode");
    }
}

const dma_config = blk: {
    const assignments = [_]DmaAssignment{
        .{ .channel = 0, .peripheral = .spi1_tx, .priority = .high, .circular = false, .mem_increment = true },
        .{ .channel = 1, .peripheral = .spi1_rx, .priority = .high, .circular = false, .mem_increment = true },
        .{ .channel = 2, .peripheral = .uart1_tx, .priority = .medium, .circular = false, .mem_increment = true },
        .{ .channel = 3, .peripheral = .uart1_rx, .priority = .medium, .circular = true, .mem_increment = true },
        .{ .channel = 4, .peripheral = .adc1, .priority = .very_high, .circular = true, .mem_increment = true },
        .{ .channel = 5, .peripheral = .i2c1_tx, .priority = .low, .circular = false, .mem_increment = true },
        .{ .channel = 6, .peripheral = .i2c1_rx, .priority = .low, .circular = false, .mem_increment = true },
    };
    validateDmaAssignments(&assignments);
    break :blk assignments;
};

test "DMA assignments have unique channels and peripherals" {
    comptime {
        try std.testing.expectEqual(7, dma_config.len);
    }
}

test "DMA TX/RX pairs share priority" {
    comptime {
        try std.testing.expectEqual(dma_config[0].priority, dma_config[1].priority); // SPI
        try std.testing.expectEqual(dma_config[2].priority, dma_config[3].priority); // UART
        try std.testing.expectEqual(dma_config[5].priority, dma_config[6].priority); // I2C
    }
}

test "DMA ADC uses circular mode" {
    comptime {
        for (dma_config) |a| {
            if (a.peripheral == .adc1) {
                try std.testing.expect(a.circular);
            }
        }
    }
}
