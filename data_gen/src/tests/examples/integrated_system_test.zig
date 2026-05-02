const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;
const generators = @import("data_gen").generators;

// --- Integrated Embedded System Configuration ---
// A complete system definition that composes pin mux, clock tree,
// peripheral configs, memory layout, task scheduling, and sensor
// pipeline into a single validated configuration. Tests that
// cross-subsystem constraints work when everything is wired together.

// ---- Clock Tree ----

const ClockSource = enum(u8) { hsi, hse, pll };

const ClockConfig = struct {
    source: ClockSource,
    hse_freq_hz: u32,
    pll_multiplier: u8,
    ahb_divider: u8,
    apb1_divider: u8,
    apb2_divider: u8,

    pub fn sysClockHz(comptime self: ClockConfig) u32 {
        const base = switch (self.source) {
            .hsi => 16_000_000,
            .hse => self.hse_freq_hz,
            .pll => self.hse_freq_hz * self.pll_multiplier,
        };
        return base;
    }

    pub fn ahbHz(comptime self: ClockConfig) u32 {
        return self.sysClockHz() / self.ahb_divider;
    }

    pub fn apb1Hz(comptime self: ClockConfig) u32 {
        return self.ahbHz() / self.apb1_divider;
    }

    pub fn apb2Hz(comptime self: ClockConfig) u32 {
        return self.ahbHz() / self.apb2_divider;
    }

    pub fn validate(comptime self: ClockConfig) ?[]const u8 {
        if (self.source == .hse or self.source == .pll) {
            if (self.hse_freq_hz < 4_000_000 or self.hse_freq_hz > 25_000_000)
                return "hse_freq_hz out of range [4000000, 25000000]";
        }

        if (self.pll_multiplier != 2 and self.pll_multiplier != 3 and self.pll_multiplier != 4 and
            self.pll_multiplier != 6 and self.pll_multiplier != 8 and self.pll_multiplier != 9 and
            self.pll_multiplier != 12)
            return "pll_multiplier must be one of 2, 3, 4, 6, 8, 9, 12";
        if (self.ahb_divider != 1 and self.ahb_divider != 2 and self.ahb_divider != 4 and self.ahb_divider != 8)
            return "ahb_divider must be one of 1, 2, 4, 8";
        if (self.apb1_divider != 1 and self.apb1_divider != 2 and self.apb1_divider != 4)
            return "apb1_divider must be one of 1, 2, 4";
        if (self.apb2_divider != 1 and self.apb2_divider != 2 and self.apb2_divider != 4)
            return "apb2_divider must be one of 1, 2, 4";

        if (self.sysClockHz() < 1_000_000 or self.sysClockHz() > 168_000_000)
            return "sysClockHz out of range [1000000, 168000000]";
        if (self.ahbHz() < 1_000_000 or self.ahbHz() > 168_000_000)
            return "ahbHz out of range [1000000, 168000000]";
        if (self.apb1Hz() < 1_000_000 or self.apb1Hz() > 42_000_000)
            return "apb1Hz out of range [1000000, 42000000]";
        if (self.apb2Hz() < 1_000_000 or self.apb2Hz() > 84_000_000)
            return "apb2Hz out of range [1000000, 84000000]";
        return null;
    }
};

// ---- Memory Layout ----

const MemRegion = struct {
    name_id: u8,
    base: u32,
    size: u32,
    writable: bool,
    executable: bool,
};

fn validateMemLayout(comptime regions: []const MemRegion) void {
    for (regions) |r| {
        constraints.assert(constraints.nonZero(r.size));
        constraints.assert(constraints.isPowerOfTwo(r.size));
        if (r.writable and r.executable)
            @compileError("W^X violation");
    }
    for (0..regions.len) |i| {
        for (i + 1..regions.len) |j| {
            const a_end = regions[i].base + regions[i].size;
            const b_end = regions[j].base + regions[j].size;
            if (regions[i].base < b_end and regions[j].base < a_end)
                @compileError("memory regions overlap");
        }
    }
}

// ---- UART Config ----

