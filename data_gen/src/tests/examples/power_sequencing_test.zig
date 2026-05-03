const std = @import("std");
const constraint = @import("data_gen").constraint;
const contract = @import("data_gen").contract;

// --- Power Rail Sequencing ---
// Voltage rails must power up in a specific order with minimum timing
// gaps between them. Some rails depend on others being stable first.
// Power-down order is the reverse.

const RailId = enum(u8) { vbat, v3v3_always, v1v8_core, v1v0_pll, v3v3_io, v2v5_ddr, vtt_ddr };

const RailSpec = struct {
    rail: RailId,
    voltage_mv: u16,
    max_current_ma: u16,
    enable_delay_us: u32,
    stable_time_us: u32,
    depends_on: ?RailId,
    min_gap_after_dep_us: u32,

    pub fn contractValidate(comptime self: RailSpec) ?[]const u8 {
        if (constraint.nonZero(self.voltage_mv)) |err| return err;
        if (constraint.nonZero(self.max_current_ma)) |err| return err;
        return null;
    }
};

fn ValidatedPowerSequence(comptime len: usize) type {
    return struct {
        rails: [len]RailSpec,

        pub fn contractValidate(comptime self: @This()) ?[]const u8 {
            @setEvalBranchQuota(5000);
            if (constraint.lenInRange(2, 16, self.rails.len)) |err| return err;

            // Unique rail IDs
            var ids: [len]u8 = undefined;
            for (self.rails, 0..) |rail, i| {
                ids[i] = @intFromEnum(rail.rail);
            }
            if (constraint.noDuplicates(u8, &ids)) |err| return err;

            // Dependencies must reference rails that appear earlier in the sequence
            for (self.rails, 0..) |rail, i| {
                if (rail.depends_on) |dep| {
                    var dep_idx: ?usize = null;
                    for (self.rails[0..i], 0..) |earlier, j| {
                        if (earlier.rail == dep) {
                            dep_idx = j;
                            break;
                        }
                    }
                    if (dep_idx == null)
                        return std.fmt.comptimePrint(
                            "rail {} depends on {} which must appear earlier in sequence",
                            .{ @intFromEnum(rail.rail), @intFromEnum(dep) },
                        );
                }
            }

            // No circular dependencies (since we require deps to appear earlier, this is
            // guaranteed, but let's also verify no rail transitively depends on itself)
            for (self.rails) |start_rail| {
                var current = start_rail.depends_on;
                var depth: u8 = 0;
                while (current != null and depth < self.rails.len) : (depth += 1) {
                    if (current.? == start_rail.rail)
                        return "circular power rail dependency detected";
                    for (self.rails) |r| {
                        if (r.rail == current.?) {
                            current = r.depends_on;
                            break;
                        }
                    }
                }
            }

            // First rail must have no dependency (it's the root supply)
            if (self.rails[0].depends_on != null)
                return "first rail in sequence must have no dependency (root supply)";

            // DDR voltage relationship: VTT must be approximately half of VDDQ
            var vtt_rail: ?RailSpec = null;
            var vddq_rail: ?RailSpec = null;
            for (self.rails) |rail| {
                if (rail.rail == .vtt_ddr) vtt_rail = rail;
                if (rail.rail == .v2v5_ddr) vddq_rail = rail;
            }
            if (vtt_rail != null and vddq_rail != null) {
                const vtt = vtt_rail.?.voltage_mv;
                const vddq = vddq_rail.?.voltage_mv;
                const half_vddq = vddq / 2;
                const tolerance = vddq / 20; // 5% tolerance
                if (vtt < half_vddq - tolerance or vtt > half_vddq + tolerance)
                    return std.fmt.comptimePrint(
                        "VTT ({}mV) must be within 5% of half VDDQ ({}mV)",
                        .{ vtt, vddq },
                    );
            }

            return null;
        }
    };
}

