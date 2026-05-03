const std = @import("std");
const constraint = @import("data_gen").constraint;
const contract = @import("data_gen").contract;

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

    /// Compute the system clock frequency in Hz.
    pub fn sysClockHz(comptime self: ClockConfig) u32 {
        const base = switch (self.source) {
            .hsi => 16_000_000,
            .hse => self.hse_freq_hz,
            .pll => self.hse_freq_hz * self.pll_multiplier,
        };
        return base;
    }

    /// Compute the AHB bus clock frequency in Hz.
    pub fn ahbHz(comptime self: ClockConfig) u32 {
        return self.sysClockHz() / self.ahb_divider;
    }

    /// Compute the APB1 bus clock frequency in Hz.
    pub fn apb1Hz(comptime self: ClockConfig) u32 {
        return self.ahbHz() / self.apb1_divider;
    }

    /// Compute the APB2 bus clock frequency in Hz.
    pub fn apb2Hz(comptime self: ClockConfig) u32 {
        return self.ahbHz() / self.apb2_divider;
    }

    /// Validate constraints for this type.
    pub fn contractValidate(comptime self: ClockConfig) ?[]const u8 {
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

    /// Validate constraints for this type.
    pub fn contractValidate(comptime self: MemRegion) ?[]const u8 {
        if (constraint.nonZero(self.size)) |err| return err;
        if (constraint.isPowerOfTwo(self.size)) |err| return err;
        if (self.writable and self.executable)
            return "W^X violation";
        return null;
    }
};

const MemLayoutValidator = struct {
    regions: []const MemRegion,

    /// Validate constraints for this type.
    pub fn contractValidate(comptime self: MemLayoutValidator) ?[]const u8 {
        for (self.regions) |r| {
            if (r.contractValidate()) |err| return err;
        }
        for (0..self.regions.len) |i| {
            for (i + 1..self.regions.len) |j| {
                const a_end = self.regions[i].base + self.regions[i].size;
                const b_end = self.regions[j].base + self.regions[j].size;
                if (self.regions[i].base < b_end and self.regions[j].base < a_end)
                    return "memory regions overlap";
            }
        }
        return null;
    }
};

// ---- UART Config ----

const UartConfig = struct {
    baud_rate: u32,
    data_bits: u8,
    stop_bits: u8,
    parity: bool,
    dma_enabled: bool,

    /// Validate with additional context parameters.
    pub fn validateWith(comptime self: UartConfig, comptime apb_hz: u32) ?[]const u8 {
        if (constraint.oneOf(&.{ 9600, 19200, 57600, 115200, 460800, 921600 }, self.baud_rate)) |err| return err;
        if (constraint.oneOf(&.{ 7, 8 }, self.data_bits)) |err| return err;
        if (constraint.oneOf(&.{ 1, 2 }, self.stop_bits)) |err| return err;

        // Baud rate must be achievable from APB clock with < 2% error
        // UART divider = apb_hz / (16 * baud_rate)
        const divider = apb_hz / (16 * self.baud_rate);
        if (divider == 0)
            return "baud rate too high for APB clock";
        const actual_baud = apb_hz / (16 * divider);
        const error_pct = if (actual_baud > self.baud_rate)
            (actual_baud - self.baud_rate) * 100 / self.baud_rate
        else
            (self.baud_rate - actual_baud) * 100 / self.baud_rate;
        if (error_pct > 2)
            return std.fmt.comptimePrint(
                "baud rate error {}% exceeds 2% (APB={}Hz, baud={})",
                .{ error_pct, apb_hz, self.baud_rate },
            );
        return null;
    }
};

const UartValidator = struct {
    uart: UartConfig,
    apb_hz: u32,

    /// Validate constraints for this type.
    pub fn contractValidate(comptime self: UartValidator) ?[]const u8 {
        return self.uart.validateWith(self.apb_hz);
    }
};

// ---- SPI Config ----

const SpiConfig = struct {
    max_clock_hz: u32,
    mode: u2,
    bit_order: enum(u1) { msb_first, lsb_first },
    dma_enabled: bool,

    /// Validate with additional context parameters.
    pub fn validateWith(comptime self: SpiConfig, comptime apb_hz: u32) ?[]const u8 {
        if (constraint.nonZero(self.max_clock_hz)) |err| return err;
        if (self.max_clock_hz > apb_hz / 2)
            return "SPI clock cannot exceed APB/2";
        return null;
    }
};

