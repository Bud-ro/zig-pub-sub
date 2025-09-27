//! Module for constrained data generation

// Plan
// 1. Define the interface for the following (they can be mixins, functions on structs, etc.)
//   - Core types:
//     - slice (no arrays,) pointer, `nullptr`, `extern struct`, integers
// 2. Define how memoization will fit into this (all pointers get memoized by default, what else?)
// 3. Use Zig code for all definitions
// 4. Constraints that work alongside the base Zig type checking (so users don't have to specify type-checking in the constraint system)
//   - Constraints as a list of functions: &[constraint.ored(constraint.array_len(3), constraint.array_len(0)), constraint.array_elements(&[constraint.in_set(my_enum)])]
// 5. Try to avoid `anytype` and `comptime` as much as possible
//   - This should be easy to debug, and easy to understand

const std = @import("std");

pub const ConstraintType = enum {
    _anded,
    _ored,
    _array_len,
    _array_elements,
    _null_ptr,
    // equal_to,
    _in_range,
};

pub const Range = struct {
    min: comptime_int,
    max: comptime_int,
};

pub const Constraint = union(ConstraintType) {
    _anded: []const Constraint,
    _ored: []const Constraint,
    _array_len: usize,
    _array_elements: []const Constraint,
    _null_ptr: void,
    // equal_to: Value,
    _in_range: Range,

    pub fn anded(constraints: []const Constraint) Constraint {
        return Constraint{ ._anded = constraints };
    }

    pub fn ored(constraints: []const Constraint) Constraint {
        return Constraint{ ._ored = constraints };
    }

    pub fn array_len(len: usize) Constraint {
        return Constraint{ ._array_len = len };
    }

    pub fn array_elements(constraints: []const Constraint) Constraint {
        return Constraint{ ._array_elements = constraints };
    }

    pub fn null_ptr() Constraint {
        return Constraint{ ._null_ptr = void{} };
    }

    pub fn in_range(min: comptime_int, max: comptime_int) Constraint {
        return Constraint{ ._in_range = .{ .min = min, .max = max } };
    }

    // Evaluates whether the data matches the constraint
    pub fn evaluate(constraint: Constraint, comptime data: anytype) !bool {
        switch (constraint) {
            ._anded => @panic("Unimplemented"),
            ._ored => @panic("Unimplemented"),
            ._in_range => |range| {
                switch (@typeInfo(@TypeOf(data))) {
                    .int, .comptime_int, .float, .comptime_float => {
                        return range.min <= data and data <= range.max;
                    },
                    else => return error.IncompatibleType,
                }
                std.debug.assert();
            },
            else => @panic("Unimplemented"),
        }
    }
};