const power_sequence = blk: {
    const rails = [_]RailSpec{
        .{
            .rail = .vbat,
            .voltage_mv = 3700,
            .max_current_ma = 2000,
            .enable_delay_us = 0,
            .stable_time_us = 1000,
            .depends_on = null,
            .min_gap_after_dep_us = 0,
        },
        .{
            .rail = .v3v3_always,
            .voltage_mv = 3300,
            .max_current_ma = 500,
            .enable_delay_us = 100,
            .stable_time_us = 500,
            .depends_on = .vbat,
            .min_gap_after_dep_us = 1000,
        },
        .{
            .rail = .v1v8_core,
            .voltage_mv = 1800,
            .max_current_ma = 1000,
            .enable_delay_us = 200,
            .stable_time_us = 1000,
            .depends_on = .v3v3_always,
            .min_gap_after_dep_us = 500,
        },
        .{
            .rail = .v1v0_pll,
            .voltage_mv = 1000,
            .max_current_ma = 200,
            .enable_delay_us = 50,
            .stable_time_us = 2000,
            .depends_on = .v1v8_core,
            .min_gap_after_dep_us = 1000,
        },
        .{
            .rail = .v2v5_ddr,
            .voltage_mv = 2500,
            .max_current_ma = 800,
            .enable_delay_us = 300,
            .stable_time_us = 1000,
            .depends_on = .v3v3_always,
            .min_gap_after_dep_us = 500,
        },
        .{
            .rail = .vtt_ddr,
            .voltage_mv = 1250,
            .max_current_ma = 400,
            .enable_delay_us = 100,
            .stable_time_us = 500,
            .depends_on = .v2v5_ddr,
            .min_gap_after_dep_us = 200,
        },
        .{
            .rail = .v3v3_io,
            .voltage_mv = 3300,
            .max_current_ma = 300,
            .enable_delay_us = 50,
            .stable_time_us = 200,
            .depends_on = .v1v8_core,
            .min_gap_after_dep_us = 500,
        },
    };
    break :blk contract.validated(ValidatedPowerSequence(rails.len){ .rails = rails }).rails;
};

test "power sequence starts with battery" {
    comptime {
        try std.testing.expectEqual(RailId.vbat, power_sequence[0].rail);
        try std.testing.expectEqual(@as(?RailId, null), power_sequence[0].depends_on);
    }
}

test "power sequence dependencies are ordered" {
    comptime {
        for (power_sequence, 0..) |rail, i| {
            if (rail.depends_on) |dep| {
                var found = false;
                for (power_sequence[0..i]) |earlier| {
                    if (earlier.rail == dep) found = true;
                }
                try std.testing.expect(found);
            }
        }
    }
}

test "VTT is half of VDDQ within tolerance" {
    comptime {
        var vtt_mv: u16 = 0;
        var vddq_mv: u16 = 0;
        for (power_sequence) |rail| {
            if (rail.rail == .vtt_ddr) vtt_mv = rail.voltage_mv;
            if (rail.rail == .v2v5_ddr) vddq_mv = rail.voltage_mv;
        }
        const half = vddq_mv / 2;
        const diff = if (vtt_mv > half) vtt_mv - half else half - vtt_mv;
        try std.testing.expect(diff <= vddq_mv / 20);
    }
}

test "power sequence has 7 rails" {
    comptime {
        try std.testing.expectEqual(7, power_sequence.len);
    }
}

// --- Inrush Current Budget ---
// When powering up, the total inrush current at any point in the sequence
// must not exceed the supply capacity.

fn ValidatedInrushBudget(comptime len: usize) type {
    return struct {
        rails: [len]RailSpec,
        supply_max_ma: u32,

        pub fn contractValidate(comptime self: @This()) ?[]const u8 {
            // At each step, compute worst-case concurrent inrush (current rail + any
            // rail whose stable_time overlaps with current rail's enable time)
            var cumulative_time_us: u32 = 0;
            for (self.rails) |rail| {
                var concurrent_current: u32 = rail.max_current_ma;
                const my_start = cumulative_time_us;
                const my_end = my_start + rail.enable_delay_us + rail.stable_time_us;

                var prev_time: u32 = 0;
                for (self.rails) |prev_rail| {
                    if (prev_rail.rail == rail.rail) break;
                    const prev_end = prev_time + prev_rail.enable_delay_us + prev_rail.stable_time_us;
                    if (prev_end > my_start)
                        concurrent_current += prev_rail.max_current_ma;
                    prev_time += prev_rail.enable_delay_us + prev_rail.stable_time_us + prev_rail.min_gap_after_dep_us;
                }

                if (concurrent_current > self.supply_max_ma)
                    return std.fmt.comptimePrint(
                        "inrush current {}mA at rail {} exceeds supply capacity {}mA",
                        .{ concurrent_current, @intFromEnum(rail.rail), self.supply_max_ma },
                    );

                cumulative_time_us = my_end + rail.min_gap_after_dep_us;
            }
            return null;
        }
    };
}

test "power sequence inrush within 3A supply budget" {
    comptime {
        contract.assertValid(ValidatedInrushBudget(power_sequence.len){
            .rails = power_sequence,
            .supply_max_ma = 3000,
        });
    }
}