const SpiValidator = struct {
    spi: SpiConfig,
    apb_hz: u32,

    /// Validate constraints for this type.
    pub fn contractValidate(comptime self: SpiValidator) ?[]const u8 {
        return self.spi.validateWith(self.apb_hz);
    }
};

// ---- ADC Config ----

const AdcConfig = struct {
    resolution_bits: u8,
    sample_rate_hz: u32,
    channels: u8,
    dma_circular: bool,

    /// Validate with additional context parameters.
    pub fn validateWith(comptime self: AdcConfig, comptime apb_hz: u32) ?[]const u8 {
        if (constraint.oneOf(&.{ 8, 10, 12 }, self.resolution_bits)) |err| return err;
        if (constraint.inRange(100, 1_000_000, self.sample_rate_hz)) |err| return err;
        if (constraint.inRange(1, 16, self.channels)) |err| return err;

        const total_sample_rate = self.sample_rate_hz * self.channels;
        const max_rate = apb_hz / (self.resolution_bits + 12);
        if (total_sample_rate > max_rate)
            return "total ADC sample rate exceeds hardware capability";
        return null;
    }
};

const AdcValidator = struct {
    adc: AdcConfig,
    apb_hz: u32,

    /// Validate constraints for this type.
    pub fn contractValidate(comptime self: AdcValidator) ?[]const u8 {
        return self.adc.validateWith(self.apb_hz);
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

    /// Validate constraints for this type.
    pub fn contractValidate(comptime self: TaskConfig) ?[]const u8 {
        if (constraint.nonZero(self.period_us)) |err| return err;
        if (constraint.nonZero(self.wcet_us)) |err| return err;
        if (constraint.isPowerOfTwo(self.stack_bytes)) |err| return err;
        if (self.wcet_us >= self.period_us)
            return "WCET exceeds period";
        return null;
    }
};

const TaskSetValidator = struct {
    tasks: []const TaskConfig,
    ram_bytes: u32,

    /// Validate constraints for this type.
    pub fn contractValidate(comptime self: TaskSetValidator) ?[]const u8 {
        if (constraint.lenInRange(1, 16, self.tasks.len)) |err| return err;

        var total_stack: u32 = 0;
        var total_util_x1000: u32 = 0;
        for (self.tasks) |t| {
            if (t.contractValidate()) |err| return err;
            total_stack += t.stack_bytes;
            total_util_x1000 += t.wcet_us * 1000 / t.period_us;
        }

        if (total_stack > self.ram_bytes / 2)
            return std.fmt.comptimePrint(
                "total stack {}B exceeds half of RAM ({}B)",
                .{ total_stack, self.ram_bytes },
            );

        if (total_util_x1000 > 800)
            return std.fmt.comptimePrint(
                "CPU utilization {}‰ exceeds 800‰ limit",
                .{total_util_x1000},
            );
        return null;
    }
};

// ---- Full System ----

const SystemConfig = struct {
    clock: ClockConfig,
    memory: [3]MemRegion,
    uart: UartConfig,
    spi: SpiConfig,
    adc: AdcConfig,
    tasks: [5]TaskConfig,

    /// Validate constraints for this type.
    pub fn contractValidate(comptime self: SystemConfig) ?[]const u8 {
        const mem_validator = MemLayoutValidator{ .regions = &self.memory };
        if (mem_validator.contractValidate()) |err| return err;

        const uart_validator = UartValidator{ .uart = self.uart, .apb_hz = self.clock.apb1Hz() };
        if (uart_validator.contractValidate()) |err| return err;

        const spi_validator = SpiValidator{ .spi = self.spi, .apb_hz = self.clock.apb2Hz() };
        if (spi_validator.contractValidate()) |err| return err;

        const adc_validator = AdcValidator{ .adc = self.adc, .apb_hz = self.clock.apb2Hz() };
        if (adc_validator.contractValidate()) |err| return err;

        var ram_size: u32 = 0;
        for (self.memory) |region| {
            if (region.writable and !region.executable)
                ram_size += region.size;
        }
        const task_validator = TaskSetValidator{ .tasks = &self.tasks, .ram_bytes = ram_size };
        if (task_validator.contractValidate()) |err| return err;

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

const my_system = contract.validated(SystemConfig{
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
        contract.assertValid(my_system);
    }
}
