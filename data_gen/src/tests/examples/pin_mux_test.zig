const std = @import("std");
const constraint = @import("data_gen").constraint;
const contract = @import("data_gen").contract;

// --- Pin Multiplexing ---
// MCU pins can be assigned to alternate functions. Each physical pin
// can only serve one function at a time. Some functions require
// specific pins. Some functions require multiple pins as a group.

const Pin = enum(u8) {
    pa0,
    pa1,
    pa2,
    pa3,
    pa4,
    pa5,
    pa6,
    pa7,
    pb0,
    pb1,
    pb2,
    pb3,
    pb4,
    pb5,
    pb6,
    pb7,
};

const Function = enum(u8) {
    gpio,
    spi1_sck,
    spi1_mosi,
    spi1_miso,
    spi1_nss,
    uart1_tx,
    uart1_rx,
    i2c1_scl,
    i2c1_sda,
    timer1_ch1,
    timer1_ch2,
    adc_ch0,
    adc_ch1,
    adc_ch2,
    adc_ch3,
};

const PinAssignment = struct {
    pin: Pin,
    function: Function,
    pull: enum(u2) { none, up, down, reserved },
    speed: enum(u2) { low, medium, high, very_high },

    /// Per-element validation: ADC pins must have pull = none,
    /// I2C pins must have pull = up.
    pub fn contractValidate(comptime self: PinAssignment) ?[]const u8 {
        switch (self.function) {
            .adc_ch0, .adc_ch1, .adc_ch2, .adc_ch3 => {
                if (self.pull != .none)
                    return "ADC pins must not have pull-up/down enabled";
            },
            .i2c1_scl, .i2c1_sda => {
                if (self.pull != .up)
                    return "I2C pins require pull-up configuration";
            },
            else => {},
        }
        return null;
    }
};

const PinCapability = struct {
    pin: Pin,
    allowed_functions: []const Function,
};

fn PinMuxConfig(comptime N: usize) type {
    return struct {
        assignments: [N]PinAssignment,
        capabilities: []const PinCapability,

        pub fn contractValidate(comptime self: @This()) ?[]const u8 {
            @setEvalBranchQuota(10_000);
            if (constraint.lenInRange(1, 32, N)) |err| return err;

            // Each pin used at most once
            var pins: [N]u8 = undefined;
            for (self.assignments, 0..) |a, i| {
                pins[i] = @intFromEnum(a.pin);
            }
            if (constraint.noDuplicates(u8, &pins)) |err| return err;

            // Each non-GPIO function used at most once
            for (0..N) |i| {
                if (self.assignments[i].function == .gpio) continue;
                for (i + 1..N) |j| {
                    if (self.assignments[i].function == self.assignments[j].function)
                        return std.fmt.comptimePrint(
                            "function {} assigned to multiple pins",
                            .{@intFromEnum(self.assignments[i].function)},
                        );
                }
            }

            // Verify each assignment is valid per the capability table
            for (self.assignments) |a| {
                var found_cap = false;
                for (self.capabilities) |cap| {
                    if (cap.pin == a.pin) {
                        found_cap = true;
                        var func_allowed = false;
                        for (cap.allowed_functions) |f| {
                            if (f == a.function) {
                                func_allowed = true;
                                break;
                            }
                        }
                        if (!func_allowed)
                            return std.fmt.comptimePrint(
                                "pin {} does not support function {}",
                                .{ @intFromEnum(a.pin), @intFromEnum(a.function) },
                            );
                        break;
                    }
                }
                if (!found_cap)
                    return std.fmt.comptimePrint(
                        "pin {} not found in capability table",
                        .{@intFromEnum(a.pin)},
                    );
            }

            // SPI pins must all use the same speed setting
            var spi_speed: ?@TypeOf(self.assignments[0].speed) = null;
            for (self.assignments) |a| {
                switch (a.function) {
                    .spi1_sck, .spi1_mosi, .spi1_miso, .spi1_nss => {
                        if (spi_speed) |s| {
                            if (a.speed != s)
                                return "all SPI pins must use the same speed setting";
                        } else {
                            spi_speed = a.speed;
                        }
                    },
                    else => {},
                }
            }

            return null;
        }
    };
}

fn PeripheralGroupConfig(comptime N: usize) type {
    return struct {
        assignments: [N]PinAssignment,

        pub fn contractValidate(comptime self: @This()) ?[]const u8 {
            // If any SPI pin is assigned, ALL SPI pins must be assigned
            var has_spi = false;
            var spi_count: u8 = 0;
            for (self.assignments) |a| {
                switch (a.function) {
                    .spi1_sck, .spi1_mosi, .spi1_miso, .spi1_nss => {
                        has_spi = true;
                        spi_count += 1;
                    },
                    else => {},
                }
            }
            if (has_spi and spi_count != 4)
                return "SPI requires all 4 pins (SCK, MOSI, MISO, NSS) to be assigned";

            // If any UART pin is assigned, both TX and RX must be assigned
            var has_uart_tx = false;
            var has_uart_rx = false;
            for (self.assignments) |a| {
                if (a.function == .uart1_tx) has_uart_tx = true;
                if (a.function == .uart1_rx) has_uart_rx = true;
            }
            if ((has_uart_tx or has_uart_rx) and !(has_uart_tx and has_uart_rx))
                return "UART requires both TX and RX pins";

            // If any I2C pin is assigned, both SCL and SDA must be assigned
            var has_scl = false;
            var has_sda = false;
            for (self.assignments) |a| {
                if (a.function == .i2c1_scl) has_scl = true;
                if (a.function == .i2c1_sda) has_sda = true;
            }
            if ((has_scl or has_sda) and !(has_scl and has_sda))
                return "I2C requires both SCL and SDA pins";

            return null;
        }
    };
}

