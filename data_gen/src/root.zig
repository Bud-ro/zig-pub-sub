const std = @import("std");

// --- Types ---
pub const Constraint = constraint_mod.Constraint;
pub const ConstraintType = constraint_mod.ConstraintType;
pub const Range = constraint_mod.Range;
pub const StructConstraint = constraint_mod.StructConstraint;

const constraint_mod = @import("data_gen.zig");

test {
    std.testing.refAllDecls(@This());
    _ = @import("tests/data_gen_test.zig");
}