const UartConfig = struct {
    baud_rate: u32,
    data_bits: u8,
    stop_bits: u8,
    parity: bool,
    dma_enabled: bool,

    pub fn validateWith(comptime self: UartConfig, comptime apb_hz: u32) void {
        constraints.assert(constraints.oneOf(&.{ 9600, 19200, 57600, 115200, 460800, 921600 }, self.baud_rate));
        constraints.assert(constraints.oneOf(&.{ 7, 8 }, self.data_bits));
        constraints.assert(constraints.oneOf(&.{ 1, 2 }, self.stop_bits));

        // Baud rate must be achievable from APB clock with < 2% error
        // UART divider = apb_hz / (16 * baud_rate)
        const divider = apb_hz / (16 * self.baud_rate);
        if (divider == 0)
            @compileError("baud rate too high for APB clock");
        const actual_baud = apb_hz / (16 * divider);
        const error_pct = if (actual_baud > self.baud_rate)
            (actual_baud - self.baud_rate) * 100 / self.baud_rate
        else
            (self.baud_rate - actual_baud) * 100 / self.baud_rate;
        if (error_pct > 2)
            @compileError(std.fmt.comptimePrint(
                "baud rate error {}% exceeds 2% (APB={}Hz, baud={})",
                .{ error_pct, apb_hz, self.baud_rate },
            ));
    }
};

// ---- SPI Config ----

const SpiConfig = struct {
    max_clock_hz: u32,
    mode: u2,
    bit_order: enum(u1) { msb_first, lsb_first },
    dma_enabled: bool,

    pub fn validateWith(comptime self: SpiConfig, comptime apb_hz: u32) void {
        constraints.assert(constraints.nonZero(self.max_clock_hz));
        if (self.max_clock_hz > apb_hz / 2)
            @compileError("SPI clock cannot exceed APB/2");
    }
};

// ---- ADC Config ----

const AdcConfig = struct {
    resolution_bits: u8,
    sample_rate_hz: u32,
    channels: u8,
    dma_circular: bool,

    pub fn validateWith(comptime self: AdcConfig, comptime apb_hz: u32) void {
        constraints.assert(constraints.oneOf(&.{ 8, 10, 12 }, self.resolution_bits));
        constraints.assert(constraints.inRange(100, 1_000_000, self.sample_rate_hz));
        constraints.assert(constraints.inRange(1, 16, self.channels));

        const total_sample_rate = self.sample_rate_hz * self.channels;
        const max_rate = apb_hz / (self.resolution_bits + 12);
        if (total_sample_rate > max_rate)
            @compileError("total ADC sample rate exceeds hardware capability");
    }
};

// ---- Task Set ----

const TaskConfig = struct {
    id: u8,
    period_us: u32,
    wcet_us: u32,
    stack_bytes: u16,
    uses_uart: bool,
    uses_spi: bool,
    uses_adc: bool,
};

fn validateTasks(comptime tasks: []const TaskConfig, comptime ram_bytes: u32) void {
    constraints.assert(constraints.lenInRange(1, 16, tasks.len));

    var total_stack: u32 = 0;
    var total_util_x1000: u32 = 0;
    for (tasks) |t| {
        constraints.assert(constraints.nonZero(t.period_us));
        constraints.assert(constraints.nonZero(t.wcet_us));
        constraints.assert(constraints.isPowerOfTwo(t.stack_bytes));
        if (t.wcet_us >= t.period_us)
            @compileError("WCET exceeds period");
        total_stack += t.stack_bytes;
        total_util_x1000 += t.wcet_us * 1000 / t.period_us;
    }

    if (total_stack > ram_bytes / 2)
        @compileError(std.fmt.comptimePrint(
            "total stack {}B exceeds half of RAM ({}B)",
            .{ total_stack, ram_bytes },
        ));

    if (total_util_x1000 > 800)
        @compileError(std.fmt.comptimePrint(
            "CPU utilization {}‰ exceeds 800‰ limit",
            .{total_util_x1000},
        ));
}

// ---- Full System ----

