# data_gen

Constraint-based data generation framework.

Provides composable constraints that can validate whether data matches
specified rules. Uses no external dependencies.

## Usage

```zig
const DataGen = @import("data_gen").DataGen;
const Constraint = DataGen.Constraint;

const range = Constraint.in_range(0, 100);
const valid = try range.evaluate(@as(i32, 42)); // true

const elements = Constraint.array_elements(&Constraint.in_range(0, 10));
const ok = try elements.evaluate([_]i32{ 1, 5, 8 }); // true
```

## Build

```bash
zig build test  # Run unit tests
```
