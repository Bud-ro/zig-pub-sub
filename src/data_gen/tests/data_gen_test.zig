const DataGen = @import("../data_gen.zig");
const Constraint = DataGen.Constraint;

const std = @import("std");

test "Anded Constraint" {
    const multi_constraint = Constraint.anded(&[_]Constraint{ Constraint.in_range(0, 2), Constraint.in_range(0, 3) });
    try std.testing.expectEqual(multi_constraint._anded[0]._in_range.max, 2);
    try std.testing.expectEqual(multi_constraint._anded[1]._in_range.max, 3);
}

test "Ored Constraint" {
    const multi_constraint = Constraint.ored(&[_]Constraint{ Constraint.in_range(0, 2), Constraint.in_range(0, 3) });
    try std.testing.expectEqual(multi_constraint._ored[0]._in_range.max, 2);
    try std.testing.expectEqual(multi_constraint._ored[1]._in_range.max, 3);
}

test "Array Length Constraint" {
    const constraint = Constraint.array_len(4);
    try std.testing.expectEqual(constraint._array_len, 4);
}

test "Array Elements Constraint" {
    const constraint = Constraint.array_elements(&[_]Constraint{Constraint.null_ptr()});
    switch (constraint._array_elements[0]) {
        ._null_ptr => return,
        else => return error.testFailure,
    }
}

test "Null ptr constraint" {
    const constraint = Constraint.null_ptr();
    switch (constraint) {
        ._null_ptr => return,
        else => return error.testFailure,
    }
}

test "Range constraint" {
    const range_constraint = Constraint.in_range(0, 3);
    try std.testing.expectEqual(range_constraint._in_range.min, 0);
    try std.testing.expectEqual(range_constraint._in_range.max, 3);

    try std.testing.expectEqual(false, range_constraint.evaluate(@as(i32, -20)));
    try std.testing.expectEqual(false, range_constraint.evaluate(-1));
    try std.testing.expectEqual(true, range_constraint.evaluate(0));
    try std.testing.expectEqual(true, range_constraint.evaluate(@as(i32, 1)));
    try std.testing.expectEqual(true, range_constraint.evaluate(@as(u32, 2)));
    try std.testing.expectEqual(true, range_constraint.evaluate(@as(f32, 2.4)));
    try std.testing.expectEqual(true, range_constraint.evaluate(3));
    try std.testing.expectEqual(false, range_constraint.evaluate(4));

    const MyStruct = struct { a: i32 };
    const MyEnum = enum { a, b, c };
    try std.testing.expectError(error.IncompatibleType, range_constraint.evaluate(MyStruct{ .a = 2 }));
    try std.testing.expectError(error.IncompatibleType, range_constraint.evaluate(MyEnum.a));
    try std.testing.expectError(error.IncompatibleType, range_constraint.evaluate(u32));
}
