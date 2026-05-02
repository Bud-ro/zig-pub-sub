const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;
const generators = @import("data_gen").generators;

// --- Washing Machine Cycle ---

const WashPhase = enum(u8) { fill, heat, wash, rinse, spin, drain };

const WashStep = struct {
    phase: WashPhase,
    duration_seconds: u16,
    water_temp_c: u8,
    drum_rpm: u16,
    water_liters: u8,

    pub fn validate(comptime self: WashStep) ?[]const u8 {
        if (self.duration_seconds < 1 or self.duration_seconds > 3600) return "duration_seconds out of range [1, 3600]";

        switch (self.phase) {
            .fill => {
                if (self.drum_rpm != 0)
                    return "drum must be stopped during fill";
                if (self.water_temp_c < 10 or self.water_temp_c > 60) return "water_temp_c out of range [10, 60] for fill";
                if (self.water_liters == 0) return "water_liters must not be zero for fill";
            },
            .heat => {
                if (self.drum_rpm != 0)
                    return "drum must be stopped during heat";
                if (self.water_temp_c < 30 or self.water_temp_c > 95) return "water_temp_c out of range [30, 95] for heat";
                if (self.water_liters != 0)
                    return "no water added during heat";
            },
            .wash => {
                if (self.drum_rpm < 20 or self.drum_rpm > 80) return "drum_rpm out of range [20, 80] for wash";
                if (self.water_temp_c < 20 or self.water_temp_c > 95) return "water_temp_c out of range [20, 95] for wash";
            },
            .rinse => {
                if (self.drum_rpm < 20 or self.drum_rpm > 60) return "drum_rpm out of range [20, 60] for rinse";
                if (self.water_temp_c < 10 or self.water_temp_c > 30) return "water_temp_c out of range [10, 30] for rinse";
            },
            .spin => {
                if (self.water_temp_c != 0)
                    return "no heating during spin";
                if (self.drum_rpm < 400 or self.drum_rpm > 1400) return "drum_rpm out of range [400, 1400] for spin";
                if (self.water_liters != 0)
                    return "no water during spin";
            },
            .drain => {
                if (self.drum_rpm != 0)
                    return "drum must be stopped during drain";
                if (self.water_temp_c != 0)
                    return "no heating during drain";
                if (self.water_liters != 0)
                    return "no water added during drain";
            },
        }
        return null;
    }
};

fn validateWashCycle(comptime cycle: []const WashStep) void {
    if (cycle.len < 3)
        @compileError("wash cycle needs at least fill, wash, drain");

    if (cycle[0].phase != .fill)
        @compileError("cycle must start with fill");

    if (cycle[cycle.len - 1].phase != .drain)
        @compileError("cycle must end with drain");

    var total_water: u32 = 0;
    var has_wash = false;
    for (cycle) |step| {
        contracts.assertValid(step);
        total_water += step.water_liters;
        if (step.phase == .wash) has_wash = true;
    }

    if (!has_wash)
        @compileError("cycle must include at least one wash phase");

    if (total_water > 100)
        @compileError("total water usage exceeds 100 liters");
}

const quick_wash = blk: {
    const steps = [_]WashStep{
        .{ .phase = .fill, .duration_seconds = 120, .water_temp_c = 30, .drum_rpm = 0, .water_liters = 15 },
        .{ .phase = .wash, .duration_seconds = 600, .water_temp_c = 30, .drum_rpm = 45, .water_liters = 0 },
        .{ .phase = .rinse, .duration_seconds = 300, .water_temp_c = 20, .drum_rpm = 30, .water_liters = 10 },
        .{ .phase = .spin, .duration_seconds = 480, .water_temp_c = 0, .drum_rpm = 1200, .water_liters = 0 },
        .{ .phase = .drain, .duration_seconds = 60, .water_temp_c = 0, .drum_rpm = 0, .water_liters = 0 },
    };
    validateWashCycle(&steps);
    break :blk steps;
};

const heavy_duty = blk: {
    const steps = [_]WashStep{
        .{ .phase = .fill, .duration_seconds = 180, .water_temp_c = 40, .drum_rpm = 0, .water_liters = 25 },
        .{ .phase = .heat, .duration_seconds = 300, .water_temp_c = 60, .drum_rpm = 0, .water_liters = 0 },
        .{ .phase = .wash, .duration_seconds = 1200, .water_temp_c = 60, .drum_rpm = 50, .water_liters = 0 },
        .{ .phase = .drain, .duration_seconds = 60, .water_temp_c = 0, .drum_rpm = 0, .water_liters = 0 },
        .{ .phase = .fill, .duration_seconds = 120, .water_temp_c = 20, .drum_rpm = 0, .water_liters = 20 },
        .{ .phase = .rinse, .duration_seconds = 300, .water_temp_c = 20, .drum_rpm = 40, .water_liters = 0 },
        .{ .phase = .rinse, .duration_seconds = 300, .water_temp_c = 20, .drum_rpm = 40, .water_liters = 10 },
        .{ .phase = .spin, .duration_seconds = 600, .water_temp_c = 0, .drum_rpm = 1400, .water_liters = 0 },
        .{ .phase = .drain, .duration_seconds = 60, .water_temp_c = 0, .drum_rpm = 0, .water_liters = 0 },
    };
    validateWashCycle(&steps);
    break :blk steps;
};

