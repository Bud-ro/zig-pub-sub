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

    const my_int: i32 = 2;
    const my_array = [_]i64{ 0, 2, 3, 4 };

    try std.testing.expectEqual(true, constraint.evaluate(my_array));
    try std.testing.expectEqual(true, constraint.evaluate([_]i32{ 0, 1, 2, 3 }));
    try std.testing.expectEqual(false, constraint.evaluate([_]f32{ 0.2, 1.1, 2.3 }));

    // TODO: Should we support slices separately, or are they "close enough" to arrays?
    try std.testing.expectError(error.IncompatibleType, constraint.evaluate(&my_array));
    try std.testing.expectError(error.IncompatibleType, constraint.evaluate(.{ 1, 2, 3, 4 })); // TODO: Should we support tuples separately?
    try std.testing.expectError(error.IncompatibleType, constraint.evaluate(.{ 1, 2, 3 }));
    try std.testing.expectError(error.IncompatibleType, constraint.evaluate(2));
    try std.testing.expectError(error.IncompatibleType, constraint.evaluate(&my_int));
    try std.testing.expectError(error.IncompatibleType, constraint.evaluate(3.1));
}

test "Array Elements Constraint" {
    // TODO: Figure out a method for building `Constraint`s, since this has issues
    // with dangling pointers
    const constraint = Constraint.array_elements(&Constraint.in_range(0.1, 3));

    try std.testing.expectEqual(true, constraint.evaluate([_]i32{ 1, 2, 3, 3, 3, 1, 1, 2 }));
    try std.testing.expectEqual(true, constraint.evaluate([_]u32{ 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3 }));
    try std.testing.expectEqual(true, constraint.evaluate([_]f32{ 0.1, 0.2, 0.1, 0.1000001 }));
    try std.testing.expectEqual(true, constraint.evaluate([_]comptime_float{ 0.1, 0.2, 0.1, 0.1000001 }));
    try std.testing.expectEqual(true, constraint.evaluate([_]comptime_int{ 1, 2, 3, 3 }));

    try std.testing.expectEqual(false, constraint.evaluate([_]i32{ -1, 1, -1, 2 }));
    try std.testing.expectEqual(false, constraint.evaluate([_]i32{ 0, 1, 2, 2 }));
    try std.testing.expectEqual(false, constraint.evaluate([_]i32{ 1, 4, 2, 2 }));
    try std.testing.expectEqual(false, constraint.evaluate([_]f32{ 1.4, 1.2, 1.3, 0.09 }));

    const my_int: i32 = 2;
    try std.testing.expectError(error.IncompatibleType, constraint.evaluate(1));
    try std.testing.expectError(error.IncompatibleType, constraint.evaluate(.{ 1, 2, 3, 4 })); // TODO: Should we support tuples separately?
    try std.testing.expectError(error.IncompatibleType, constraint.evaluate(&my_int));
    try std.testing.expectError(error.IncompatibleType, constraint.evaluate(3.1));
    try std.testing.expectError(error.IncompatibleType, constraint.evaluate([_]bool{ false, false, true }));
}

test "Null ptr constraint" {
    const constraint = Constraint.null_ptr();

    const my_int: i32 = 2;
    const my_null_ptr: ?*i32 = null;

    const my_zero_ptr: *allowzero i32 = @ptrFromInt(0);
    const my_allow_zero_ptr_that_isnt_zero: *allowzero const i32 = &my_int;

    try std.testing.expectEqual(false, constraint.evaluate(&my_int));
    try std.testing.expectEqual(true, constraint.evaluate(null));
    try std.testing.expectEqual(true, constraint.evaluate(my_null_ptr));
    try std.testing.expectEqual(true, constraint.evaluate(my_zero_ptr));
    try std.testing.expectEqual(false, constraint.evaluate(my_allow_zero_ptr_that_isnt_zero));
    try std.testing.expectError(error.IncompatibleType, constraint.evaluate(2));
    try std.testing.expectError(error.IncompatibleType, constraint.evaluate(3.1));
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
