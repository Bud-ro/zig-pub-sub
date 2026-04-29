pub const DataGen = @import("data_gen.zig");
pub const Constraint = DataGen.Constraint;
pub const ConstraintType = DataGen.ConstraintType;
pub const Range = DataGen.Range;
pub const StructConstraint = DataGen.StructConstraint;
pub const examples = @import("examples.zig");

test {
    _ = @import("tests/data_gen_test.zig");
}