test "quick wash cycle is valid" {
    comptime {
        try std.testing.expectEqual(5, quick_wash.len);
        try std.testing.expectEqual(WashPhase.fill, quick_wash[0].phase);
        try std.testing.expectEqual(WashPhase.drain, quick_wash[quick_wash.len - 1].phase);
    }
}

test "heavy duty cycle is valid and uses correct water" {
    comptime {
        try std.testing.expectEqual(9, heavy_duty.len);
        var total_water: u32 = 0;
        for (heavy_duty) |step| {
            total_water += step.water_liters;
        }
        try std.testing.expect(total_water <= 100);
    }
}

// --- Manufacturing Process Steps ---

const ProcessPhase = enum(u8) { preheat, ramp_up, soak, cool_down, quench };

const ProcessStep = struct {
    phase: ProcessPhase,
    target_temp_c: i16,
    hold_time_seconds: u16,
    ramp_rate_c_per_min: u8,
};

fn validateHeatTreatProcess(comptime steps: []const ProcessStep) void {
    if (steps.len < 2)
        @compileError("process needs at least 2 steps");

    if (steps[0].phase != .preheat)
        @compileError("process must start with preheat");

    if (steps[steps.len - 1].phase != .quench and steps[steps.len - 1].phase != .cool_down)
        @compileError("process must end with cool_down or quench");

    for (1..steps.len) |i| {
        const delta = if (steps[i].target_temp_c > steps[i - 1].target_temp_c)
            steps[i].target_temp_c - steps[i - 1].target_temp_c
        else
            steps[i - 1].target_temp_c - steps[i].target_temp_c;

        if (delta > 200)
            @compileError(std.fmt.comptimePrint(
                "temperature change of {}C between steps {} and {} exceeds 200C max delta",
                .{ delta, i - 1, i },
            ));
    }
}

const annealing_process = blk: {
    const steps = [_]ProcessStep{
        .{ .phase = .preheat, .target_temp_c = 200, .hold_time_seconds = 600, .ramp_rate_c_per_min = 50 },
        .{ .phase = .ramp_up, .target_temp_c = 400, .hold_time_seconds = 300, .ramp_rate_c_per_min = 30 },
        .{ .phase = .ramp_up, .target_temp_c = 550, .hold_time_seconds = 300, .ramp_rate_c_per_min = 20 },
        .{ .phase = .soak, .target_temp_c = 600, .hold_time_seconds = 3600, .ramp_rate_c_per_min = 5 },
        .{ .phase = .cool_down, .target_temp_c = 400, .hold_time_seconds = 1800, .ramp_rate_c_per_min = 10 },
        .{ .phase = .cool_down, .target_temp_c = 200, .hold_time_seconds = 1800, .ramp_rate_c_per_min = 10 },
        .{ .phase = .cool_down, .target_temp_c = 25, .hold_time_seconds = 3600, .ramp_rate_c_per_min = 5 },
    };
    validateHeatTreatProcess(&steps);
    break :blk steps;
};

test "annealing process follows temperature limits" {
    comptime {
        try std.testing.expectEqual(7, annealing_process.len);
        try std.testing.expectEqual(ProcessPhase.preheat, annealing_process[0].phase);
        try std.testing.expectEqual(ProcessPhase.cool_down, annealing_process[annealing_process.len - 1].phase);
    }
}

// --- Beverage Recipe ---

const Ingredient = struct {
    id: u8,
    amount_ml: u16,
    temp_c: u8,
    dispense_time_ms: u16,
};

fn validateBeverageRecipe(comptime recipe: []const Ingredient) void {
    constraints.assert(constraints.lenInRange(1, 8, recipe.len));

    var total_ml: u32 = 0;
    var ids: [recipe.len]u8 = undefined;
    for (recipe, 0..) |ing, i| {
        constraints.assert(constraints.inRange(1, 500, ing.amount_ml));
        constraints.assert(constraints.inRange(4, 100, ing.temp_c));
        constraints.assert(constraints.nonZero(ing.dispense_time_ms));
        total_ml += ing.amount_ml;
        ids[i] = ing.id;
    }
    constraints.assert(constraints.noDuplicates(u8, &ids));
    constraints.assert(constraints.inRange(100, 1000, total_ml));
}

const espresso = blk: {
    const recipe = [_]Ingredient{
        .{ .id = 1, .amount_ml = 30, .temp_c = 93, .dispense_time_ms = 25000 },
        .{ .id = 2, .amount_ml = 200, .temp_c = 85, .dispense_time_ms = 5000 },
    };
    validateBeverageRecipe(&recipe);
    break :blk recipe;
};

test "espresso recipe has valid ingredients" {
    comptime {
        try std.testing.expectEqual(2, espresso.len);
        var total: u32 = 0;
        for (espresso) |ing| total += ing.amount_ml;
        try std.testing.expectEqual(230, total);
    }
}