const pin_capabilities = [_]PinCapability{
    .{ .pin = .pa0, .allowed_functions = &.{ .gpio, .adc_ch0, .timer1_ch1 } },
    .{ .pin = .pa1, .allowed_functions = &.{ .gpio, .adc_ch1, .timer1_ch2 } },
    .{ .pin = .pa2, .allowed_functions = &.{ .gpio, .adc_ch2, .uart1_tx } },
    .{ .pin = .pa3, .allowed_functions = &.{ .gpio, .adc_ch3, .uart1_rx } },
    .{ .pin = .pa4, .allowed_functions = &.{ .gpio, .spi1_nss } },
    .{ .pin = .pa5, .allowed_functions = &.{ .gpio, .spi1_sck } },
    .{ .pin = .pa6, .allowed_functions = &.{ .gpio, .spi1_miso } },
    .{ .pin = .pa7, .allowed_functions = &.{ .gpio, .spi1_mosi } },
    .{ .pin = .pb0, .allowed_functions = &.{ .gpio, .adc_ch0 } },
    .{ .pin = .pb1, .allowed_functions = &.{ .gpio, .adc_ch1 } },
    .{ .pin = .pb2, .allowed_functions = &.{.gpio} },
    .{ .pin = .pb3, .allowed_functions = &.{.gpio} },
    .{ .pin = .pb4, .allowed_functions = &.{ .gpio, .timer1_ch1 } },
    .{ .pin = .pb5, .allowed_functions = &.{ .gpio, .timer1_ch2 } },
    .{ .pin = .pb6, .allowed_functions = &.{ .gpio, .i2c1_scl, .uart1_tx } },
    .{ .pin = .pb7, .allowed_functions = &.{ .gpio, .i2c1_sda, .uart1_rx } },
};

const assignments = [_]PinAssignment{
    .{ .pin = .pa0, .function = .adc_ch0, .pull = .none, .speed = .low },
    .{ .pin = .pa1, .function = .adc_ch1, .pull = .none, .speed = .low },
    .{ .pin = .pa2, .function = .uart1_tx, .pull = .none, .speed = .high },
    .{ .pin = .pa3, .function = .uart1_rx, .pull = .up, .speed = .high },
    .{ .pin = .pa4, .function = .spi1_nss, .pull = .up, .speed = .very_high },
    .{ .pin = .pa5, .function = .spi1_sck, .pull = .none, .speed = .very_high },
    .{ .pin = .pa6, .function = .spi1_miso, .pull = .none, .speed = .very_high },
    .{ .pin = .pa7, .function = .spi1_mosi, .pull = .none, .speed = .very_high },
    .{ .pin = .pb2, .function = .gpio, .pull = .down, .speed = .low },
    .{ .pin = .pb3, .function = .gpio, .pull = .down, .speed = .low },
    .{ .pin = .pb6, .function = .i2c1_scl, .pull = .up, .speed = .medium },
    .{ .pin = .pb7, .function = .i2c1_sda, .pull = .up, .speed = .medium },
};

const app_pin_config = contract.validated(PinMuxConfig(assignments.len){
    .assignments = assignments,
    .capabilities = &pin_capabilities,
}).assignments;

comptime {
    contract.assertValid(PeripheralGroupConfig(assignments.len){
        .assignments = assignments,
    });
}

test "pin mux has no duplicate pins" {
    comptime {
        try std.testing.expectEqual(12, app_pin_config.len);
        for (0..app_pin_config.len) |i| {
            for (i + 1..app_pin_config.len) |j| {
                try std.testing.expect(app_pin_config[i].pin != app_pin_config[j].pin);
            }
        }
    }
}

test "SPI pins all use same speed" {
    comptime {
        var spi_speeds: [4]@TypeOf(app_pin_config[0].speed) = undefined;
        var count: u8 = 0;
        for (app_pin_config) |a| {
            switch (a.function) {
                .spi1_sck, .spi1_mosi, .spi1_miso, .spi1_nss => {
                    spi_speeds[count] = a.speed;
                    count += 1;
                },
                else => {},
            }
        }
        try std.testing.expectEqual(4, count);
        for (spi_speeds[1..4]) |s| {
            try std.testing.expectEqual(spi_speeds[0], s);
        }
    }
}

test "ADC pins have no pull resistor" {
    comptime {
        for (app_pin_config) |a| {
            switch (a.function) {
                .adc_ch0, .adc_ch1, .adc_ch2, .adc_ch3 => {
                    try std.testing.expectEqual(.none, a.pull);
                },
                else => {},
            }
        }
    }
}

test "I2C pins have pull-up" {
    comptime {
        for (app_pin_config) |a| {
            switch (a.function) {
                .i2c1_scl, .i2c1_sda => {
                    try std.testing.expectEqual(.up, a.pull);
                },
                else => {},
            }
        }
    }
}

test "all SPI pins are assigned as a group" {
    comptime {
        var spi_count: u8 = 0;
        for (app_pin_config) |a| {
            switch (a.function) {
                .spi1_sck, .spi1_mosi, .spi1_miso, .spi1_nss => spi_count += 1,
                else => {},
            }
        }
        try std.testing.expectEqual(4, spi_count);
    }
}
