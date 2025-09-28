//! Module for constrained data generation

// Plan
// 1. Define the interface for the following (they can be mixins, functions on structs, etc.)
//   - Core types:
//     - slice (no arrays,) pointer, `nullptr`, `extern struct`, integers
// 2. Define how memoization will fit into this (all pointers get memoized by default?, what else?)
// 3. Use Zig code for all definitions
// 4. Constraints that work alongside the base Zig type checking (so users don't have to specify type-checking in the constraint system)
//   - Constraints as a list of functions: &[constraint.ored(constraint.array_len(3), constraint.array_len(0)), constraint.array_elements(&[constraint.in_set(my_enum)])]
// 5. Try to avoid `anytype` and `comptime` as much as possible
//   - This should be easy to debug, and easy to understand
// 6. Try to keep a single source of truth. It's going to be inconvenient if constraints are defined sometimes on
//    types themselves, and other times in a totally different file.
// 7. (Bonus) Add a visualizer for constraints

const std = @import("std");

pub const ConstraintType = enum {
    _anded,
    _ored,
    _array_len,
    _array_elements,
    // _slice_len,
    // _slice_elements,
    // _struct_fields,
    _null_ptr,
    // equal_to,
    _in_range,
};

pub const Range = struct {
    min: comptime_float,
    max: comptime_float,
};

pub const StructConstraint = struct {
    fieldName: []const u8,
    constraint: *const Constraint,
};

// TODO: This seems *okay* for checking the data in non-structs, but tbh
// since *all* the data will live under at least one struct, probably multiple, it might be
// better to axe this and just define constraints as functions rather than data (see example.zig).
// This approach is only good if you want to leave types untouched and define all the constraints
// externally (which loses out on some key benefits).
pub const Constraint = union(ConstraintType) {
    _anded: []const Constraint,
    _ored: []const Constraint,
    _array_len: usize,
    _array_elements: *const Constraint,
    // slice_len: usize,
    // slice_elements: *const Constraint,
    struct_fields: []const StructConstraint,
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

    pub fn array_elements(constraint: *const Constraint) Constraint {
        return Constraint{ ._array_elements = constraint };
    }

    pub fn null_ptr() Constraint {
        return Constraint{ ._null_ptr = void{} };
    }

    pub fn in_range(min: comptime_float, max: comptime_float) Constraint {
        return Constraint{ ._in_range = .{ .min = min, .max = max } };
    }

    // Evaluates whether the data matches the constraint
    pub fn evaluate(constraint: Constraint, comptime data: anytype) !bool {
        switch (constraint) {
            ._anded => @panic("Unimplemented"),
            ._ored => @panic("Unimplemented"),
            ._array_len => {
                switch (@typeInfo(@TypeOf(data))) {
                    .array => return data.len == constraint._array_len,
                    else => return error.IncompatibleType,
                }
            },
            ._array_elements => {
                switch (@typeInfo(@TypeOf(data))) {
                    .array => {
                        inline for (data) |elem| {
                            const result = try constraint._array_elements.evaluate(elem);
                            if (!result) {
                                return false;
                            }
                        }
                        return true;
                    },
                    else => return error.IncompatibleType,
                }
            },
            ._null_ptr => {
                switch (@typeInfo(@TypeOf(data))) {
                    .null => return true,
                    .pointer => |info| {
                        if (info.is_allowzero) {
                            return @intFromPtr(data) == 0; // In Zig, null always means zero
                        } else {
                            return false;
                        }
                    }, // Non-optional
                    .optional => |typeInfo| {
                        switch (@typeInfo(typeInfo.child)) {
                            .pointer => return data == null,
                            else => return error.IncompatibleType,
                        }
                    },
                    else => return error.IncompatibleType,
                }
            },
            ._in_range => |range| {
                switch (@typeInfo(@TypeOf(data))) {
                    .int, .comptime_int, .float, .comptime_float => {
                        return range.min <= data and data <= range.max;
                    },
                    else => return error.IncompatibleType,
                }
            },
        }
    }
};