const SystemConfig = struct {
    clock: ClockConfig,
    memory: [3]MemRegion,
    uart: UartConfig,
    spi: SpiConfig,
    adc: AdcConfig,
    tasks: [5]TaskConfig,

    pub fn validate(comptime self: SystemConfig) ?[]const u8 {
        validateMemLayout(&self.memory);
        self.uart.validateWith(self.clock.apb1Hz());
        self.spi.validateWith(self.clock.apb2Hz());
        self.adc.validateWith(self.clock.apb2Hz());

        var ram_size: u32 = 0;
        for (self.memory) |region| {
            if (region.writable and !region.executable)
                ram_size += region.size;
        }
        validateTasks(&self.tasks, ram_size);

        // Cross-subsystem: ADC tasks must have the ADC peripheral enabled
        for (self.tasks) |task| {
            if (task.uses_adc and self.adc.channels == 0)
                return "task uses ADC but no ADC channels configured";
        }

        // DMA contention: if both UART and SPI use DMA, warn unless
        // no task uses both simultaneously
        if (self.uart.dma_enabled and self.spi.dma_enabled) {
            for (self.tasks) |task| {
                if (task.uses_uart and task.uses_spi)
                    return "task uses both UART and SPI with DMA — potential bus contention";
            }
        }
        return null;
    }
};

const my_system = contracts.validated(SystemConfig{
    .clock = ClockConfig{
        .source = .pll,
        .hse_freq_hz = 8_000_000,
        .pll_multiplier = 9,
        .ahb_divider = 1,
        .apb1_divider = 2,
        .apb2_divider = 1,
    },
    .memory = .{
        MemRegion{ .name_id = 0, .base = 0x08000000, .size = 0x40000, .writable = false, .executable = true },
        MemRegion{ .name_id = 1, .base = 0x20000000, .size = 0x10000, .writable = true, .executable = false },
        MemRegion{ .name_id = 2, .base = 0x40000000, .size = 0x1000, .writable = true, .executable = false },
    },
    .uart = UartConfig{
        .baud_rate = 115200,
        .data_bits = 8,
        .stop_bits = 1,
        .parity = false,
        .dma_enabled = true,
    },
    .spi = SpiConfig{
        .max_clock_hz = 18_000_000,
        .mode = 0,
        .bit_order = .msb_first,
        .dma_enabled = true,
    },
    .adc = AdcConfig{
        .resolution_bits = 12,
        .sample_rate_hz = 100_000,
        .channels = 4,
        .dma_circular = true,
    },
    .tasks = .{
        TaskConfig{ .id = 0, .period_us = 100, .wcet_us = 20, .stack_bytes = 512, .uses_uart = false, .uses_spi = false, .uses_adc = true },
        TaskConfig{ .id = 1, .period_us = 1000, .wcet_us = 100, .stack_bytes = 1024, .uses_uart = false, .uses_spi = true, .uses_adc = false },
        TaskConfig{ .id = 2, .period_us = 10000, .wcet_us = 500, .stack_bytes = 1024, .uses_uart = true, .uses_spi = false, .uses_adc = false },
        TaskConfig{ .id = 3, .period_us = 50000, .wcet_us = 2000, .stack_bytes = 2048, .uses_uart = false, .uses_spi = false, .uses_adc = false },
        TaskConfig{ .id = 4, .period_us = 100000, .wcet_us = 5000, .stack_bytes = 4096, .uses_uart = false, .uses_spi = false, .uses_adc = false },
    },
});

test "system clock frequencies" {
    comptime {
        try std.testing.expectEqual(72_000_000, my_system.clock.sysClockHz());
        try std.testing.expectEqual(72_000_000, my_system.clock.ahbHz());
        try std.testing.expectEqual(36_000_000, my_system.clock.apb1Hz());
        try std.testing.expectEqual(72_000_000, my_system.clock.apb2Hz());
    }
}

test "system memory regions do not overlap" {
    comptime {
        for (0..my_system.memory.len) |i| {
            for (i + 1..my_system.memory.len) |j| {
                const a_end = my_system.memory[i].base + my_system.memory[i].size;
                try std.testing.expect(a_end <= my_system.memory[j].base);
            }
        }
    }
}

test "system UART baud rate achievable from APB1" {
    comptime {
        const apb1 = my_system.clock.apb1Hz();
        const divider = apb1 / (16 * my_system.uart.baud_rate);
        try std.testing.expect(divider > 0);
    }
}

test "system no DMA contention between UART and SPI" {
    comptime {
        for (my_system.tasks) |task| {
            try std.testing.expect(!(task.uses_uart and task.uses_spi));
        }
    }
}

test "system task stacks fit in RAM" {
    comptime {
        var stack_total: u32 = 0;
        for (my_system.tasks) |t| stack_total += t.stack_bytes;
        try std.testing.expect(stack_total <= my_system.memory[1].size / 2);
    }
}

test "full system passes integrated validation" {
    comptime {
        contracts.assertValid(my_system);
    }
}
