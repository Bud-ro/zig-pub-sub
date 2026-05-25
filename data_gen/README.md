# data_gen

Constraint-based data generation framework.

Provides compile-time validation, transformation, and generation of structured data. 
Functions designed to be used at `comptime`, but can also be used in
runtime contexts as well.

## Concepts

- **constraint**: primitive checks. Each returns `?[]const u8`
  (null = passed, a string = error message).
- **contract**: protocol for types that carry their own validation.
  A type opts in by declaring
  `pub fn contractValidate(comptime self: T) ?[]const u8`.
  `assertValid` / `validated` descend through struct fields, array and
  slice elements, single-item pointers, present optionals, and the
  active variant of tagged unions, invoking `contractValidate` on every
  reachable type that has one.
- **transform**: convert human-readable units (floats, percentages,
  frequencies) into machine representations (fixed-point, scaled
  integers, tick counts). Compile error if not exactly representable,
  with the two nearest representable values in the message.
- **generator**: comptime array generators (`generateArray`) for
  lookup tables, calibration arrays, repeated configs.

## Usage

```zig
const constraint = @import("data_gen").constraint;
const contract = @import("data_gen").contract;

// Primitive constraints - comptime, return null on pass.
comptime {
    if (constraint.inRange(0, 100, 42)) |err| @compileError(err);
    if (constraint.isPowerOfTwo(1024)) |err| @compileError(err);
}

// Recursive struct validation via contractValidate.
const Sensor = struct {
    min: i16,
    max: i16,

    pub fn contractValidate(comptime self: Sensor) ?[]const u8 {
        if (self.min >= self.max) return "min must be less than max";
        return null;
    }
};

const sensor = comptime contract.validated(Sensor{ .min = -40, .max = 125 });
```

## Build

```bash
zig build test  # Run unit tests, including the comptime examples in tests/examples/
```
